class_name InSimCONPacket
extends InSimPacket


const PACKET_SIZE := 40
const PACKET_TYPE := InSim.Packet.ISP_CON
var zero := 0

var sp_close := 0
var time := 0

var car_a := CarContact.new()
var car_b := CarContact.new()


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
	sp_close = read_word(packet)
	time = read_word(packet)
	var struct_size := CarContact.STRUCT_SIZE
	car_a.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size
	car_b.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"SpClose": sp_close,
		"Time": time,
		"A": car_a,
		"B": car_b,
	}
