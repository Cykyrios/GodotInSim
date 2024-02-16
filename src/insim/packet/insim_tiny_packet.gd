class_name InSimTinyPacket
extends InSimPacket

## General purpose packet - IS_TINY
##
## To avoid defining several packet structures that are exactly the same, and to avoid
## wasting the ISP_ enumeration, IS_TINY is used at various times when no additional data
## other than SubT is required.[br]
## [br]
## See [enum InSim.Tiny] for the list of TINY_ packets.

const PACKET_SIZE := 4
const PACKET_TYPE := InSim.Packet.ISP_TINY
var sub_type := InSim.Tiny.TINY_NONE


func _init(req := 0, subt := InSim.Tiny.TINY_NONE) -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	req_i = req
	sub_type = subt


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	sub_type = read_byte() as InSim.Tiny


func _fill_buffer() -> void:
	super()
	update_req_i()
	add_byte(sub_type)


func _get_data_dictionary() -> Dictionary:
	return {
		"SubT": sub_type,
	}
