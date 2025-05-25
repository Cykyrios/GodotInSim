class_name SMXPoint
extends RefCounted
## SMX Point
##
## Point data included in an [SMXObject].

## The size of the included data.
const STRUCT_SIZE := 16
## The conversion factor between SI units and LFS encoding.
const POSITION_MULTIPLIER := 65536.0

## The point's x coordinate.
var x := 0
## The point's y coordinate.
var y := 0
## The point's z coordinate.
var z := 0
## The point's color, encoded as a single 32-bit integer.
var buffer_color := 0

## The point's position vector.
var position := Vector3.ZERO
## The point's color.
var color := Color()


func _to_string() -> String:
	return "Position: %v, Color: %s" % [Vector3i(x, y, z), buffer_color]


## Updates the [member position] vector from the raw values.
func fill_position_vector() -> void:
	position = Vector3(x, y, z) / POSITION_MULTIPLIER


## Updates the [member buffer_color] from the [member color].
func color_to_buffer_color() -> void:
	buffer_color = (color.a8 << 24) + (color.r8 << 16) + (color.g8 << 8) + color.b8
	if color.r > 1 or color.g > 1 or color.b > 1 or color.a > 1:
		print(color, "%d:%d:%d:%d" % [color.r8, color.g8, color.b8, color.a8])


## Updates the [member color] from the raw [member buffer_color].
func convert_color() -> void:
	color = Color.from_rgba8(
		(buffer_color >> 16) & 0xff,
		(buffer_color >> 8) & 0xff,
		(buffer_color >> 0) & 0xff,
		(buffer_color >> 24) & 0xff
	)


## Updates the raw position components from the [member position] vector.
func fill_xyz() -> void:
	x = roundi(position.x * POSITION_MULTIPLIER)
	y = roundi(position.y * POSITION_MULTIPLIER)
	z = roundi(position.z * POSITION_MULTIPLIER)
