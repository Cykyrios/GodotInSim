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


func _apply_flags() -> void:
	type = flags & 0b11 as Type
	half_width = (flags >> 2) & 0b0001_1111


func _get_mesh() -> MeshInstance3D:
	var mesh_instance := _get_mesh_checkpoint(half_width)
	var mat := mesh_instance.mesh.surface_get_material(0) as StandardMaterial3D
	mat.albedo_color = Color.YELLOW.lightened(0.5)
	return mesh_instance


func _update_flags() -> void:
	flags = (flags & ~0b11) | type
	flags = (flags & ~(0b0001_1111 << 2)) | (half_width << 2)
