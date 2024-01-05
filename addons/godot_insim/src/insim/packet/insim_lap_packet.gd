class_name InSimLAPPacket
extends InSimPacket


const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_LAP
var player_id := 0

var lap_time := 0
var elapsed_time := 0

var laps_done := 0
var flags := 0

var sp0 := 0
var penalty := InSim.Penalty.PENALTY_NONE
var num_stops := 0
var fuel200 := 0


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
	lap_time = read_unsigned(packet)
	elapsed_time = read_unsigned(packet)
	laps_done = read_word(packet)
	flags = read_word(packet)
	sp0 = read_byte(packet)
	penalty = read_byte(packet) as InSim.Penalty
	num_stops = read_byte(packet)
	fuel200 = read_byte(packet)


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"LTime": lap_time,
		"ETime": elapsed_time,
		"LapsDone": laps_done,
		"Flags": flags,
		"Sp0": sp0,
		"Penalty": penalty,
		"NumStops": num_stops,
		"Fuel200": fuel200,
	}
