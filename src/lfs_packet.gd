class_name LFSPacket
extends RefCounted

## Base packet for communication with LFS
##
## All packets inherit from this base class, which includes common parameters and methods to
## facilitate reading and writing data.[br]
## This class is generally not intended to be used directly, instead prefer using [InSimPacket],
## [OutSimPacket] or [OutGaugePacket] as needed for your application.

var buffer := PackedByteArray()
var size := 0
var data_offset := 0


func _init() -> void:
	pass


func _to_string() -> String:
	return "%s" % [buffer]


func _get_dictionary() -> Dictionary:
	return {}


func get_dictionary() -> Dictionary:
	return _get_dictionary()


## Override to update values with non-standard units from gis (GodotInSim) prefixed values, e.g.[br]
## [code]position = gis_position * 65536[/code].
func _set_values_from_gis() -> void:
	pass


## Override to update gis (GodotInSim) variables from variables with non-standard units, e.g.[br]
## [code]gis_position = position / 65536.0[/code].
func _update_gis_values() -> void:
	pass


static func create_packet_from_buffer(packet_buffer: PackedByteArray) -> LFSPacket:
	var packet := LFSPacket.new()
	packet.buffer = packet_buffer
	packet.decode_packet(packet_buffer)
	return packet


func add_char(data: String) -> void:
	add_string(1, data)


func add_string(length: int, data: String) -> void:
	var temp_buffer := data.to_utf8_buffer()
	var _discard := temp_buffer.resize(length)
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
	buffer.encode_s16(data_offset, data)
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
	buffer.encode_u32(data_offset, data)
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
	buffer.encode_s32(data_offset, data)
	data_offset += 4


func add_float(data: float) -> void:
	buffer.encode_float(data_offset, data)
	data_offset += 4


func read_car_name() -> String:
	var is_alphanumeric := func is_alphanumeric(character: int) -> bool:
		var string := String.chr(character)
		if (
			string >= "0" and string <= "9"
			or string >= "A" and string <= "Z"
			or string >= "a" and string <= "z"
		):
			return true
		return false

	const CAR_NAME_LENGTH := 4
	var car_name_buffer := buffer.slice(data_offset, data_offset + CAR_NAME_LENGTH)
	data_offset += CAR_NAME_LENGTH
	var car_name := ""
	if (
		car_name_buffer[-1] == 0
		and is_alphanumeric.call(car_name_buffer[0])
		and is_alphanumeric.call(car_name_buffer[1])
		and is_alphanumeric.call(car_name_buffer[2])
	):
		car_name = car_name_buffer.get_string_from_utf8()
	else:
		var _discard := car_name_buffer.resize(3)
		car_name_buffer.reverse()
		car_name = car_name_buffer.hex_encode().to_upper()
	return car_name


func read_char() -> String:
	return read_string(1)


func read_string(length: int) -> String:
	var temp_buffer := buffer.slice(data_offset, data_offset + length)
	var result := temp_buffer.get_string_from_utf8()
	data_offset += length
	return result


func read_byte() -> int:
	var result := buffer.decode_u8(data_offset)
	data_offset += 1
	return result


func read_word() -> int:
	var result := buffer.decode_u16(data_offset)
	data_offset += 2
	return result


func read_short() -> int:
	var result := buffer.decode_s16(data_offset)
	data_offset += 2
	return result


func read_unsigned() -> int:
	var result := buffer.decode_u32(data_offset)
	data_offset += 4
	return result


func read_int() -> int:
	var result := buffer.decode_s32(data_offset)
	data_offset += 4
	return result


func read_float() -> float:
	var result := buffer.decode_float(data_offset)
	data_offset += 4
	return result


func resize_buffer(new_size: int) -> void:
	size = new_size
	var _discard := buffer.resize(size)


func fill_buffer() -> void:
	_set_values_from_gis()
	_fill_buffer()


func _fill_buffer() -> void:
	pass


func decode_packet(packet_buffer: PackedByteArray) -> void:
	_decode_packet(packet_buffer)
	_update_gis_values()


func _decode_packet(packet_buffer: PackedByteArray) -> void:
	buffer = packet_buffer
