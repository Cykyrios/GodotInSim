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


## Override to define behavior for new packets
func _decode_packet(packet_buffer: PackedByteArray) -> void:
	buffer = packet_buffer


## Override to define behavior for new packets
func _fill_buffer() -> void:
	pass


func _get_dictionary() -> Dictionary:
	return {}


## Override to define "pretty" text for this packet.
func _get_pretty_text() -> String:
	return str(get_dictionary())


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


func decode_packet(packet_buffer: PackedByteArray) -> void:
	_decode_packet(packet_buffer)
	_update_gis_values()


## Returns the raw byte data for this packet. If [param use_gis_values] is [code]true[/code],
## all [code]gis_*[/code] variables are used instead of their LFS-style couterparts.
func fill_buffer(use_gis_values := false) -> void:
	if use_gis_values:
		_set_values_from_gis()
	_fill_buffer()


func get_dictionary() -> Dictionary:
	return _get_dictionary().duplicate()


func get_pretty_text() -> String:
	return _get_pretty_text()


#region buffer I/O
func add_buffer(data: PackedByteArray) -> void:
	if data.is_empty():
		push_error("Cannot add data, buffer is empty")
		return
	var available_space := buffer.size() - data_offset
	if data.size() > available_space:
		push_error("Not enough space to add buffer (size %d, available %d)" % [data.size(),
				available_space])
		return
	for byte in data:
		add_byte(byte)


func add_byte(data: int) -> void:
	if data > 0xFF:
		push_error("Data too large for unsigned byte, max 255, got %d." % [data])
		return
	if data < 0:
		push_error("Data cannot be negative, got %d." % [data])
		return
	buffer.encode_u8(data_offset, data)
	data_offset += 1


func add_char(data: String) -> void:
	var _buffer := add_string(1, data)


func add_float(data: float) -> void:
	buffer.encode_float(data_offset, data)
	data_offset += 4


func add_int(data: int) -> void:
	var min_value := -0x8000_0000
	var max_value := 0x7FFF_FFFF
	if data > max_value:
		push_error("Data too large for signed integer, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data too small for signed integer, min %d, got %d." % [min_value, data])
		return
	buffer.encode_s32(data_offset, data)
	data_offset += 4


func add_short(data: int) -> void:
	var min_value := -0x8000
	var max_value := 0x7FFF
	if data > max_value:
		push_error("Data too large for short integer, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data too small for short integer, min %d, got %d." % [min_value, data])
		return
	buffer.encode_s16(data_offset, data)
	data_offset += 2


func add_string(length: int, data: String, zero_terminated := true) -> PackedByteArray:
	var temp_buffer := LFSText.unicode_to_lfs_bytes(data)
	var _discard := temp_buffer.resize(length)
	for i in length:
		buffer.encode_u8(data_offset, temp_buffer[i])
		data_offset += 1
	if zero_terminated:
		temp_buffer[-1] = 0
	return temp_buffer


func add_string_as_utf8(length: int, data: String) -> PackedByteArray:
	var temp_buffer := data.to_utf8_buffer()
	var _discard := temp_buffer.resize(length)
	for i in length:
		buffer.encode_u8(data_offset, temp_buffer[i])
		data_offset += 1
	return temp_buffer


func add_string_variable_length(data: String, max_length: int, length_step: int) -> PackedByteArray:
	var temp_buffer := LFSText.unicode_to_lfs_bytes(data)
	var length := temp_buffer.size()
	var remainder := length % length_step
	length += length_step - remainder
	if length > max_length:
		length = max_length
	var _discard := temp_buffer.resize(length)
	var encode_start := data_offset
	for i in length:
		buffer.encode_u8(data_offset, temp_buffer[i])
		data_offset += 1
	buffer.encode_u8(data_offset - 1, 0)
	return buffer.slice(encode_start, data_offset)


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


func read_buffer(bytes: int) -> PackedByteArray:
	var result := buffer.slice(data_offset, data_offset + bytes)
	data_offset += bytes
	return result


func read_byte() -> int:
	var result := buffer.decode_u8(data_offset)
	data_offset += 1
	return result


func read_car_name() -> String:
	const CAR_NAME_LENGTH := 4
	var car_name_buffer := buffer.slice(data_offset, data_offset + CAR_NAME_LENGTH)
	data_offset += CAR_NAME_LENGTH
	return LFSText.car_name_from_lfs_bytes(car_name_buffer)


func read_char() -> String:
	return read_string(1, false)


func read_float() -> float:
	var result := buffer.decode_float(data_offset)
	data_offset += 4
	return result


func read_int() -> int:
	var result := buffer.decode_s32(data_offset)
	data_offset += 4
	return result


func read_short() -> int:
	var result := buffer.decode_s16(data_offset)
	data_offset += 2
	return result


func read_string(length: int, zero_terminated := true) -> String:
	var temp_buffer := buffer.slice(data_offset, data_offset + length)
	var result := LFSText.lfs_bytes_to_unicode(temp_buffer, zero_terminated)
	data_offset += length
	return result


func read_string_as_utf8(length: int) -> String:
	var temp_buffer := buffer.slice(data_offset, data_offset + length)
	var result := temp_buffer.get_string_from_utf8()
	data_offset += length
	return result


func read_unsigned() -> int:
	var result := buffer.decode_u32(data_offset)
	data_offset += 4
	return result


func read_word() -> int:
	var result := buffer.decode_u16(data_offset)
	data_offset += 2
	return result
#endregion


func resize_buffer(new_size: int) -> void:
	size = new_size
	var _discard := buffer.resize(size)
