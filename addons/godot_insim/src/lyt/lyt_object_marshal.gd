class_name LYTObjectMarshal
extends LYTObject
## LYT marshal object
##
## Specific layout object representing a marshal object.

## Marshal types
enum Marshal {
	NONE,
	STANDING,
	POINT_LEFT,
	POINT_RIGHT,
}

var marshal := Marshal.NONE  ## Marshal type
## Radius of the control zone
var radius := 0:
	set(value):
		radius = clampi(value, 0 if is_marshal_visible() else 1, 31)


## Creates and returns a marshal object from the given parameters.
static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectMarshal:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var marshal_object := LYTObjectMarshal.new()
	marshal_object.set_from_buffer(object.get_buffer())
	marshal_object.marshal = marshal_object.flags & 0b11 as Marshal
	marshal_object.radius = (marshal_object.flags >> 2) & 0b0001_1111
	return marshal_object


func _get_mesh() -> MeshInstance3D:
	var mesh_instance := get_mesh_circle(radius)
	var mat := mesh_instance.mesh.surface_get_material(0) as StandardMaterial3D
	mat.albedo_color = Color.RED
	#TODO: Add model for visible marshal
	return mesh_instance


func _update_flags() -> void:
	flags = (flags & ~0b11) | marshal
	flags = (flags & ~(0b0001_1111 << 2)) | (radius << 2)


## Returns [code]true[/code] if [member marshal] is not [constant Marshal.NONE].
func is_marshal_visible() -> bool:
	return marshal != Marshal.NONE
