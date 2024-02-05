class_name InSimSPXPacket
extends InSimPacket


const PACKET_SIZE := 16
const PACKET_TYPE := InSim.Packet.ISP_SPX
var player_id := 0

var split_time := 0
var elapsed_time := 0

var split := 0
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
	player_id = read_byte()
	split_time = read_unsigned()
	elapsed_time = read_unsigned()
	split = read_byte()
	penalty = read_byte() as InSim.Penalty
	num_stops = read_byte()
	fuel200 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"STime": split_time,
		"ETime": elapsed_time,
		"Split": split,
		"Penalty": penalty,
		"NumStops": num_stops,
		"Fuel200": fuel200,
	}
