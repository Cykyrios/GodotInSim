class_name PathNode
extends RefCounted

## PTH Node
##
## This class contains data about each path node contained in a [PTHFile].

var centre_x := 0
var centre_y := 0
var centre_z := 0
var dir_x := 0.0
var dir_y := 0.0
var dir_z := 0.0
var limit_left := 0.0
var limit_right := 0.0
var drive_left := 0.0
var drive_right := 0.0


func _to_string() -> String:
	return "Centre: %v, Dir: %.2v, Limits: %.2v, Drive: %.2v" % [Vector3i(centre_x, centre_y, centre_z),
			Vector3(dir_x, dir_y, dir_z), Vector2(limit_left, limit_right), Vector2(drive_left, drive_right)]
