class_name LYTObjectControl
extends LYTObject
## LYT control object
##
## Specific layout object representing autocross start position, checkpoints and the finish line.

## Control object types
enum Type {
	FINISH,
	CHECKPOINT_1,
	CHECKPOINT_2,
	CHECKPOINT_3,
}

## Control object colors, directly linked to their type.
const COLORS: Array[Color] = [
	Color.RED,
	Color.BLUE,
	Color.MEDIUM_PURPLE,
	Color.CYAN,
]

var type := Type.FINISH  ## Control object type
## Control object half-width
var half_width := 0:
	set(value):
		# 0 is allowed here as it represents an autocross start position
		half_width = clampi(value, 0, 31)


## Creates and returns a control object from the given parameters.
static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectControl:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var control_object := LYTObjectControl.new()
	control_object.set_from_buffer(object.get_buffer())
	control_object.type = control_object.flags & 0b11 as Type
	control_object.half_width = (control_object.flags >> 2) & 0b0001_1111
	return control_object


func _get_mesh() -> MeshInstance3D:
	if is_start_position():
		const HEIGHT := 0.2  # height above ground
		var vertices := PackedVector3Array()
		var indices := PackedInt32Array()
		var arrays := []
		var _resize := arrays.resize(Mesh.ARRAY_MAX)
		var _discard: Variant = null
		for i in 2:
			var x_sign := -1 if i == 0 else 1
			_discard = vertices.push_back(Vector3(x_sign * 0.5, -2, HEIGHT))
			_discard = vertices.push_back(Vector3(x_sign * 0.5, 0, HEIGHT))
			_discard = vertices.push_back(Vector3(x_sign * 1, 0, HEIGHT))
		_discard = vertices.push_back(Vector3(0, 2, HEIGHT))
		indices = PackedInt32Array([
			0, 1, 3,
			4, 3, 1,
			1, 2, 6,
			6, 5, 4,
			6, 4, 1,
		])
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		st.set_smooth_group(-1)
		for v in vertices:
			st.add_vertex(v)
		for idx in indices:
			st.add_index(idx)
		st.generate_normals()
		var mesh := st.commit()
		var mat := generate_default_material()
		mat.albedo_color = Color.GREEN
		mesh.surface_set_material(0, mat)
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = mesh
		return mesh_instance
	else:
		var mesh_instance := get_mesh_checkpoint(half_width)
		var mat := mesh_instance.mesh.surface_get_material(0) as StandardMaterial3D
		mat.albedo_color = COLORS[type]
		return mesh_instance


func _update_flags() -> void:
	flags = (flags & ~0b11) | type
	flags = (flags & ~(0b0001_1111 << 2)) | (half_width << 2)


## Returns [code]true[/code] if the control object is of type finish line and has no width.
func is_start_position() -> bool:
	return type == Type.FINISH and half_width == 0
