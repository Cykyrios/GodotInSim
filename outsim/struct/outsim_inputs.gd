class_name OutSimInputs
extends RefCounted


const STRUCT_SIZE := 20

var throttle := 0.0
var brake := 0.0
var input_steer := 0.0
var clutch := 0.0
var handbrake := 0.0


func _to_string() -> String:
	return "Throttle:%f, Brake:%f, InputSteer:%f, Clutch:%f, HandBrake:%f" % \
			[throttle, brake, input_steer, clutch, handbrake]


func set_from_buffer(buffer: PackedByteArray) -> void:
	var buffer_size := buffer.size()
	if buffer_size != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer_size])
		return
	throttle = buffer.decode_float(0)
	brake = buffer.decode_float(4)
	input_steer = buffer.decode_float(8)
	clutch = buffer.decode_float(12)
	handbrake = buffer.decode_float(16)
