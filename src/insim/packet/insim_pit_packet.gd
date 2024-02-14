class_name InSimPITPacket
extends InSimPacket

## PIT stop packet

const MAX_TYRES := 4

const PACKET_SIZE := 24
const PACKET_TYPE := InSim.Packet.ISP_PIT
var player_id := 0  ## player's unique id

var laps_done := 0  ## laps completed
var flags := 0  ## player flags

var fuel_add := 0  ## /showfuel yes: fuel added percent / no: 255
var penalty := InSim.Penalty.PENALTY_NONE  ## current penalty (see [enum InSim.Penalty])
var num_stops := 0  ## number of pit stops
var sp3 := 0

var tyres: Array[int] = []  ## tyres changed

var work := 0  ## pit work (see [enum InSim.PitWork])
var spare := 0


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
	laps_done = read_word()
	flags = read_word()
	fuel_add = read_byte()
	penalty = read_byte() as InSim.Penalty
	num_stops = read_byte()
	sp3 = read_byte()
	tyres.clear()
	for i in MAX_TYRES:
		tyres.append(read_byte())
	work = read_unsigned()
	spare = read_unsigned()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"LapsDone": laps_done,
		"Flags": flags,
		"FuelAdd": fuel_add,
		"Penalty": penalty,
		"NumStops": num_stops,
		"Sp3": sp3,
		"Tyres": tyres,
		"Work": work,
		"Spare": spare,
	}
