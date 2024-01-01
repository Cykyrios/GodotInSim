class_name InSimTinyPacket
extends InSimPacket


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
	sub_type = read_byte(packet) as InSim.Tiny


func _fill_buffer() -> void:
	super()
	update_req_i()
	add_byte(sub_type)


func _get_data_dictionary() -> Dictionary:
	var dict := {
		"SubT": sub_type,
	}
	return dict
