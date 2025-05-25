class_name SMXObject
extends RefCounted
## SMX Object
##
## Describes an SMX object as included in an [SMXFile].

## The size of an [SMXObject]'s data.
const STRUCT_SIZE := 24
## The conversion factor between SI units and LFS encoding.
const POSITION_MULTIPLIER := 65536.0

## The object's center point's x component.
var centre_x := 0
## The object's center point's y component.
var centre_y := 0
## The object's center point's z component.
var centre_z := 0
## The object's radius.
var radius := 0
## The number of [SMXPoint]s in this object.
var num_points := 0
## The number of [SMXTriangle]s in this object.
var num_tris := 0

## The object's center point, as a [Vector3] of SI units.
var centre := Vector3.ZERO

## Ths list of points in the object.
var points: Array[SMXPoint] = []
## The list of triangles in the object.
var triangles: Array[SMXTriangle] = []


func _to_string() -> String:
	return "Centre: %v, Radius: %d, Num Points: %d, Num Triangles: %d" % \
			[Vector3i(centre_x, centre_y, centre_z), radius, num_points, num_tris]


## Updates the [member centre] vector from raw values.
func fill_centre_vector() -> void:
	centre = Vector3(centre_x, centre_y, centre_z) / POSITION_MULTIPLIER


## Updates the raw [member centre_x], [member centre_y], and [member centre_z] from the
## [member centre] vector.
func fill_xyz() -> void:
	centre_x = roundi(centre.x * POSITION_MULTIPLIER)
	centre_y = roundi(centre.y * POSITION_MULTIPLIER)
	centre_z = roundi(centre.z * POSITION_MULTIPLIER)
