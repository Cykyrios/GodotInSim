extends MarginContainer

var insim: InSim = null
var req_i := 1

@onready var host_list: GridContainer = %HostList
@onready var connection_list: VBoxContainer = %ConnectionList


func _ready() -> void:
	clear_host_list()
	clear_connection_list()

	insim = InSim.new()
	add_child(insim)
	var _connect := insim.connected.connect(refresh_host_list)
	_connect = insim.isp_ncn_received.connect(_on_ncn_received)
	_connect = insim.irp_hos_received.connect(_on_hos_received)

	insim.initialize(
		InSim.RELAY_ADDRESS,
		InSim.RELAY_PORT,
		InSimInitializationData.new(),  # Empty init data as we don't actually need it
	)


func add_host_info(host_info: HostInfo) -> void:
	var license := "D" if not host_info.flags & InSim.RelayFlag.HOS_LICENSED \
			else "S%d" % [
				1 if host_info.flags & InSim.RelayFlag.HOS_S1 \
				else 2 if host_info.flags & InSim.RelayFlag.HOS_S2 \
				else 3
			]
	var cruise := "Yes" if host_info.flags & InSim.RelayFlag.HOS_CRUISE else "No"
	var spec_pass := "Yes" if host_info.flags & InSim.RelayFlag.HOS_SPECPASS else "No"
	add_host_info_fields(
		host_info.host_name, host_info.track, license, cruise, spec_pass, str(host_info.num_conns)
	)


func add_host_info_fields(
	host: String, track: String, license: String, cruise: String, spec_pass: String,
	connections: String
) -> void:
	var host_label := RichTextLabel.new()
	host_label.custom_minimum_size.x = 300
	host_label.scroll_active = false
	host_label.fit_content = true
	host_label.bbcode_enabled = true
	host_label.push_meta(host, RichTextLabel.META_UNDERLINE_ON_HOVER)
	host_label.append_text(LFSText.convert_colors(host, LFSText.ColorType.BBCODE))
	host_label.pop()
	var _connect := host_label.meta_clicked.connect(_on_host_name_clicked)
	host_list.add_child(host_label)
	var add_field := func add_field(text: String) -> Label:
		var label := Label.new()
		label.text = text
		return label
	host_list.add_child(add_field.call(track) as Label)
	host_list.add_child(add_field.call(license) as Label)
	host_list.add_child(add_field.call(cruise) as Label)
	host_list.add_child(add_field.call(spec_pass) as Label)
	host_list.add_child(add_field.call(connections) as Label)


func clear_connection_list() -> void:
	for child in connection_list.get_children():
		child.queue_free()
	var label := Label.new()
	label.text = "Connections"
	connection_list.add_child(label)


func clear_host_list() -> void:
	for child in host_list.get_children():
		child.queue_free()
	add_host_info_fields("Host Name", "Track", "License", "Cruise", "Spec Pass", "Connections")


func refresh_host_list() -> void:
	clear_host_list()
	insim.send_packet(RelayHLRPacket.create(req_i))


func _on_ncn_received(packet: InSimNCNPacket) -> void:
	var label := RichTextLabel.new()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.custom_minimum_size.x = 300
	label.fit_content = true
	label.scroll_active = false
	label.bbcode_enabled = true
	label.text = "UCID %d: %s" % [
		packet.ucid,
		LFSText.convert_colors(packet.player_name, LFSText.ColorType.BBCODE),
	]
	connection_list.add_child(label)


func _on_hos_received(packet: RelayHOSPacket) -> void:
	for i in packet.num_hosts:
		add_host_info(packet.host_info[i])


func _on_host_name_clicked(host_name: String) -> void:
	var packet := RelaySELPacket.create(req_i, host_name)
	insim.send_packet(packet)
	clear_connection_list()
	insim.send_packet(InSimTinyPacket.create(req_i, InSim.Tiny.TINY_NCN))
