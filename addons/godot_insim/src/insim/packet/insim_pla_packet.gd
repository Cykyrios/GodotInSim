class_name InSimPLAPacket
extends InSimPacket

## Pit LAne packet

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_PLA
var plid := 0  ## player's unique id

var fact := InSim.PitLane.PITLANE_EXIT  ## pit lane fact (see [enum InSim.PitLane])
var sp1 := 0
var sp2 := 0
var sp3 := 0


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
		"Sp1": sp1,
		"Sp2": sp2,
		"Sp3": sp3,
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
