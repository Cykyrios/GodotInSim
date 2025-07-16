extends MarginContainer

const COLOR_IN := 0x00ff00ff
const COLOR_OUT := 0xff0000ff

var insim: InSim = null

@onready var label: RichTextLabel = %Label


func _ready() -> void:
	insim = InSim.new()
	add_child(insim)
	var _connect := insim.packet_received.connect(_on_packet_received)
	_connect = insim.packet_sent.connect(_on_packet_sent)

	insim.initialize(
		"127.0.0.1",
		29_999,
		InSimInitializationData.create(
			"Packet Logger",
			InSim.InitFlag.ISF_LOCAL,
		)
	)


func _on_packet_received(packet: InSimPacket) -> void:
	log_incoming_packet(packet)


func _on_packet_sent(packet: InSimPacket, sender: String) -> void:
	log_outgoing_packet(packet, sender)


func get_log_packet_to_screen(packet: InSimPacket, sender := "") -> String:
	var packet_string := "%s %s %s: %s" % [
		get_timestamp(),
		get_packet_direction(sender),
		packet.get_type_string(),
		packet.get_pretty_text()
	]
	packet_string = replace_plid_ucid(packet_string, packet)
	return packet_string


func get_packet_direction(sender := "") -> String:
	var incoming_packet := sender.is_empty()
	return "[color=#%s]%s[/color]" % [
		Color.hex(COLOR_IN if incoming_packet else COLOR_OUT).to_html(false),
		"▼" if incoming_packet else "▲ %s" % [sender],
	]


func get_timestamp() -> String:
	return Time.get_datetime_string_from_system(false, true)


func log_incoming_packet(packet: InSimPacket) -> void:
	var packet_string := get_log_packet_to_screen(packet)
	if packet is InSimSTAPacket:
		packet_string += ": %s" % [insim.lfs_state.get_state_changes(packet as InSimSTAPacket)]
	label.append_text(
		LFSText.remove_double_carets(LFSText.colors_lfs_to_bbcode(packet_string)) + "\n"
	)
	if packet.type != InSim.Packet.ISP_MSO:
		insim.send_local_message(
			LFSText.remove_double_carets(LFSText.colors_bbcode_to_lfs(packet_string))
		)


func log_outgoing_packet(packet: InSimPacket, sender: String) -> void:
	var packet_string := get_log_packet_to_screen(packet, sender)
	label.append_text(
		LFSText.remove_double_carets(LFSText.colors_lfs_to_bbcode(packet_string)) + "\n"
	)
	if packet.type not in [
		InSim.Packet.ISP_MSL,
		InSim.Packet.ISP_MST,
		InSim.Packet.ISP_MSX,
		InSim.Packet.ISP_MTC,
	]:
		insim.send_local_message(
			LFSText.remove_double_carets(LFSText.colors_bbcode_to_lfs(packet_string))
		)


func replace_plid_ucid(text: String, packet: InSimPacket) -> String:
	if text.contains("PLID"):
		if packet is InSimNPLPacket:
			var npl_packet := packet as InSimNPLPacket
			var packet_plid := "PLID %d" % [npl_packet.plid]
			if (
				text.contains(packet_plid)
				and not insim.players.has(npl_packet.plid)
			):
				text = text.replace(
					packet_plid,
					npl_packet.player_name + LFSText.get_color_code(LFSText.ColorCode.DEFAULT)
				)
			else:
				text = LFSText.replace_plid_with_name(text, insim)
			if not (insim.lfs_state.flags & InSim.State.ISS_GAME):
				text = text.replace("left the pits", "joined the grid")
				text = text.replace("is driving", "is on the grid")
		else:
			text = LFSText.replace_plid_with_name(text, insim)
	if text.contains("UCID"):
		if packet is InSimNCNPacket:
			var ncn_packet := packet as InSimNCNPacket
			var packet_ucid := "UCID %d" % [ncn_packet.ucid]
			if (
				text.contains(packet_ucid)
				and not insim.connections.has(ncn_packet.ucid)
			):
				text = text.replace(packet_ucid, "%s%s" % [
					ncn_packet.player_name + LFSText.get_color_code(LFSText.ColorCode.DEFAULT),
					"" if ncn_packet.user_name.is_empty() else " (%s)" % [ncn_packet.user_name]
				])
			else:
				text = LFSText.replace_ucid_with_name(text, insim, packet.req_i != 0)
		elif packet is InSimCPRPacket:
			var regex := LFSText.get_regex_ucid()
			var ucid := regex.search(text).strings[1].to_int()
			var plid := 0
			for key in insim.players:
				if insim.players[key].ucid == ucid:
					plid = key
			text = regex.sub(text, "PLID %d" % [plid])
			text = replace_plid_ucid(text, packet)
		else:
			var show_username := true if (
				packet.req_i != 0
				or packet is InSimNCIPacket
			) else false
			text = LFSText.replace_ucid_with_name(text, insim, show_username)
	return text
