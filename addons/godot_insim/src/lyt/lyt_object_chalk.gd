class_name LYTObjectChalk
extends LYTObject

## LYT control object
##
## Specific layout object representing a chalk line.

enum ChalkColor {
	WHITE,
	RED,
	BLUE,
	YELLOW,
}

var color := ChalkColor.WHITE


static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectChalk:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var chalk_object := LYTObjectChalk.new()
	chalk_object.set_from_buffer(object.get_buffer())
	chalk_object.color = object.flags & 0b11 as ChalkColor
	return chalk_object


func _update_flags() -> void:
	flags = (flags & ~0b11) | color
