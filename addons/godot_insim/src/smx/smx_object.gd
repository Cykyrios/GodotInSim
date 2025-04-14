class_name SMXObject
extends RefCounted

## SMX Object
##
## Describes an SMX object as included in an [SMXFile].

const STRUCT_SIZE := 24
const POSITION_MULTIPLIER := 65536.0

var centre_x := 0
var centre_y := 0
var centre_z := 0
var radius := 0
var num_points := 0
var num_tris := 0

var centre := Vector3.ZERO

var points: Array[SMXPoint] = []
var triangles: Array[SMXTriangle] = []


func _to_string() -> String:
	return "Centre: %v, Radius: %d, Num Points: %d, Num Triangles: %d" % \
			[Vector3i(centre_x, centre_y, centre_z), radius, num_points, num_tris]


func fill_centre_vector() -> void:
	centre = Vector3(centre_x, centre_y, centre_z) / POSITION_MULTIPLIER


func fill_xyz() -> void:
	centre_x = roundi(centre.x * POSITION_MULTIPLIER)
	centre_y = roundi(centre.y * POSITION_MULTIPLIER)
	centre_z = roundi(centre.z * POSITION_MULTIPLIER)
