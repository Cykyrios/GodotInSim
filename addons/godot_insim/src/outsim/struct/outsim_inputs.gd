class_name OutSimInputs
extends RefCounted
## OutSim inputs data
##
## This class contains data related to the player input.

const STRUCT_SIZE := 20  ## Size of this data struct

var throttle := 0.0  ## Throttle input from 0 to 1
var brake := 0.0  ## Brake input from 0 to 1
## Steering input in radians - this is the steering angle at the wheels, not at the steering wheel.
var input_steer := 0.0
var clutch := 0.0  ## Clutch input from 0 to 1
var handbrake := 0.0  ## Handbrake input from 0 to 1


func _to_string() -> String:
	return "Throttle:%f, Brake:%f, InputSteer:%f, Clutch:%f, HandBrake:%f" % [
		throttle, brake, input_steer, clutch, handbrake
	]


## Sets the properties from the given [param buffer].
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
