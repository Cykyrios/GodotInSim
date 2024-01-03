class_name NodeLap
extends RefCounted


const STRUCT_SIZE := 6

var node := 0
var lap := 0
var player_id := 0
var position := 0


func _to_string() -> String:
	return "Node:%d, Lap:%d, PLID:%d, Pos:%d" % [node, lap, player_id, position]


func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	buffer.resize(STRUCT_SIZE)
	buffer.encode_u16(0, node)
	buffer.encode_u16(2, lap)
	buffer.encode_u8(4, player_id)
	buffer.encode_u8(5, position)
	return buffer


func set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	node = buffer.decode_u16(0)
	lap = buffer.decode_u16(2)
	player_id = buffer.decode_u8(4)
	position = buffer.decode_u8(5)
