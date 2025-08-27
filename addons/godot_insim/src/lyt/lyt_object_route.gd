class_name LYTObjectRoute
extends LYTObject
## LYT route checker object
##
## Specific layout object representing a route checker object.


var route_index := 0  ## The object's route index
## The object's radius
var radius := 0:
	set(value):
		radius = clampi(value, 1, 31)


func _apply_flags() -> void:
	radius = (flags >> 2) & 0b0001_1111


func _get_mesh() -> MeshInstance3D:
	var mesh_instance := _get_mesh_circle(radius)
	var mat := mesh_instance.mesh.surface_get_material(0) as StandardMaterial3D
	mat.albedo_color = Color.GREEN
	return mesh_instance


func _set_from_object_info(info: ObjectInfo) -> void:
	route_index = info.heading


func _update_flags() -> void:
	flags = (flags & ~(0b0001_1111 << 2)) | (radius << 2)
