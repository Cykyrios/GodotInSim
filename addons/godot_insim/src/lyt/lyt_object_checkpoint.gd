class_name LYTObjectCheckpoint
extends LYTObject
## LYT checkpoint object
##
## Specific layout object representing an InSim checkpoint.

## Enum representing the checkpoint's type.
enum Type {
	FINISH,
	CHECKPOINT_1,
	CHECKPOINT_2,
	CHECKPOINT_3,
}

var type := Type.FINISH  ## The object's type
## Half of the checkpoint's total width.
var half_width := 0:
	set(value):
		half_width = clampi(value, 1, 31)


## Creates and returns a new [LYTObjectCheckpoint] from the given parameters.
static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectCheckpoint:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var checkpoint_object := LYTObjectCheckpoint.new()
	checkpoint_object.set_from_buffer(object.get_buffer())
	checkpoint_object.type = checkpoint_object.flags & 0b11 as Type
	checkpoint_object.half_width = (checkpoint_object.flags >> 2) & 0b0001_1111
	return checkpoint_object


func _get_mesh() -> MeshInstance3D:
	var mesh_instance := get_mesh_checkpoint(half_width)
	var mat := mesh_instance.mesh.surface_get_material(0) as StandardMaterial3D
	mat.albedo_color = Color.YELLOW.lightened(0.5)
	return mesh_instance


func _update_flags() -> void:
	flags = (flags & ~0b11) | type
	flags = (flags & ~(0b1111 << 2)) | (half_width << 2)
