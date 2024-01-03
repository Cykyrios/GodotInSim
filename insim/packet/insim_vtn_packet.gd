class_name InSimVTNPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_VTN
var zero := 0

var ucid := 0
var action := 0
var spare2 := 0
var spare3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	zero = read_byte(packet)
	ucid = read_byte(packet)
	action = read_byte(packet)
	spare2 = read_byte(packet)
	spare3 = read_byte(packet)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"UCID": ucid,
		"Action": action,
		"Spare2": spare2,
		"Spare3": spare3,
	}
