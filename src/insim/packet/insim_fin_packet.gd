class_name InSimFINPacket
extends InSimPacket


const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_FIN
var player_id := 0

var race_time := 0
var best_lap := 0

var sp_a := 0
var num_stops := 0
var confirm := 0
var sp_b := 0

var laps_done := 0
var flags := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte(packet)
	race_time = read_unsigned(packet)
	best_lap = read_unsigned(packet)
	sp_a = read_byte(packet)
	num_stops = read_byte(packet)
	confirm = read_byte(packet)
	sp_b = read_byte(packet)
	laps_done = read_word(packet)
	flags = read_word(packet)


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"TTime": race_time,
		"BTime": best_lap,
		"SpA": sp_a,
		"NumStops": num_stops,
		"Confirm": confirm,
		"SpB": sp_b,
		"LapsDone": laps_done,
		"Flags": flags,
	}
