class_name CarContObj
extends RefCounted


const STRUCT_SIZE := 8

var direction := 0
var heading := 0
var speed := 0
var z := 0

var x := 0
var y := 0


func _to_string() -> String:
	return "Direction:%d, Heading:%d, Speed:%d, Zbyte:%d, X:%d, Y:%d" % \
			[direction, heading, speed, z, x, y]


func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u8(0, direction)
	buffer.encode_u8(1, heading)
	buffer.encode_u8(2, speed)
	buffer.encode_u8(3, z)
	buffer.encode_s16(4, x)
	buffer.encode_s16(6, y)
	return buffer


func set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	direction = buffer.decode_u8(0)
	heading = buffer.decode_u8(1)
	speed = buffer.decode_u8(2)
	z = buffer.decode_u8(3)
	x = buffer.decode_s16(4)
	y = buffer.decode_s16(6)
