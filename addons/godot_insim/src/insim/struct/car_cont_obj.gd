class_name CarContObj
extends InSimStruct
## Car contact object
##
## This class contains data about a car when a contact with an object occurs.

## Conversion factor between standard units and LFS-encoded values.
const XY_MULTIPLIER := 16.0
## Conversion factor between standard units and LFS-encoded values.
const Z_MULTIPLIER := 4.0
## Conversion factor between standard units and LFS-encoded values.
const SPEED_MULTIPLIER := 1.0
## Conversion factor between standard units and LFS-encoded values.
const ANGLE_MULTIPLIER := 256 / 360.0

const STRUCT_SIZE := 8  ## The size of this struct's data

var direction := 0  ## car's motion if Speed > 0: 0 = world y direction, 128 = 180 deg
var heading := 0  ## direction of forward axis: 0 = world y direction, 128 = 180 deg
var speed := 0  ## m/s
var x := 0  ## position (1 metre = 16)
var y := 0  ## position (1 metre = 16)
var z := 0  ## position (1 metre = 4)

var gis_position := Vector3.ZERO  ## Position vector in meters
var gis_heading := 0.0  ## Heading in radians
var gis_direction := 0.0  ## Direction in radians
var gis_speed := 0.0  ## Speed in m/s


func _to_string() -> String:
	return "Direction:%d, Heading:%d, Speed:%d, Zbyte:%d, X:%d, Y:%d" % \
			[direction, heading, speed, z, x, y]


func _get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u8(0, direction)
	buffer.encode_u8(1, heading)
	buffer.encode_u8(2, speed)
	buffer.encode_u8(3, z)
	buffer.encode_s16(4, x)
	buffer.encode_s16(6, y)
	return buffer


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	direction = buffer.decode_u8(0)
	heading = buffer.decode_u8(1)
	speed = buffer.decode_u8(2)
	z = buffer.decode_u8(3)
	x = buffer.decode_s16(4)
	y = buffer.decode_s16(6)


func _set_values_from_gis() -> void:
	x = roundi(gis_position.x * XY_MULTIPLIER)
	y = roundi(gis_position.y * XY_MULTIPLIER)
	z = roundi(gis_position.z * Z_MULTIPLIER)
	heading = roundi(gis_heading * ANGLE_MULTIPLIER)
	direction = roundi(gis_direction * ANGLE_MULTIPLIER)
	speed = roundi(gis_speed * SPEED_MULTIPLIER)


func _update_gis_values() -> void:
	gis_position = Vector3(x / XY_MULTIPLIER, y / XY_MULTIPLIER, z / Z_MULTIPLIER)
	gis_direction = direction / ANGLE_MULTIPLIER
	gis_heading = heading / ANGLE_MULTIPLIER
	gis_speed = speed / SPEED_MULTIPLIER
