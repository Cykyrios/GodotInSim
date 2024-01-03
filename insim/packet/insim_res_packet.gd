class_name InSimRESPacket
extends InSimPacket


const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_RES
var player_id := 0

var username := ""
var player_name := ""
var plate := ""
var car_name := ""

var total_time := 0
var best_lap := 0

var sp_a := 0
var num_stops := 0
var confirm := 0
var sp_b := 0

var laps_done := 0
var flags := 0

var result_num := 0
var num_results := 0
var penalty_seconds := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _get_data_dictionary() -> Dictionary:
	var data := {
		"PLID": player_id,
		"UName": username,
		"PName": player_name,
		"Plate": plate,
		"CName": car_name,
		"TTime": total_time,
		"BTime": best_lap,
		"SpA": sp_a,
		"NumStops": num_stops,
		"Confirm": confirm,
		"SpB": sp_b,
		"LapsDone": laps_done,
		"Flags": flags,
		"ResultNum": result_num,
		"NumRes": num_results,
		"PSeconds": penalty_seconds,
	}
	return data


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte(packet)
	username = read_string(packet, 24)
	player_name = read_string(packet, 24)
	plate = read_string(packet, 8)
	car_name = read_string(packet, 4)
	total_time = read_unsigned(packet)
	best_lap = read_unsigned(packet)
	sp_a = read_byte(packet)
	num_stops = read_byte(packet)
	confirm = read_byte(packet)
	sp_b = read_byte(packet)
	laps_done = read_word(packet)
	flags = read_word(packet)
	result_num = read_byte(packet)
	num_results = read_byte(packet)
	penalty_seconds = read_word(packet)
