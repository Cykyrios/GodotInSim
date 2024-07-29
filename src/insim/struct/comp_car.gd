class_name CompCar
extends InSimStruct


const POSITION_MULTIPLIER := 65536.0
const SPEED_MULTIPLIER := 327.68
const ANGLE_MULTIPLIER := 65536 / 360.0
const ANGVEL_MULTIPLIER := 16384 / 360.0

const STRUCT_SIZE := 28

var node := 0  ## current path node
var lap := 0  ## current lap
var player_id := 0  ## player's unique id
var position := 0  ## current race position: 0 = unknown, 1 = leader, etc...
var info := 0  ## flags and other info - see below
var sp3 := 0
var x := 0  ## X map (65536 = 1 metre)
var y := 0  ## Y map (65536 = 1 metre)
var z := 0  ## Z alt (65536 = 1 metre)
var speed := 0  ## speed (32768 = 100 m/s)
var direction := 0  ## car's motion if Speed > 0: 0 = world y direction, 32768 = 180 deg
var heading := 0  ## direction of forward axis: 0 = world y direction, 32768 = 180 deg
var ang_vel := 0  ## signed, rate of change of heading: (16384 = 360 deg/s)

var gis_position := Vector3.ZERO
var gis_speed := 0.0
var gis_direction := 0.0
var gis_heading := 0.0
var gis_angular_velocity := 0.0


func _to_string() -> String:
	return "Node:%d, Lap:%d, PLID:%d, Pos:%d, Info:%d, Sp3:%d, X:%d, Y:%d, Z:%d" % \
			[node, lap, player_id, position, info, sp3, x, y, z] \
			+ ", Speed:%d, Direction:%d, Heading:%d, AngVel:%d" % [speed, direction, heading, ang_vel]


func _get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u16(0, node)
	buffer.encode_u16(2, lap)
	buffer.encode_u8(4, player_id)
	buffer.encode_u8(5, position)
	buffer.encode_u8(6, info)
	buffer.encode_u8(7, sp3)
	buffer.encode_s32(8, x)
	buffer.encode_s32(12, y)
	buffer.encode_s32(16, z)
	buffer.encode_u16(20, speed)
	buffer.encode_u16(22, direction)
	buffer.encode_u16(24, heading)
	buffer.encode_s16(26, ang_vel)
	return buffer


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	node = buffer.decode_u16(0)
	lap = buffer.decode_u16(2)
	player_id = buffer.decode_u8(4)
	position = buffer.decode_u8(5)
	info = buffer.decode_u8(6)
	sp3 = buffer.decode_u8(7)
	x = buffer.decode_s32(8)
	y = buffer.decode_s32(12)
	z = buffer.decode_s32(16)
	speed = buffer.decode_u16(20)
	direction = buffer.decode_u16(22)
	heading = buffer.decode_u16(24)
	ang_vel = buffer.decode_s16(26)


func _set_values_from_gis() -> void:
	x = int(gis_position.x * POSITION_MULTIPLIER)
	y = int(gis_position.y * POSITION_MULTIPLIER)
	z = int(gis_position.z * POSITION_MULTIPLIER)
	speed = int(gis_speed * SPEED_MULTIPLIER)
	direction = int(rad_to_deg(gis_direction * ANGLE_MULTIPLIER))
	heading = int(rad_to_deg(gis_heading * ANGLE_MULTIPLIER))
	ang_vel = int(rad_to_deg(gis_angular_velocity * ANGVEL_MULTIPLIER))


func _update_gis_values() -> void:
	gis_position = Vector3(x, y, z) / POSITION_MULTIPLIER
	gis_speed = speed / SPEED_MULTIPLIER
	gis_direction = deg_to_rad(direction / ANGLE_MULTIPLIER)
	gis_heading = deg_to_rad(heading / ANGLE_MULTIPLIER)
	gis_angular_velocity = deg_to_rad(ang_vel / ANGVEL_MULTIPLIER)
