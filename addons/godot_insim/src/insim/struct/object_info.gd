class_name ObjectInfo
extends InSimStruct
## Object info
##
## This class contains data about layout objects.

## Conversion factor between standard units and LFS-encoded values.
const XY_MULTIPLIER := 16.0
## Conversion factor between standard units and LFS-encoded values.
const Z_MULTIPLIER := 4.0
## Conversion factor between standard units and LFS-encoded values.
const ANGLE_MULTIPLIER := 256 / 360.0

const STRUCT_SIZE := 8  ## The size of this struct's data.

var x := 0  ## position (1 metre = 16)
var y := 0  ## position (1 metre = 16)

var z := 0  ## height (1m = 4)
var flags := 0  ## various (see LFS LYT format description)
var index := 0  ## object index
var heading := 0  ## (degrees + 180) * 256 / 360

var gis_position := Vector3.ZERO  ## Position vector in meters
var gis_heading := 0.0  ## Heading in radians


static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> ObjectInfo:
	var object := ObjectInfo.new()
	object.x = obj_x
	object.y = obj_y
	object.z = obj_z
	object.gis_position = Vector3(
		obj_x / XY_MULTIPLIER,
		obj_y / XY_MULTIPLIER,
		obj_z / Z_MULTIPLIER
	)
	object.flags = obj_flags
	object.index = obj_index
	object.heading = obj_heading
	object.gis_heading = deg_to_rad(object.heading / ANGLE_MULTIPLIER - 180)
	object.update_gis_values()
	return object


static func create_from_gis(
	obj_position: Vector3, obj_heading: float, obj_flags: int, obj_index: int
) -> ObjectInfo:
	var object := ObjectInfo.new()
	object.gis_position = obj_position
	object.x = roundi(obj_position.x * XY_MULTIPLIER)
	object.y = roundi(obj_position.y * XY_MULTIPLIER)
	object.z = roundi(obj_position.z * Z_MULTIPLIER)
	object.flags = obj_flags
	object.index = obj_index
	object.gis_heading = obj_heading
	object.heading = roundi((rad_to_deg(obj_heading) + 180) * ANGLE_MULTIPLIER)
	object.set_values_from_gis()
	return object


func _to_string() -> String:
	return "X:%d, Y:%d, Z:%d, Flags:%d, Index:%d, Heading:%d" % [x, y, z, flags, index, heading]


func _get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_s16(0, x)
	buffer.encode_s16(2, y)
	buffer.encode_u8(4, z)
	buffer.encode_u8(5, flags)
	buffer.encode_u8(6, index)
	buffer.encode_u8(7, heading)
	return buffer


func _get_dictionary() -> Dictionary:
	return {
		"X": x,
		"Y": y,
		"Z": z,
		"Flags": flags,
		"Index": index,
		"Heading": heading,
	}


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	x = buffer.decode_s16(0)
	y = buffer.decode_s16(2)
	z = buffer.decode_u8(4)
	flags = buffer.decode_u8(5)
	index = buffer.decode_u8(6)
	heading = buffer.decode_u8(7)


func _set_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["X", "Y", "Z", "Flags", "Index", "Heading"]):
		return
	x = dict["X"]
	y = dict["Y"]
	z = dict["Z"]
	flags = dict["Flags"]
	index = dict["Index"]
	heading = dict["Heading"]


func _set_values_from_gis() -> void:
	x = roundi(gis_position.x * XY_MULTIPLIER)
	y = roundi(gis_position.y * XY_MULTIPLIER)
	z = roundi(gis_position.z * Z_MULTIPLIER)
	heading = roundi((180 + rad_to_deg(gis_heading)) * ANGLE_MULTIPLIER)


func _update_gis_values() -> void:
	gis_position = Vector3(x / XY_MULTIPLIER, y / XY_MULTIPLIER, z / Z_MULTIPLIER)
	gis_heading = deg_to_rad(heading / ANGLE_MULTIPLIER - 180)
