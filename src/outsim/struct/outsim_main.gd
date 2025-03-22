class_name OutSimMain
extends RefCounted


const STRUCT_SIZE := 60
const POSITION_MULTIPLIER := 65536.0

var ang_vel := Vector3.ZERO
var heading := 0.0
var pitch := 0.0
var roll := 0.0
var accel := Vector3.ZERO
var vel := Vector3.ZERO
var pos := Vector3i.ZERO

var gis_position := Vector3.ZERO


func _to_string() -> String:
	return "AngVel:%v, Heading:%f, Pitch:%f, Roll:%f, Accel:%v, Vel:%v, Pos:%v" % \
			[ang_vel, heading, pitch, roll, accel, vel, pos]


func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_float(0, ang_vel.x)
	buffer.encode_float(4, ang_vel.y)
	buffer.encode_float(8, ang_vel.z)
	buffer.encode_float(12, heading)
	buffer.encode_float(16, pitch)
	buffer.encode_float(20, roll)
	buffer.encode_float(24, accel.x)
	buffer.encode_float(28, accel.y)
	buffer.encode_float(32, accel.z)
	buffer.encode_float(36, vel.x)
	buffer.encode_float(40, vel.y)
	buffer.encode_float(44, vel.z)
	buffer.encode_u32(48, pos.x)
	buffer.encode_u32(52, pos.y)
	buffer.encode_u32(56, pos.z)
	return buffer


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
	gis_position = pos / POSITION_MULTIPLIER
