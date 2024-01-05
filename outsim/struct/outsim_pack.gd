class_name OutSimPack
extends RefCounted


const STRUCT_SIZE_WITHOUT_ID := 64
const STRUCT_SIZE_WITH_ID := 68

var struct_size := STRUCT_SIZE_WITH_ID

var time := 0
var ang_vel := Vector3.ZERO
var heading := 0.0
var pitch := 0.0
var roll := 0.0
var accel := Vector3.ZERO
var vel := Vector3.ZERO
var pos := Vector3i.ZERO
var id := 0


func _to_string() -> String:
	return "Time:%d, AngVel:%v, Heading:%f, Pitch:%f, Roll:%f, Accel:%v, Vel:%v, Pos:%v, ID:%d" % \
			[time, ang_vel, heading, pitch, roll, accel, vel, pos, id]


func set_from_buffer(buffer: PackedByteArray) -> void:
	var buffer_size := buffer.size()
	if buffer_size != STRUCT_SIZE_WITHOUT_ID and buffer_size != STRUCT_SIZE_WITH_ID:
		push_error("Wrong buffer size, expected %d or %d, got %d" % \
				[STRUCT_SIZE_WITH_ID, STRUCT_SIZE_WITH_ID, buffer_size])
		return
	time = buffer.decode_u32(0)
	ang_vel = Vector3(buffer.decode_float(4), buffer.decode_float(8), buffer.decode_float(12))
	heading = buffer.decode_float(16)
	pitch = buffer.decode_float(20)
	roll = buffer.decode_float(24)
	accel = Vector3(buffer.decode_float(28), buffer.decode_float(32), buffer.decode_float(36))
	vel = Vector3(buffer.decode_float(40), buffer.decode_float(44), buffer.decode_float(48))
	pos = Vector3i(buffer.decode_u32(52), buffer.decode_u32(56), buffer.decode_u32(60))
	if buffer_size == STRUCT_SIZE_WITH_ID:
		id = buffer.decode_u32(STRUCT_SIZE_WITHOUT_ID)
