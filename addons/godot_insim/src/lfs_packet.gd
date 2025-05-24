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


## Override this to define packet behavior.
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


## Creates a packet from the provided [param packet_buffer].
static func create_packet_from_buffer(packet_buffer: PackedByteArray) -> LFSPacket:
	var packet := LFSPacket.new()
	packet.buffer = packet_buffer
	packet.decode_packet(packet_buffer)
	return packet


## Decodes the provided [param packet_buffer]. Define behavior by overriding
## [method _decode_packet].
func decode_packet(packet_buffer: PackedByteArray) -> void:
	_decode_packet(packet_buffer)
	update_gis_values()


## Returns the raw byte data for this packet. If [param use_gis_values] is [code]true[/code],
## all [code]gis_*[/code] variables are used instead of their LFS-style couterparts.
func fill_buffer(use_gis_values := false) -> void:
	if use_gis_values:
		_set_values_from_gis()
	_fill_buffer()


## Returns the packet's contents as a dictionary. Define behavior by overriding
## [method _get_dictionary].
func get_dictionary() -> Dictionary:
	return _get_dictionary().duplicate()


## Returns a text representation of the packet formatted for readability. Define behavior
## by overriding [method _get_pretty_text].
func get_pretty_text() -> String:
	return _get_pretty_text()


#region buffer I/O
## Adds the contents of [param data] to the packet's [member buffer] at the current
## [member data_offset]. If [param at_position] is different from [code]-1[/code],
## [member data_offset] is set to that value.
func add_buffer(data: PackedByteArray, at_position := -1) -> void:
	if data.is_empty():
		push_error("Cannot add data, buffer is empty")
		return
	if at_position != -1:
		data_offset = at_position
	var available_space := buffer.size() - data_offset
	if data.size() > available_space:
		push_error("Not enough space to add buffer (size %d, available %d)" % [data.size(),
				available_space])
		return
	for byte in data:
		add_byte(byte)


## Adds a byte (uint8) to the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func add_byte(data: int, at_position := -1) -> void:
	if data > 0xFF:
		push_error("Data too large for unsigned byte, max 255, got %d." % [data])
		return
	if data < 0:
		push_error("Data cannot be negative, got %d." % [data])
		return
	if at_position != -1:
		data_offset = at_position
	buffer.encode_u8(data_offset, data)
	data_offset += 1


## Adds a single character to the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func add_char(data: String, at_position := -1) -> void:
	var _buffer := add_string(1, data, false, at_position)


## Adds a 32-bit float to the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func add_float(data: float, at_position := -1) -> void:
	if at_position != -1:
		data_offset = at_position
	buffer.encode_float(data_offset, data)
	data_offset += 4


## Adds an int (int32) to the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func add_int(data: int, at_position := -1) -> void:
	var min_value := -0x8000_0000
	var max_value := 0x7FFF_FFFF
	if data > max_value:
		push_error("Data too large for signed integer, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data too small for signed integer, min %d, got %d." % [min_value, data])
		return
	if at_position != -1:
		data_offset = at_position
	buffer.encode_s32(data_offset, data)
	data_offset += 4


## Adds a short (int16) to the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func add_short(data: int, at_position := -1) -> void:
	var min_value := -0x8000
	var max_value := 0x7FFF
	if data > max_value:
		push_error("Data too large for short integer, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data too small for short integer, min %d, got %d." % [min_value, data])
		return
	if at_position != -1:
		data_offset = at_position
	buffer.encode_s16(data_offset, data)
	data_offset += 2


## Adds a string to the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
## The string is converted from UTF8 to LFS bytes and trimmed to [param length] bytes, including the
## last zero if [param zero_terminated] is true.
func add_string(
	length: int, data: String, zero_terminated := true, at_position := -1
) -> PackedByteArray:
	if length <= 0:
		push_warning("Cannot add a zero-length string")
		return []
	var temp_buffer := LFSText.unicode_to_lfs_bytes(data)
	var _discard := temp_buffer.resize(length)
	if zero_terminated:
		temp_buffer[-1] = 0
	if at_position != -1:
		data_offset = at_position
	for i in length:
		buffer.encode_u8(data_offset, temp_buffer[i])
		data_offset += 1
	return temp_buffer


## Adds a UTF8 string to the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func add_string_as_utf8(length: int, data: String, at_position := -1) -> PackedByteArray:
	var temp_buffer := data.to_utf8_buffer()
	var _discard := temp_buffer.resize(length)
	if at_position != -1:
		data_offset = at_position
	for i in length:
		buffer.encode_u8(data_offset, temp_buffer[i])
		data_offset += 1
	return temp_buffer


## Adds a string to the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
## The string is converted from UTF8 to LFS bytes and is kept at the smallest possible length with
## steps of [param length_step] and a maximum of [param max_length].
func add_string_variable_length(
	data: String, max_length: int, length_step: int, at_position := -1
) -> PackedByteArray:
	var temp_buffer := LFSText.unicode_to_lfs_bytes(data)
	var length := temp_buffer.size()
	var remainder := length % length_step
	length += length_step - remainder
	if length > max_length:
		length = max_length
	var _discard := temp_buffer.resize(length)
	if at_position != -1:
		data_offset = at_position
	var encode_start := data_offset
	for i in length:
		buffer.encode_u8(data_offset, temp_buffer[i])
		data_offset += 1
	buffer.encode_u8(data_offset - 1, 0)
	return buffer.slice(encode_start, data_offset)


## Adds an unsigned (uint32) to the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func add_unsigned(data: int, at_position := -1) -> void:
	var min_value := 0
	var max_value := 0xFFFF_FFFF
	if data > max_value:
		push_error("Data too large for unsigned integer, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data cannot be negative, got %d." % [data])
		return
	if at_position != -1:
		data_offset = at_position
	buffer.encode_u32(data_offset, data)
	data_offset += 4


## Adds a word (uint16) to the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func add_word(data: int, at_position := -1) -> void:
	var min_value := 0
	var max_value := 0xFFFF
	if data > max_value:
		push_error("Data too large for unsigned word, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data cannot be negative, got %d." % [data])
		return
	if at_position != -1:
		data_offset = at_position
	buffer.encode_u16(data_offset, data)
	data_offset += 2


## Reads [param bytes] bytes from the packet's [member buffer] at the current [member data_offset].
## If [param at_position] is different from [code]-1[/code], [member data_offset] is set to that
## value.
func read_buffer(bytes: int, at_position := -1) -> PackedByteArray:
	if at_position != -1:
		data_offset = at_position
	var result := buffer.slice(data_offset, data_offset + bytes)
	data_offset += bytes
	return result


## Reads a byte (uint8) from the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func read_byte(at_position := -1) -> int:
	if at_position != -1:
		data_offset = at_position
	var result := buffer.decode_u8(data_offset)
	data_offset += 1
	return result


## Reads a car name (see [method LFSText.car_name_from_lfs_bytes] from the packet's [member buffer]
## at the current [member data_offset]. If [param at_position] is different from [code]-1[/code],
## [member data_offset] is set to that value.
func read_car_name(at_position := -1) -> String:
	const CAR_NAME_LENGTH := 4
	if at_position != -1:
		data_offset = at_position
	var car_name_buffer := buffer.slice(data_offset, data_offset + CAR_NAME_LENGTH)
	data_offset += CAR_NAME_LENGTH
	return LFSText.car_name_from_lfs_bytes(car_name_buffer)


## Reads a single character from the packet's [member buffer] at the current [member data_offset].
## If [param at_position] is different from [code]-1[/code], [member data_offset] is set to that
## value.
func read_char(at_position := -1) -> String:
	if at_position != -1:
		data_offset = at_position
	return read_string(1, false)


## Reads a 32-bit float from the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func read_float(at_position := -1) -> float:
	if at_position != -1:
		data_offset = at_position
	var result := buffer.decode_float(data_offset)
	data_offset += 4
	return result


## Reads an int (int32) from the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func read_int(at_position := -1) -> int:
	if at_position != -1:
		data_offset = at_position
	var result := buffer.decode_s32(data_offset)
	data_offset += 4
	return result


## Reads a short (int16) from the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func read_short(at_position := -1) -> int:
	if at_position != -1:
		data_offset = at_position
	var result := buffer.decode_s16(data_offset)
	data_offset += 2
	return result


## Reads [param length] bytes forming an LFS string from the packet's [member buffer],
## and converts it to UTF8. See [method LFSText.lfs_bytes_to_unicode] for details. Reading occurs
## at the current [member data_offset]. If [param at_position] is different from [code]-1[/code],
## [member data_offset] is set to that value.
func read_string(length: int, zero_terminated := true, at_position := -1) -> String:
	if at_position != -1:
		data_offset = at_position
	var temp_buffer := buffer.slice(data_offset, data_offset + length)
	var result := LFSText.lfs_bytes_to_unicode(temp_buffer, zero_terminated)
	data_offset += length
	return result


## Reads a UTF8 string of [param length] characters from the packet's [member buffer] at the current
## [member data_offset]. If [param at_position] is different from [code]-1[/code],
## [member data_offset] is set to that value.
func read_string_as_utf8(length: int, at_position := -1) -> String:
	if at_position != -1:
		data_offset = at_position
	var temp_buffer := buffer.slice(data_offset, data_offset + length)
	var result := temp_buffer.get_string_from_utf8()
	data_offset += length
	return result


## Reads an unsigned (uint32) from the packet's [member buffer] at the current [member data_offset].
## If [param at_position] is different from [code]-1[/code], [member data_offset] is set to that
## value.
func read_unsigned(at_position := -1) -> int:
	if at_position != -1:
		data_offset = at_position
	var result := buffer.decode_u32(data_offset)
	data_offset += 4
	return result


## Reads a word (uint16) from the packet's [member buffer] at the current [member data_offset]. If
## [param at_position] is different from [code]-1[/code], [member data_offset] is set to that value.
func read_word(at_position := -1) -> int:
	if at_position != -1:
		data_offset = at_position
	var result := buffer.decode_u16(data_offset)
	data_offset += 2
	return result
#endregion


## Updates the packet's [member buffer] size to [param new_size].
func resize_buffer(new_size: int) -> void:
	size = new_size
	var _discard := buffer.resize(size)


## Updates LFS-style variables from [code]gis_*[/code] variables. This behavior is defined in
## [method _set_values_from_gis].
func set_values_from_gis() -> void:
	_set_values_from_gis()


## Updates [code]gis_*[/code] variables from LFS-style variables. This behavior is defined in
## [method _update_gis_values].
func update_gis_values() -> void:
	_update_gis_values()
