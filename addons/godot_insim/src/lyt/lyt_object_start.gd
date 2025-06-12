class_name LYTObjectStart
extends LYTObject
## LYT start position object
##
## Specific layout object representing a starting position (grid box).

const MIN_POSITION := 0  ## Minimum position index ([code]start_position - 1[/code])
const MAX_POSITION := 47  ## Maximum position index ([code]start_position - 1[/code])

var start_position := 0  ## Start position (0 is not a valid number)


## Creates and returns a starting position object from the given parameters.
static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectStart:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var start_object := LYTObjectStart.new()
	start_object._set_from_buffer(object.get_buffer())
	return start_object


static func create_from_gis(
	obj_position: Vector3, obj_heading: float, obj_flags: int, obj_index: int
) -> LYTObjectStart:
	var object := super(obj_position, obj_heading, obj_flags, obj_index)
	var start_object := LYTObjectStart.new()
	start_object._set_from_buffer(object.get_buffer())
	return start_object


func _set_from_buffer(buffer: PackedByteArray) -> void:
	set_from_buffer(buffer)
	start_position = flags & 0x3f + 1


func _update_flags() -> void:
	flags = (flags & ~0x3f) | clampi(start_position - 1, MIN_POSITION, MAX_POSITION)
