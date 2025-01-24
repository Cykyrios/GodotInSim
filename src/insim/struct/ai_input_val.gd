class_name AIInputVal
extends InSimStruct


const TIME_MULTIPLIER := 100.0

const STRUCT_SIZE := 4

## Select input value to set
## Special values for Input:
## 254 - reset all
## 255 - stop control
var input := 0
var time := 0  ## Time to hold (optional, hundredths of a second)
var value := 0  ## Value to set

var gis_time := 0.0  ## Time to hold in seconds


func _to_string() -> String:
	return "Input:%d, Time:%d, Value:%d" % [input, time, value]


func _get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u8(0, input)
	buffer.encode_u8(1, time)
	buffer.encode_u16(2, value)
	return buffer


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	input = buffer.decode_u8(0)
	time = buffer.decode_u8(1)
	value = buffer.decode_u16(2)


func _set_values_from_gis() -> void:
	time = int(gis_time * TIME_MULTIPLIER)


func _update_gis_values() -> void:
	gis_time = time / TIME_MULTIPLIER
