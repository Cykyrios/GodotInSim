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


func _apply_flags() -> void:
	marshal = flags & 0b11 as Marshal
	radius = (flags >> 2) & 0b0001_1111


func _get_mesh() -> MeshInstance3D:
	var mesh_instance := _get_mesh_circle(radius)
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
