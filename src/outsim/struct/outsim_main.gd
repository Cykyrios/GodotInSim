class_name OutSimMain
extends RefCounted


const STRUCT_SIZE := 60

var ang_vel := Vector3.ZERO
var heading := 0.0
var pitch := 0.0
var roll := 0.0
var accel := Vector3.ZERO
var vel := Vector3.ZERO
var pos := Vector3i.ZERO


func _to_string() -> String:
	return "AngVel:%v, Heading:%f, Pitch:%f, Roll:%f, Accel:%v, Vel:%v, Pos:%v" % \
			[ang_vel, heading, pitch, roll, accel, vel, pos]


func set_from_buffer(buffer: PackedByteArray) -> void:
	var buffer_size := buffer.size()
	if buffer_size != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer_size])
		return
	ang_vel = Vector3(buffer.decode_float(0), buffer.decode_float(4), buffer.decode_float(8))
	heading = buffer.decode_float(12)
	pitch = buffer.decode_float(16)
	roll = buffer.decode_float(20)
	accel = Vector3(buffer.decode_float(24), buffer.decode_float(28), buffer.decode_float(32))
	vel = Vector3(buffer.decode_float(36), buffer.decode_float(40), buffer.decode_float(44))
	pos = Vector3i(buffer.decode_u32(48), buffer.decode_u32(52), buffer.decode_u32(56))
