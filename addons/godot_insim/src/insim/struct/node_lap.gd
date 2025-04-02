class_name NodeLap
extends InSimStruct


const STRUCT_SIZE := 6

var node := 0  ## current path node
var lap := 0  ## current lap
var plid := 0  ## player's unique id
var position := 0  ## current race position: 0 = unknown, 1 = leader, etc...


func _to_string() -> String:
	return "Node:%d, Lap:%d, PLID:%d, Pos:%d" % [node, lap, plid, position]


func _get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u16(0, node)
	buffer.encode_u16(2, lap)
	buffer.encode_u8(4, plid)
	buffer.encode_u8(5, position)
	return buffer


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	node = buffer.decode_u16(0)
	lap = buffer.decode_u16(2)
	plid = buffer.decode_u8(4)
	position = buffer.decode_u8(5)
