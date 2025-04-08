class_name LYTObjectTyre
extends LYTObject

## LYT control object
##
## Specific layout object representing a tyre or tyre stack.

enum TyreColor {
	BLACK,
	WHITE,
	RED,
	BLUE,
	GREEN,
	YELLOW,
}
var color := TyreColor.BLACK


static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectTyre:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var tyre_object := LYTObjectTyre.new()
	tyre_object.set_from_buffer(object.get_buffer())
	tyre_object.color = tyre_object.flags & 0b111 as TyreColor
	return tyre_object


func _update_flags() -> void:
	flags = (flags & ~0b111) | color
