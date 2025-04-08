class_name LYTObjectControl
extends LYTObject

## LYT control object
##
## Specific layout object representing start positions, checkpoints and the finish line.

enum Type {
	FINISH,
	CHECKPOINT_1,
	CHECKPOINT_2,
	CHECKPOINT_3,
}

var type := Type.FINISH
var half_width := 0:
	set(value):
		# 0 is allowed here as it represents an autocross start position
		half_width = clampi(value, 0, 31)


static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectControl:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var control_object := LYTObjectControl.new()
	control_object.set_from_buffer(object.get_buffer())
	control_object.type = control_object.flags & 0b11 as Type
	control_object.half_width = (control_object.flags >> 2) & 0b0001_1111
	return control_object


func _update_flags() -> void:
	flags = (flags & ~0b11) | type
	flags = (flags & ~(0b0001_1111 << 2)) | (half_width << 2)


func is_start_position() -> bool:
	return type == 0 and half_width == 0
