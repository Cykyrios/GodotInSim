class_name CarContact
extends InSimStruct
## Car contact data
##
## This struct holds car data when a contact with another car occurs.

## Conversion factor between standard units and LFS-encoded values
const POSITION_MULTIPLIER := 16.0
## Conversion factor between standard units and LFS-encoded values
const ACCELERATION_MULTIPLIER := 1.0
## Conversion factor between standard units and LFS-encoded values
const ANGLE_MULTIPLIER := 256 / 360.0
## Conversion factor between standard units and LFS-encoded values
const SPEED_MULTIPLIER := 1.0
## Conversion factor between standard units and LFS-encoded values
const STEER_MULTIPLIER := PI / 180.0

const STRUCT_SIZE := 16  ## The size of this struct's data

var plid := 0  ## player's unique id
var info := 0  ## like info byte in [CompCar] (CCI_BLUE / CCI_YELLOW / CCI_LAG)
var sp2 := 0  ## spare
var steer := 0  ## front wheel steer in degrees (right positive)

var throttle_brake := 0  ## high 4 bits: throttle / low 4 bits: brake (0 to 16)
var clutch_handbrake := 0  ## high 4 bits: clutch / low 4 bits: handbrake (0 to 16)
var gear := 0  ## high 4 bits: gear (15=R) / low 4 bits: spare
var spare := 0  ## spare
var speed := 0  ## m/s

var direction := 0  ## car's motion if Speed > 0: 0 = world y direction, 128 = 180 deg
var heading := 0  ## direction of forward axis: 0 = world y direction, 128 = 180 deg
var accel_forward := 0  ## m/s^2 longitudinal acceleration (forward positive)
var accel_right := 0  ## m/s^2 lateral acceleration (right positive)

var x := 0  ## position (1 metre = 16)
var y := 0  ## position (1 metre = 16)

var gis_position := Vector2.ZERO  ## Position vector in meters
var gis_speed := 0.0  ## Speed in m/s
var gis_acceleration := Vector2.ZERO  ## Acceleration in m/s^2
var gis_direction := 0.0  ## Direction in radians
var gis_heading := 0.0  ## Heading in radians
var gis_steer := 0.0  ## Steering angle in radians (positive angle when steering right)


func _to_string() -> String:
	return "PLID:%d, Info:%d, Sp2:%d, Steer:%d, ThrBrk:%d, CluHan:%d, GearSp:%d" % \
			[plid, info, sp2, steer, throttle_brake, clutch_handbrake, ((gear << 4) + spare)] \
			+ ", Speed:%d, Direction:%d, Heading:%d, AccelF:%d, AccelR:%d, X:%d, Y:%d" % \
			[speed, direction, heading, accel_forward, accel_right, x, y]


func _get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u8(0, plid)
	buffer.encode_u8(1, info)
	buffer.encode_u8(2, sp2)
	buffer.encode_u8(3, steer)
	buffer.encode_u8(4, throttle_brake)
	buffer.encode_u8(5, clutch_handbrake)
	buffer.encode_u8(6, (gear << 4) + spare)
	buffer.encode_u8(7, speed)
	buffer.encode_u8(8, direction)
	buffer.encode_u8(9, heading)
	buffer.encode_u8(10, accel_forward)
	buffer.encode_u8(11, accel_right)
	buffer.encode_s16(12, x)
	buffer.encode_s16(14, y)
	return buffer


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	plid = buffer.decode_u8(0)
	info = buffer.decode_u8(1)
	sp2 = buffer.decode_u8(2)
	steer = buffer.decode_s8(3)
	throttle_brake = buffer.decode_u8(4)
	clutch_handbrake = buffer.decode_u8(5)
	var gear_spare := buffer.decode_u8(6)
	gear = gear_spare >> 4
	spare = gear_spare & 0b1111
	speed = buffer.decode_u8(7)
	direction = buffer.decode_u8(8)
	heading = buffer.decode_u8(9)
	accel_forward = buffer.decode_s8(10)
	accel_right = buffer.decode_s8(11)
	x = buffer.decode_s16(12)
	y = buffer.decode_s16(14)


func _set_values_from_gis() -> void:
	x = roundi(gis_position.x * POSITION_MULTIPLIER)
	y = roundi(gis_position.y * POSITION_MULTIPLIER)
	heading = roundi(gis_heading * ANGLE_MULTIPLIER)
	direction = roundi(gis_direction * ANGLE_MULTIPLIER)
	speed = roundi(gis_speed * SPEED_MULTIPLIER)
	accel_forward = roundi(gis_acceleration.y * ACCELERATION_MULTIPLIER)
	accel_right = roundi(gis_acceleration.x * ACCELERATION_MULTIPLIER)
	steer = roundi(gis_steer * STEER_MULTIPLIER)


func _update_gis_values() -> void:
	gis_position = Vector2(x, y) / POSITION_MULTIPLIER
	gis_heading = heading / ANGLE_MULTIPLIER
	gis_direction = direction / ANGLE_MULTIPLIER
	gis_speed = speed / SPEED_MULTIPLIER
	gis_acceleration = Vector2(accel_right, accel_forward) / SPEED_MULTIPLIER
	gis_steer = steer / STEER_MULTIPLIER
