class_name LYTObjectCircle
extends LYTObject

## LYT control object
##
## Specific layout object representing an InSim circle object.

var circle_index := 0
var radius := 0:
	set(value):
		radius = clampi(value, 1, 31)


static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectCircle:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var circle_object := LYTObjectCircle.new()
	circle_object.set_from_buffer(object.get_buffer())
	circle_object.circle_index = circle_object.heading
	circle_object.radius = (circle_object.flags >> 2) & 0b0001_1111
	return circle_object


func _get_mesh() -> MeshInstance3D:
	var mesh_instance := get_mesh_circle(radius)
	var mat := mesh_instance.mesh.surface_get_material(0) as StandardMaterial3D
	mat.albedo_color = Color.YELLOW
	return mesh_instance


func _update_flags() -> void:
	flags = (flags & ~(0b0001_1111 << 2)) | (radius << 2)
