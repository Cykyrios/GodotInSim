class_name SMXPoint
extends RefCounted

## SMX Point
##
## Point data included in an [SMXObject].


var x := 0
var y := 0
var z := 0
var buffer_color := 0

var position := Vector3.ZERO
var color := Color()


func _to_string() -> String:
	return "Position: %v, Color: %s" % [Vector3i(x, y, z), buffer_color]


func fill_position_vector() -> void:
	position = Vector3(x, y, z) / 65536


func convert_color() -> void:
	color = Color(
		(buffer_color >> 16) & 0xff,
		(buffer_color >> 8) & 0xff,
		(buffer_color >> 0) & 0xff,
		(buffer_color >> 24) & 0xff,
		) / 255
