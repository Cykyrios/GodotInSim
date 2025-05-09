extends MarginContainer


# This is where you define spawn points for each track
const SPAWN_DIR_EDITOR := "res://addons/godot_insim/demo/teleporter/spawn"
const SPAWN_DIR_STANDALONE := "res://spawn"

var insim: InSim = null
var current_track := ""
var spawn_points: Dictionary[String, Vector4] = {}


func _ready() -> void:
	insim = InSim.new()
	add_child(insim)
	var _connect := insim.isp_mso_received.connect(_on_mso_received)
	_connect = insim.isp_iii_received.connect(_on_iii_received)
	_connect = insim.isp_sta_received.connect(_on_sta_received)

	insim.initialize(
		"127.0.0.1",
		29_999,
		InSimInitializationData.create(
			"Teleporter",
			0,
			"!",
		)
	)

	if not Engine.is_editor_hint():
		var standalone_path := ProjectSettings.globalize_path(SPAWN_DIR_STANDALONE)
		DirAccess.make_dir_absolute(standalone_path)
		for file in DirAccess.get_files_at(SPAWN_DIR_EDITOR):
			var _error := DirAccess.copy_absolute(
				SPAWN_DIR_EDITOR.path_join(file),
				standalone_path.path_join(file),
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
		# Random location for base command "teleport"
		var x := randi_range(-1000, 1000) as float
		var y := randi_range(-1000, 1000) as float
		var z := randi_range(0, 60) as float
		var object_info := ObjectInfo.new()
		object_info.gis_position = Vector3(x, y, z)
		object_info.gis_heading = randf_range(-PI, PI)
		object_info.flags = 0x80
		# Custom location with "teleport (x, y, z)" or "teleport (x, y)"
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
			# Custom location with "teleport named spawn point"
			regex = RegEx.create_from_string(r"teleport +(.+)")
			regex_result = regex.search(command)
			if regex_result:
				predefined_location = true
				if regex_result.strings[1] in spawn_points:
					var spawn_data := spawn_points[regex_result.strings[1]]
					object_info.gis_position = Vector3(spawn_data.x, spawn_data.y, spawn_data.z)
					object_info.gis_heading = deg_to_rad(spawn_data.w)
					object_info.flags = 0x80
				else:
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


func _on_sta_received(packet: InSimSTAPacket) -> void:
	if packet.track == current_track:
		return
	current_track = packet.track
	var open_config := true if (
		current_track.ends_with("X") or current_track.ends_with("Y")
	) else false
	var spawn_directory := SPAWN_DIR_EDITOR if Engine.is_editor_hint() \
			else ProjectSettings.globalize_path(SPAWN_DIR_STANDALONE)
	var spawn_file := spawn_directory.path_join(
		"%s.txt" % [current_track.substr(0, 2) if open_config else current_track]
	)
	var file := FileAccess.open(spawn_file, FileAccess.READ)
	if not file:
		insim.send_local_message(
			"^3WARNING: No spawn point file for %s" % [current_track],
			InSim.MessageSound.SND_ERROR
		)
		return
	spawn_points.clear()
	var spawn_lines: Array[String] = []
	var dictionary_found := false
	while file.get_position() < file.get_length():
		var line := file.get_line()
		if dictionary_found:
			spawn_lines.append(line)
		elif line.begins_with("{"):
			dictionary_found = true
			continue
		elif line.begins_with("}"):
			break
	var spawn_regex := RegEx.create_from_string(
		r'"(.+?)" *: *\((-?\d*\.?\d*), *(-?\d*\.?\d*), *(-?\d*\.?\d*), *(-?\d*\.?\d*)\),?'
	)
	for string in spawn_lines:
		var result := spawn_regex.search(string)
		if result:
			spawn_points[result.strings[1]] = Vector4(
				result.strings[2].to_float(),
				result.strings[3].to_float(),
				result.strings[4].to_float(),
				result.strings[5].to_float()
			)
	insim.send_local_message(
		"^6INFO: Found %d spawn point(s) is %s" % [spawn_points.size(), spawn_file.get_file()]
	)
