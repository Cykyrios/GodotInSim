class_name LYTObject
extends RefCounted

## LYT object
##
## This class describes a layout object, as included in a layout (LYT) file.

const STRUCT_SIZE := 8

const XY_MULTIPLIER := 16.0
const Z_MULTIPLIER := 4.0
const HEADING_MULTIPLIER := 256 / 360.0

var x := 0
var y := 0
var z := 0
var flags := 0
var index := 0
var heading := 0

var gis_position := Vector3.ZERO
var gis_heading := 0.0


static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObject:
	var object := LYTObject.new()
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
	object.gis_heading = deg_to_rad(object.heading / HEADING_MULTIPLIER - 180)
	return object


static func create_from_gis(
	obj_position: Vector3, obj_heading: float, obj_flags: int, obj_index: int
) -> LYTObject:
	var object := LYTObject.new()
	object.gis_position = obj_position
	object.x = roundi(obj_position.x * XY_MULTIPLIER)
	object.y = roundi(obj_position.y * XY_MULTIPLIER)
	object.z = roundi(obj_position.z * Z_MULTIPLIER)
	object.flags = obj_flags
	object.index = obj_index
	object.heading = roundi((rad_to_deg(obj_heading) + 180) * HEADING_MULTIPLIER)
	return object


## Returns a [LYTObject] from the provided [param buffer]. Returns a blank object if [param buffer]
## is the wrong size.
static func create_from_buffer(buffer: PackedByteArray) -> LYTObject:
	if buffer.size() != STRUCT_SIZE:
		push_warning("Buffer size does not match LYTObject struct size.")
		return LYTObject.new()
	var object := LYTObject.new()
	object.x = buffer.decode_s16(0)
	object.y = buffer.decode_s16(2)
	object.z = buffer.decode_u8(4)
	object.flags = buffer.decode_u8(5)
	object.index = buffer.decode_u8(6)
	object.heading = buffer.decode_u8(7)
	return object


func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _resize := buffer.resize(STRUCT_SIZE)
	buffer.encode_s16(0, x)
	buffer.encode_s16(2, y)
	buffer.encode_u8(4, z)
	buffer.encode_u8(5, flags)
	buffer.encode_u8(6, index)
	buffer.encode_u8(7, heading)
	return buffer
