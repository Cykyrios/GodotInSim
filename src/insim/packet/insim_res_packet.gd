class_name InSimRESPacket
extends InSimPacket


const USERNAME_MAX_LENGTH := 24
const PLAYER_NAME_MAX_LENGTH := 24
const PLATE_MAX_LENGTH := 8

const PACKET_SIZE := 84
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


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte()
	username = read_string(USERNAME_MAX_LENGTH)
	player_name = read_string(PLAYER_NAME_MAX_LENGTH)
	plate = read_string(PLAYER_NAME_MAX_LENGTH)
	car_name = read_car_name()
	total_time = read_unsigned()
	best_lap = read_unsigned()
	sp_a = read_byte()
	num_stops = read_byte()
	confirm = read_byte()
	sp_b = read_byte()
	laps_done = read_word()
	flags = read_word()
	result_num = read_byte()
	num_results = read_byte()
	penalty_seconds = read_word()


func _get_data_dictionary() -> Dictionary:
	return {
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
