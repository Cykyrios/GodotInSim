class_name InSimLAPPacket
extends InSimPacket

## LAP time packet

const TIME_MULTIPLIER := 1000.0
const FUEL_MULTIPLIER := 2.0

const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_LAP
var plid := 0  ## player's unique id

var lap_time := 0  ## lap time (ms)
var elapsed_time := 0  ## total time (ms)

var laps_done := 0  ## laps completed
var flags := 0  ## player flags

var sp0 := 0
var penalty := InSim.Penalty.PENALTY_NONE  ## current penalty value (see [enum InSim.Penalty])
var num_stops := 0  ## number of pit stops
var fuel200 := 0  ## /showfuel yes: double fuel percent / no: 255

var gis_lap_time := 0.0
var gis_elapsed_time := 0.0
var gis_fuel := 0.0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	plid = read_byte()
	lap_time = read_unsigned()
	elapsed_time = read_unsigned()
	laps_done = read_word()
	flags = read_word()
	sp0 = read_byte()
	penalty = read_byte() as InSim.Penalty
	num_stops = read_byte()
	fuel200 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"LTime": lap_time,
		"ETime": elapsed_time,
		"LapsDone": laps_done,
		"Flags": flags,
		"Sp0": sp0,
		"Penalty": penalty,
		"NumStops": num_stops,
		"Fuel200": fuel200,
	}


func _update_gis_values() -> void:
	gis_lap_time = lap_time / TIME_MULTIPLIER
	gis_elapsed_time = elapsed_time / TIME_MULTIPLIER
	gis_fuel = fuel200 / FUEL_MULTIPLIER if fuel200 != 255 else -1.0
