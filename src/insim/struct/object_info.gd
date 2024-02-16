class_name ObjectInfo
extends RefCounted


const STRUCT_SIZE := 8

var x := 0  ## position (1 metre = 16)
var y := 0  ## position (1 metre = 16)

var z := 0  ## height (1m = 4)
var flags := 0  ## various (see LFS LYT format description)
var index := 0  ## object index
var heading := 0  ## degrees * 180 * 256 / 360, with a value of 0 = 180 degrees, 128 = 0 degrees


func _to_string() -> String:
	return "X:%d, Y:%d, Z:%d, Flags:%d, Index:%d, Heading:%d" % [x, y, z, flags, index, heading]


func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
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
