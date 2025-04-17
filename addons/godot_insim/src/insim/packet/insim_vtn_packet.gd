class_name InSimVTNPacket
extends InSimPacket

## VoTe Notify packet

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_VTN
var zero := 0

var ucid := 0  ## connection's unique id
var action := 0  ## see [enum InSim.Vote]
var spare2 := 0
var spare3 := 0


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
	zero = read_byte()
	ucid = read_byte()
	action = read_byte()
	spare2 = read_byte()
	spare3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"UCID": ucid,
		"Action": action,
		"Spare2": spare2,
		"Spare3": spare3,
	}


func _get_pretty_text() -> String:
	return "UCID %d voted %s" % [ucid, InSim.Vote.keys()[action]]
