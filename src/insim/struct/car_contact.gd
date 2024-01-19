class_name CarContact
extends RefCounted


const STRUCT_SIZE := 16

var player_id := 0
var info := 0
var sp2 := 0
var steer := 0

var throttle_brake := 0
var clutch_handbrake := 0
var gear_spare := 0
var speed := 0

var direction := 0
var heading := 0
var accel_forward := 0
var accel_right := 0

var x := 0
var y := 0


func _to_string() -> String:
	return "PLID:%d, Info:%d, Sp2:%d, Steer:%d, ThrBrk:%d, CluHan:%d, GearSp:%d, Speed:%d" % \
			[player_id, info, sp2, steer, throttle_brake, clutch_handbrake, gear_spare, speed] \
			+ ", Direction:%d, Heading:%d, AccelF:%d, AccelR:%d, X:%d, Y:%d" % \
			[direction, heading, accel_forward, accel_right, x, y]


func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u8(0, player_id)
	buffer.encode_u8(1, info)
	buffer.encode_u8(2, sp2)
	buffer.encode_u8(3, steer)
	buffer.encode_u8(4, throttle_brake)
	buffer.encode_u8(5, clutch_handbrake)
	buffer.encode_u8(6, gear_spare)
	buffer.encode_u8(7, speed)
	buffer.encode_u8(8, direction)
	buffer.encode_u8(9, heading)
	buffer.encode_u8(10, accel_forward)
	buffer.encode_u8(11, accel_right)
	buffer.encode_s16(12, x)
	buffer.encode_s16(14, y)
	return buffer


func set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	player_id = buffer.decode_u8(0)
	info = buffer.decode_u8(1)
	sp2 = buffer.decode_u8(2)
	steer = buffer.decode_u8(3)
	throttle_brake = buffer.decode_u8(4)
	clutch_handbrake = buffer.decode_u8(5)
	gear_spare = buffer.decode_u8(6)
	speed = buffer.decode_u8(7)
	direction = buffer.decode_u8(8)
	heading = buffer.decode_u8(9)
	accel_forward = buffer.decode_u8(10)
	accel_right = buffer.decode_u8(11)
	x = buffer.decode_s16(12)
	y = buffer.decode_s16(14)
