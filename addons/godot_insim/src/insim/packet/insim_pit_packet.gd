class_name InSimPITPacket
extends InSimPacket
## PIT stop packet
##
## This packet is received when a player makes a pit stop.

const _MAX_TYRES := 4

const PACKET_SIZE := 24  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_PIT  ## The packet's type, see [enum InSim.Packet].

var plid := 0  ## Player's unique id

var laps_done := 0  ## Number of laps completed
var flags := 0  ## Player flags

var fuel_add := 0  ## /showfuel yes: fuel added percent / no: 255
var penalty := InSim.Penalty.PENALTY_NONE  ## current penalty (see [enum InSim.Penalty])
var num_stops := 0  ## Number of pit stops
var sp3 := 0  ## Spare

var tyres: Array[InSim.Tyre] = []  ## Tyres changed

var work := 0  ## Pit work (see [enum InSim.PitWork])
var spare := 0  ## Spare


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	plid = read_byte()
	laps_done = read_word()
	flags = read_word()
	fuel_add = read_byte()
	penalty = read_byte() as InSim.Penalty
	num_stops = read_byte()
	sp3 = read_byte()
	tyres.clear()
	for i in _MAX_TYRES:
		tyres.append(read_byte())
	work = read_unsigned()
	spare = read_unsigned()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
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


func _get_pretty_text() -> String:
	var pitwork: Array[String] = []
	if (work >> InSim.PitWork.PSE_NOTHING) & 1:
		pitwork.append("nothing")
	if (
		(work >> InSim.PitWork.PSE_FR_DAM) & 1
		or (work >> InSim.PitWork.PSE_LE_FR_DAM) & 1
		or (work >> InSim.PitWork.PSE_RI_FR_DAM) & 1
		or (work >> InSim.PitWork.PSE_RE_DAM) & 1
		or (work >> InSim.PitWork.PSE_LE_RE_DAM) & 1
		or (work >> InSim.PitWork.PSE_RI_RE_DAM) & 1
		or (work >> InSim.PitWork.PSE_BODY_MINOR) & 1
		or (work >> InSim.PitWork.PSE_BODY_MAJOR) & 1
	):
		pitwork.append("damage")
	if (
		(work >> InSim.PitWork.PSE_FR_WHL) & 1
		or (work >> InSim.PitWork.PSE_LE_FR_WHL) & 1
		or (work >> InSim.PitWork.PSE_RI_FR_WHL) & 1
		or (work >> InSim.PitWork.PSE_RE_WHL) & 1
		or (work >> InSim.PitWork.PSE_LE_RE_WHL) & 1
		or (work >> InSim.PitWork.PSE_RI_RE_WHL) & 1
	):
		pitwork.append("tyres")
	if (work >> InSim.PitWork.PSE_SETUP) & 1:
		pitwork.append("setup")
	if (work >> InSim.PitWork.PSE_REFUEL) & 1:
		pitwork.append("refuel")
	return "PLID %d made a pit stop (pitwork: %s)" % [plid, ", ".join(pitwork)]
