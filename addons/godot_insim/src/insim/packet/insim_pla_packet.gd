class_name InSimPLAPacket
extends InSimPacket
## Pit LAne packet
##
## This packet is received when a player enters or leaves the pitlane.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_PLA  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## Player's unique id

var fact := InSim.PitLane.PITLANE_EXIT  ## Pitlane fact (see [enum InSim.PitLane])
var sp1 := 0  ## Spare
var sp2 := 0  ## Spare
var sp3 := 0  ## Spare


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
	fact = read_byte() as InSim.PitLane
	sp1 = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"Fact": fact,
	}


func _get_pretty_text() -> String:
	var fact_string := "%s the pit lane" % ["exited" if fact == InSim.PitLane.PITLANE_EXIT \
			else "entered"]
	match fact:
		InSim.PitLane.PITLANE_NO_PURPOSE:
			fact_string += " for no purpose"
		InSim.PitLane.PITLANE_DT:
			fact_string += " for drive-through penalty"
		InSim.PitLane.PITLANE_SG:
			fact_string += " for stop-go penalty"
	return "PLID %d %s" % [plid, fact_string]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "Fact"]):
		return
	plid = dict["PLID"]
	fact = dict["Fact"]
