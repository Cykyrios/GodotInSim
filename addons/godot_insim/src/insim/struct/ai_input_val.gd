class_name AIInputVal
extends InSimStruct

## InSim struct for AI control input

const TIME_MULTIPLIER := 100.0

const STRUCT_SIZE := 4

## Select input value to set
## Inputs marked 'hold' must be set back to zero after some time.
## This can be done either by use of the [param time] field or by sending a
## later packet with [param value] = 0.
## E.g. Set time to 10 when issuing a CS_CHUP - hold shift up lever for 0.1 sec.
## E.g. Set time to 50 when issuing a CS_HORN - sound horn for 0.5 sec.
## Inputs marked 'toggle' accept the following values:
## 1 - toggle
## 2 - switch off
## 3 - switch on
var input := InSim.AIControl.CS_MSX
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
	input = buffer.decode_u8(0) as InSim.AIControl
	time = buffer.decode_u8(1)
	value = buffer.decode_u16(2)
	update_gis_values()


func _set_values_from_gis() -> void:
	time = int(gis_time * TIME_MULTIPLIER)


func _update_gis_values() -> void:
	gis_time = time / TIME_MULTIPLIER


static func create(aic_input: InSim.AIControl, aic_time: int, aic_value: int) -> AIInputVal:
	var ai_input_val := AIInputVal.new()
	ai_input_val.input = aic_input
	ai_input_val.time = aic_time
	ai_input_val.value = aic_value
	ai_input_val.update_gis_values()
	return ai_input_val


static func create_from_gis_values(
	aic_input: InSim.AIControl, aic_time: float, aic_value: int
) -> AIInputVal:
	var ai_input_val := AIInputVal.new()
	ai_input_val.input = aic_input
	ai_input_val.gis_time = aic_time
	ai_input_val.value = aic_value
	ai_input_val.set_values_from_gis()
	return ai_input_val
