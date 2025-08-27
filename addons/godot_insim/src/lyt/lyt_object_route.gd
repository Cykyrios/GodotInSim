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


## Creates and returns a route checker object from the given parameters.
static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectRoute:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var route_object := LYTObjectRoute.new()
	route_object.set_from_buffer(object.get_buffer())
	route_object.route_index = route_object.heading
	route_object.radius = (route_object.flags >> 2) & 0b0001_1111
	return route_object


func _get_mesh() -> MeshInstance3D:
	var mesh_instance := _get_mesh_circle(radius)
	var mat := mesh_instance.mesh.surface_get_material(0) as StandardMaterial3D
	mat.albedo_color = Color.GREEN
	return mesh_instance


func _update_flags() -> void:
	flags = (flags & ~(0b0001_1111 << 2)) | (radius << 2)
