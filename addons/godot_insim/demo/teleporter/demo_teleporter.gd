extends MarginContainer


var insim: InSim = null
var custom_spawn_points: Array[ObjectInfo] = [
	ObjectInfo.create_from_gis(Vector3(-108.69, 208.56, 9.25), deg_to_rad(168.8), 0x80, 0),
	ObjectInfo.create_from_gis(Vector3(128.81, 487.81, 14.75), deg_to_rad(-164.5), 0x80, 0),
	ObjectInfo.create_from_gis(Vector3(125.06, -749.81, 2.00), deg_to_rad(-66.1), 0x80, 0),
]


func _ready() -> void:
	insim = InSim.new()
	add_child(insim)
	var _connect := insim.isp_mso_received.connect(_on_mso_received)
	_connect = insim.isp_iii_received.connect(_on_iii_received)

	insim.initialize(
		"127.0.0.1",
		29_999,
		InSimInitializationData.create(
			"Teleporter",
			"",
			0,
			"!"
		)
	)


func _on_mso_received(packet: InSimMSOPacket) -> void:
	# Check for prefix, using MSO_PREFIX (easiest solution) or checking for actual
	# message contents (this can also work for multiple prefixes)
	var message := packet.msg.substr(LFSText.get_mso_start(packet, insim))
	#if message.begins_with(insim.initialization_data.prefix):
	if packet.user_type == InSim.MessageUserValue.MSO_PREFIX:
		var command := message.trim_prefix(insim.initialization_data.prefix).lstrip(" ")
		parse_command(packet.plid, command)


func _on_iii_received(packet: InSimIIIPacket) -> void:
	parse_command(packet.plid, packet.msg.lstrip(" "))


# Note: This demo only parses commands from drivers (PLID), you should probably add
# UCID support for commands that do not require to be driving.
func parse_command(plid: int, command: String) -> void:
	if command.begins_with("teleport"):
		var predefined_location := false
		var valid_location := true
		var x := randi_range(-1000, 1000) as float
		var y := randi_range(-1000, 1000) as float
		var z := randi_range(0, 60) as float
		var object_info := ObjectInfo.new()
		object_info.gis_position = Vector3(x, y, z)
		object_info.gis_heading = 0
		object_info.flags |= 0x80
		var regex := RegEx.create_from_string(
			r"teleport +\((-?\d*\.?\d*), *(-?\d*\.?\d*)(?:, *(-?\d*\.?\d*))?\)"
		)
		var regex_result := regex.search(command)
		if regex_result:
			x = regex_result.strings[1].to_float()
			y = regex_result.strings[2].to_float()
			if regex_result.strings[3] != "":
				z = regex_result.strings[3].to_float()
			object_info.gis_position = Vector3(x, y, z)
		else:
			regex = RegEx.create_from_string(r"teleport +(\w+)")
			regex_result = regex.search(command)
			if regex_result:
				predefined_location = true
				match regex_result.strings[1]:
					"service":
						object_info = custom_spawn_points[0]
					"chicane":
						object_info = custom_spawn_points[1]
					"ambulance":
						object_info = custom_spawn_points[2]
					_:
						predefined_location = false
						valid_location = false
		object_info.set_values_from_gis()
		var message := "Teleporting to %s" % [
				regex_result.strings[1] if predefined_location
				else "%.0v" % [object_info.gis_position]
			] if valid_location else "Invalid target for teleport"
		if insim.lfs_state.flags & InSim.State.ISS_MULTI:
			insim.send_message_to_player(plid, message, InSim.MessageSound.SND_SYSMESSAGE)
		else:
			insim.send_local_message(message, InSim.MessageSound.SND_SYSMESSAGE)
		if not valid_location:
			return
		insim.send_packet(
			InSimJRRPacket.create(plid, 0, InSim.JRRAction.JRR_RESET_NO_REPAIR, object_info)
		)
