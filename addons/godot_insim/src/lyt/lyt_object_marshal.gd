class_name LYTObjectMarshal
extends LYTObject

## LYT control object
##
## Specific layout object representing a marshal object.

enum Marshal {
	NONE,
	STANDING,
	POINT_LEFT,
	POINT_RIGHT,
}

var marshal := 0
var radius := 0:
	set(value):
		radius = clampi(value, 1, 31)


static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectMarshal:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var marshal_object := LYTObjectMarshal.new()
	marshal_object.set_from_buffer(object.get_buffer())
	marshal_object.marshal = marshal_object.flags & 0b11
	marshal_object.radius = (marshal_object.flags >> 2) & 0b0001_1111
	return marshal_object


func _update_flags() -> void:
	flags = (flags & ~0b11) | marshal
	flags = (flags & ~(0b0001_1111 << 2)) | (radius << 2)
