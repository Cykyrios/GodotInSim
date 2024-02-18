class_name InSimSPXPacket
extends InSimPacket

## SPlit X time packet

const TIME_MULTIPLIER := 1000.0
const FUEL_MULTIPLIER := 2.0

const PACKET_SIZE := 16
const PACKET_TYPE := InSim.Packet.ISP_SPX
var player_id := 0  ## player's unique id

var split_time := 0  ## split time (ms)
var elapsed_time := 0  ## total time (ms)

var split := 0  ## split number 1, 2, 3
var penalty := InSim.Penalty.PENALTY_NONE  ## current penalty value (see [enum InSim.Penalty])
var num_stops := 0  ## number of pit stops
var fuel200 := 0  ## /showfuel yes: double fuel percent / no: 255

var gis_split_time := 0.0
var gis_elapsed_time := 0.0
var gis_fuel := 0.0


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


func _update_gis_values() -> void:
	gis_split_time = split_time / TIME_MULTIPLIER
	gis_elapsed_time = elapsed_time / TIME_MULTIPLIER
	gis_fuel = fuel200 / FUEL_MULTIPLIER if fuel200 != 255 else -1.0
