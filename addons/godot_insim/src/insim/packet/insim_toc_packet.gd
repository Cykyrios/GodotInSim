class_name InSimTOCPacket
extends InSimPacket
## Take Over Car packet
##
## This packet is received when a new [Connection] takes over a car.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_TOC  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## Player's unique id

var old_ucid := 0  ## Old connection's unique id
var new_ucid := 0  ## New connection's unique id
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
	old_ucid = read_byte()
	new_ucid = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"OldUCID": old_ucid,
		"NewUCID": new_ucid,
		"Sp2": sp2,
		"Sp3": sp3,
	}


func _get_pretty_text() -> String:
	return "UCID %d took over from UCID %d" % [new_ucid, old_ucid]
