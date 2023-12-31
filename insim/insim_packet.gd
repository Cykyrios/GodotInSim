class_name InSimPacket
extends RefCounted


const HEADER_SIZE := 4

var buffer := PackedByteArray()
var size := 4
var type := InSim.Packet.ISP_NONE
var req_i := 0
var zero := 0
var data_offset := 0


func _init() -> void:
	resize_buffer(size)
	@warning_ignore("integer_division")
	add_byte(size / 4)
	add_byte(type)
	add_byte(req_i)
	add_byte(0)
	data_offset = HEADER_SIZE


func _to_string() -> String:
	return "%s: %s" % [InSim.Packet.keys()[type], buffer]


func _get_data_dictionary() -> Dictionary:
	return {}


func get_dictionary() -> Dictionary:
	var data := _get_data_dictionary()
	var dict := {
		"Size": size,
		"Type": type,
		"ReqI": req_i,
		"Zero": zero,
	}
	dict.merge(data)
	return dict


func add_char(data: String) -> void:
	add_string(1, data)


func add_string(length: int, data: String) -> void:
	var temp_buffer := data.to_utf8_buffer()
	temp_buffer.resize(length)
	for i in length:
		buffer.encode_u8(data_offset, temp_buffer[i])
		data_offset += 1


func add_byte(data: int) -> void:
	if data > 0xFF:
		push_error("Data too large for unsigned byte, max 255, got %d." % [data])
		return
	if data < 0:
		push_error("Data cannot be negative, got %d." % [data])
		return
	buffer.encode_u8(data_offset, data)
	data_offset += 1


func add_word(data: int) -> void:
	var min_value := 0
	var max_value := 0xFFFF
	if data > max_value:
		push_error("Data too large for unsigned word, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data cannot be negative, got %d." % [data])
		return
	buffer.encode_u16(data_offset, data)
	data_offset += 2


func add_short(data: int) -> void:
	var min_value := -0x1000
	var max_value := 0xFFF
	if data > max_value:
		push_error("Data too large for short integer, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data too small for short integer, min %d, got %d." % [min_value, data])
		return
	buffer.encode_u16(data_offset, data)
	data_offset += 2


func add_unsigned(data: int) -> void:
	var min_value := 0
	var max_value := 0xFFFF_FFFF
	if data > max_value:
		push_error("Data too large for unsigned integer, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data cannot be negative, got %d." % [data])
		return
	buffer.encode_u16(data_offset, data)
	data_offset += 4


func add_int(data: int) -> void:
	var min_value := -0x1000_0000
	var max_value := 0xFFF_FFFF
	if data > max_value:
		push_error("Data too large for signed integer, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data too small for signed integer, min %d, got %d." % [min_value, data])
		return
	buffer.encode_u16(data_offset, data)
	data_offset += 4


func add_float(data: float) -> void:
	buffer.encode_float(data_offset, data)
	data_offset += 4


func update_req_i() -> void:
	buffer.encode_u8(2, req_i)


func read_char(packet: PackedByteArray) -> String:
	return read_string(packet, 1)


func read_string(packet: PackedByteArray, length: int) -> String:
	var temp_buffer := packet.slice(data_offset, data_offset + length)
	var result := temp_buffer.get_string_from_utf8()
	data_offset += length
	return result


func read_byte(packet: PackedByteArray) -> int:
	var result := packet.decode_u8(data_offset)
	data_offset += 1
	return result


func read_word(packet: PackedByteArray) -> int:
	var result := packet.decode_u16(data_offset)
	data_offset += 2
	return result


func read_short(packet: PackedByteArray) -> int:
	var result := packet.decode_u16(data_offset)
	data_offset += 2
	return result


func read_unsigned(packet: PackedByteArray) -> int:
	var result := packet.decode_u32(data_offset)
	data_offset += 4
	return result


func read_int(packet: PackedByteArray) -> int:
	var result := packet.decode_u32(data_offset)
	data_offset += 4
	return result


func read_float(packet: PackedByteArray) -> float:
	var result := packet.decode_float(data_offset)
	data_offset += 4
	return result


func resize_buffer(new_size: int) -> void:
	size = new_size
	_adjust_packet_size()
	buffer.resize(size)
	@warning_ignore("integer_division")
	buffer.encode_u8(0, size / 4)


# All packets have a size equal to a multiple of 4
func _adjust_packet_size() -> void:
	var remainder := size % 4
	size += remainder


func fill_buffer() -> void:
	_fill_buffer()


func _fill_buffer() -> void:
	pass


func decode_packet(packet_buffer: PackedByteArray) -> void:
	_decode_packet(packet_buffer)


@warning_ignore("unused_parameter")
func _decode_packet(packet_buffer: PackedByteArray) -> void:
	pass
