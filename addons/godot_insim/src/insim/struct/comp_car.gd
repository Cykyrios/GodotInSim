class_name CompCar
extends RefCounted


const STRUCT_SIZE := 28

var node := 0
var lap := 0
var player_id := 0
var position := 0
var info := 0
var sp3 := 0
var x := 0
var y := 0
var z := 0
var speed := 0
var direction := 0
var heading := 0
var ang_vel := 0


func _to_string() -> String:
	return "Node:%d, Lap:%d, PLID:%d, Pos:%d, Info:%d, Sp3:%d, X:%d, Y:%d, Z:%d" % \
			[node, lap, player_id, position, info, sp3, x, y, z] \
			+ ", Speed:%d, Direction:%d, Heading:%d, AngVel:%d" % [speed, direction, heading, ang_vel]


func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u16(0, node)
	buffer.encode_u16(2, lap)
	buffer.encode_u8(4, player_id)
	buffer.encode_u8(5, position)
	buffer.encode_u8(6, sp3)
	buffer.encode_u32(7, x)
	buffer.encode_u32(11, y)
	buffer.encode_u32(15, z)
	buffer.encode_u16(19, speed)
	buffer.encode_u16(21, direction)
	buffer.encode_u16(23, heading)
	buffer.encode_s16(25, ang_vel)
	return buffer


func set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	node = buffer.decode_u16(0)
	lap = buffer.decode_u16(2)
	player_id = buffer.decode_u8(4)
	position = buffer.decode_u8(5)
	sp3 = buffer.decode_u8(6)
	x = buffer.decode_u32(7)
	y = buffer.decode_u32(11)
	z = buffer.decode_u32(15)
	speed = buffer.decode_u16(19)
	direction = buffer.decode_u16(21)
	heading = buffer.decode_u16(23)
	ang_vel = buffer.decode_s16(25)
