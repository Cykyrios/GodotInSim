class_name InSimSmallPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_SMALL
var sub_type := InSim.Small.SMALL_NONE
var value := 0


func _init(req := 0, subt := InSim.Small.SMALL_NONE) -> void:
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
	sub_type = read_byte(packet) as InSim.Small
	value = read_unsigned(packet)


func _fill_buffer() -> void:
	super()
	update_req_i()
	add_byte(sub_type)
	add_unsigned(value)


func _get_data_dictionary() -> Dictionary:
	var dict := {
		"SubT": sub_type,
		"UVal": value,
	}
	return dict
