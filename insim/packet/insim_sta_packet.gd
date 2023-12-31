class_name InSimSTAPacket
extends InSimPacket


var replay_speed := 0.0

var flags := 0
var ingame_cam := 0 # TODO: look for "view identifiers"
var view_player_id := 0

var num_players := 0
var num_connections := 0
var num_finished := 0
var race_in_progress := 0

var qual_mins := 0
var race_laps := 0
var sp2 := 0
var server_status := 0

var track := ""
var weather := 0
var wind := 0


func _init() -> void:
	size = 28
	type = InSim.Packet.ISP_STA
	req_i = 0
	super()


func _get_data_dictionary() -> Dictionary:
	var data := {
		"ReplaySpeed": replay_speed,
		"Flags": flags,
		"InGameCam": ingame_cam,
		"ViewPLID": view_player_id,
		"NumP": num_players,
		"NumConns": num_connections,
		"NumFinished": num_finished,
		"RaceInProg": race_in_progress,
		"QualMins": qual_mins,
		"RaceLaps": race_laps,
		"Sp2": sp2,
		"ServerStatus": server_status,
		"Track": track,
		"Weather": weather,
		"Wind": wind,
	}
	return data


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != size:
		push_error("ISP_VER packet expected size %d, got %d." % [size, packet_size])
		return
	replay_speed = read_float(packet)

	flags = read_word(packet)
	ingame_cam = read_byte(packet)
	view_player_id = read_byte(packet)

	num_players = read_byte(packet)
	num_connections = read_byte(packet)
	num_finished = read_byte(packet)
	race_in_progress = read_byte(packet)

	qual_mins = read_byte(packet)
	race_laps = read_byte(packet)
	sp2 = read_byte(packet)
	server_status = read_byte(packet)

	track = read_string(packet, 6)
	weather = read_byte(packet)
	wind = read_byte(packet)
