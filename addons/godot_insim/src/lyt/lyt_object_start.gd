class_name LYTObjectStart
extends LYTObject
## LYT start position object
##
## Specific layout object representing a starting position (grid box).

var number := 0  ## start position index (0 for 1st, 1 for 2nd, etc.)


## Creates and returns a starting position object from the given parameters.
static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectStart:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var start_object := LYTObjectStart.new()
	start_object.set_from_buffer(object.get_buffer())
	start_object.number = start_object.flags & 0x3f
	return start_object


func _update_flags() -> void:
	flags = (flags & ~0x3f) | number
