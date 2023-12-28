class_name InSimPacket
extends RefCounted


const HEADER_SIZE := 4

var buffer := PackedByteArray()
var size := 4
var type := InSim.PacketIdentifier.ISP_NONE
var req_i := 0
var data_offset := 0


func _init() -> void:
	resize_buffer(size)
	@warning_ignore("integer_division")
	add_byte(size / 4)
	add_byte(type)
	add_byte(req_i)
	add_byte(0)
	data_offset = HEADER_SIZE


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
