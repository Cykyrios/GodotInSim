class_name ObjectInfo
extends RefCounted


const STRUCT_SIZE := 8

var x := 0
var y := 0

var z := 0
var flags := 0
var index := 0
var heading := 0


func _to_string() -> String:
	return "X:%d, Y:%d, Z:%d, Flags:%d, Index:%d, Heading:%d" % [x, y, z, flags, index, heading]


func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	buffer.resize(STRUCT_SIZE)
	buffer.encode_s16(0, x)
	buffer.encode_s16(2, y)
	buffer.encode_u8(4, z)
	buffer.encode_u8(5, flags)
	buffer.encode_u8(6, index)
	buffer.encode_u8(7, heading)
	return buffer


func set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	x = buffer.decode_u16(0)
	y = buffer.decode_u16(2)
	z = buffer.decode_u8(4)
	flags = buffer.decode_u8(5)
	index = buffer.decode_u8(6)
	heading = buffer.decode_u8(7)
