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
	return _get_marshal_mesh()


func _update_flags() -> void:
	flags = (flags & ~0b11) | marshal
	flags = (flags & ~(0b0001_1111 << 2)) | (radius << 2)


## Returns [code]true[/code] if [member marshal] is not [constant Marshal.NONE].
func is_marshal_visible() -> bool:
	return marshal != Marshal.NONE


func _get_marshal_mesh() -> MeshInstance3D:
	var mesh_instance := _get_mesh_circle(radius)
	var mat := mesh_instance.mesh.surface_get_material(0) as StandardMaterial3D
	mat.albedo_color = Color.RED
	if marshal != Marshal.NONE:
		var add_box := func add_box(
			dimensions: Vector3, position := Vector3.ZERO, quaternion := Quaternion.IDENTITY
		) -> Dictionary:
			var _vertices := PackedVector3Array([
				Vector3(-0.5 * dimensions.x, -0.5 * dimensions.y, 0),
				Vector3(0.5 * dimensions.x, -0.5 * dimensions.y, 0),
				Vector3(-0.5 * dimensions.x, 0.5 * dimensions.y, 0),
				Vector3(0.5 * dimensions.x, 0.5 * dimensions.y, 0),
				Vector3(-0.5 * dimensions.x, -0.5 * dimensions.y, dimensions.z),
				Vector3(0.5 * dimensions.x, -0.5 * dimensions.y, dimensions.z),
				Vector3(-0.5 * dimensions.x, 0.5 * dimensions.y, dimensions.z),
				Vector3(0.5 * dimensions.x, 0.5 * dimensions.y, dimensions.z),
			])
			var _indices := PackedInt32Array([
				0, 1, 2, 3, 2, 1,  # Z- face
				6, 5, 4, 5, 6, 7,  # Z+ face
				4, 1, 0, 1, 4, 5,  # Y- face
				2, 3, 6, 7, 6, 3,  # Y+ face
				0, 2, 4, 6, 4, 2,  # X- face
				5, 3, 1, 3, 5, 7,  # X+ face
			])
			for i in _vertices.size():
				_vertices[i] = quaternion * _vertices[i] + position
			return {
				"vertices": _vertices,
				"indices": _indices,
			}
		var add_mesh_surface := func add_mesh_surface(
			surface_tool: SurfaceTool, mesh_data_dict: Dictionary, mesh: ArrayMesh
		) -> ArrayMesh:
			surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
			surface_tool.set_smooth_group(-1)
			for v in mesh_data_dict["vertices"] as Array[Vector3]:
				surface_tool.add_vertex(v)
			for idx in mesh_data_dict["indices"] as Array[int]:
				surface_tool.add_index(idx)
			surface_tool.generate_normals()
			return surface_tool.commit(mesh)

		var st := SurfaceTool.new()
		var foot_dimensions := Vector3(0.09, 0.28, 0.08)
		var leg_dimensions := Vector3(0.12, 0.15, 0.9)
		var torso_dimensions := Vector3(0.35, 0.2, 0.6)
		var arm_dimensions := Vector3(0.1, 0.1, 0.75)
		var head_dimensions := Vector3(0.2, 0.25, 0.25)
		var right_foot_position := (
			Vector3(0.16, 0.04, 0) if marshal == Marshal.POINT_LEFT
			else Vector3(0.27, 0.06, 0) if marshal == Marshal.POINT_RIGHT
			else Vector3(0.12, -0.1, 0)
		)
		var right_foot_rotation := (
			Quaternion(Vector3(0, 0, 1), deg_to_rad(-2)) if marshal == Marshal.POINT_LEFT
			else Quaternion(Vector3(0, 0, 1), deg_to_rad(-30)) if marshal == Marshal.POINT_RIGHT
			else Quaternion(Vector3(0, 0, 1), deg_to_rad(-20))
		)
		var left_foot_position := (
			Vector3(-0.27, 0.06, 0) if marshal == Marshal.POINT_LEFT
			else Vector3(-0.16, 0.04, 0) if marshal == Marshal.POINT_RIGHT
			else Vector3(-0.17, 0, 0)
		)
		var left_foot_rotation := (
			Quaternion(Vector3(0, 0, 1), deg_to_rad(30)) if marshal == Marshal.POINT_LEFT
			else Quaternion(Vector3(0, 0, 1), deg_to_rad(2)) if marshal == Marshal.POINT_RIGHT
			else Quaternion(Vector3(0, 0, 1), deg_to_rad(5))
		)
		var right_leg_position := (
			Vector3(0.16, -0.06, 0.08) if marshal == Marshal.POINT_LEFT
			else Vector3(0.22, 0, 0.08) if marshal == Marshal.POINT_RIGHT
			else Vector3(0.1, -0.16, 0.08)
		)
		var right_leg_rotation := (
			Quaternion(Vector3(0, 1, 0), deg_to_rad(-5)) if marshal == Marshal.POINT_LEFT
			else Quaternion(Vector3(0, 1, 0), deg_to_rad(-5))
			* Quaternion(Vector3(0, 0, 1), deg_to_rad(-30))
			* Quaternion(Vector3(1, 0, 0), deg_to_rad(4)) if marshal == Marshal.POINT_RIGHT
			else Quaternion(Vector3(0, 1, 0), deg_to_rad(2))
			* Quaternion(Vector3(0, 0, 1), deg_to_rad(-20))
			* Quaternion(Vector3(1, 0, 0), deg_to_rad(-2))
		)
		var left_leg_position := (
			Vector3(-0.22, 0, 0.08) if marshal == Marshal.POINT_LEFT
			else Vector3(-0.16, -0.06, 0.08) if marshal == Marshal.POINT_RIGHT
			else Vector3(-0.15, -0.06, 0.08)
		)
		var left_leg_rotation := (
			Quaternion(Vector3(0, 1, 0), deg_to_rad(5))
			* Quaternion(Vector3(0, 0, 1), deg_to_rad(30))
			* Quaternion(Vector3(1, 0, 0), deg_to_rad(4)) if marshal == Marshal.POINT_LEFT
			else Quaternion(Vector3(0, 1, 0), deg_to_rad(5)) if marshal == Marshal.POINT_RIGHT
			else Quaternion(Vector3(0, 1, 0), deg_to_rad(8))
			* Quaternion(Vector3(0, 0, 1), deg_to_rad(5))
			* Quaternion(Vector3(1, 0, 0), deg_to_rad(2))
		)
		var torso_position := (
			Vector3(0, -0.05, 0.95) if marshal == Marshal.POINT_LEFT
			else Vector3(0, -0.05, 0.95) if marshal == Marshal.POINT_RIGHT
			else Vector3(0.05, -0.13, 0.95)
		)
		var torso_rotation := (
			Quaternion.IDENTITY if marshal == Marshal.POINT_LEFT
			else Quaternion.IDENTITY if marshal == Marshal.POINT_RIGHT
			else Quaternion(Vector3(0, 0, 1), deg_to_rad(-5))
		)
		var right_arm_position := (
			Vector3(0.18, -0.05, 1.5) if marshal == Marshal.POINT_LEFT
			else Vector3(0.18, -0.05, 1.55) if marshal == Marshal.POINT_RIGHT
			else Vector3(0.26, -0.15, 1.5)
		)
		var right_arm_rotation := (
			Quaternion(Vector3(0, 1, 0), deg_to_rad(170))
			* Quaternion(Vector3(1, 0, 0), deg_to_rad(4)) if marshal == Marshal.POINT_LEFT
			else Quaternion(Vector3(0, 1, 0), deg_to_rad(85))
			* Quaternion(Vector3(0, 0, 1), deg_to_rad(-3)) if marshal == Marshal.POINT_RIGHT
			else Quaternion(Vector3(0, 1, 0), deg_to_rad(175))
			* Quaternion(Vector3(1, 0, 0), deg_to_rad(-5))
		)
		var left_arm_position := (
			Vector3(-0.18, -0.05, 1.55) if marshal == Marshal.POINT_LEFT
			else Vector3(-0.18, -0.05, 1.5) if marshal == Marshal.POINT_RIGHT
			else Vector3(-0.16, -0.1, 1.55)
		)
		var left_arm_rotation := (
			Quaternion(Vector3(0, 1, 0), deg_to_rad(-85))
			* Quaternion(Vector3(0, 0, 1), deg_to_rad(3)) if marshal == Marshal.POINT_LEFT
			else Quaternion(Vector3(0, 1, 0), deg_to_rad(-170))
			* Quaternion(Vector3(1, 0, 0), deg_to_rad(4)) if marshal == Marshal.POINT_RIGHT
			else Quaternion(Vector3(0, 1, 0), deg_to_rad(-175))
			* Quaternion(Vector3(1, 0, 0), deg_to_rad(-5))
		)
		var head_position := (
			Vector3(0, -0.04, 1.57) if marshal == Marshal.POINT_LEFT
			else Vector3(0, -0.04, 1.57) if marshal == Marshal.POINT_RIGHT
			else Vector3(0.05, -0.1, 1.57)
		)
		var head_rotation := (
			Quaternion(Vector3(0, 1, 0), deg_to_rad(5))
			* Quaternion(Vector3(0, 0, 1), deg_to_rad(5)) if marshal == Marshal.POINT_LEFT
			else Quaternion(Vector3(0, 1, 0), deg_to_rad(-5))
			* Quaternion(Vector3(0, 0, 1), deg_to_rad(-5)) if marshal == Marshal.POINT_RIGHT
			else Quaternion(Vector3(0, 0, 1), deg_to_rad(0))
		)

		mesh_instance.mesh = add_mesh_surface.call(
			st,
			add_box.call(foot_dimensions, right_foot_position, right_foot_rotation),
			mesh_instance.mesh as ArrayMesh,
		)
		mesh_instance.mesh.surface_set_material(mesh_instance.mesh.get_surface_count() - 1, mat)
		mesh_instance.mesh = add_mesh_surface.call(
			st,
			add_box.call(foot_dimensions, left_foot_position, left_foot_rotation),
			mesh_instance.mesh as ArrayMesh,
		)
		mesh_instance.mesh.surface_set_material(mesh_instance.mesh.get_surface_count() - 1, mat)
		mesh_instance.mesh = add_mesh_surface.call(
			st,
			add_box.call(leg_dimensions, right_leg_position, right_leg_rotation),
			mesh_instance.mesh as ArrayMesh,
		)
		mesh_instance.mesh.surface_set_material(mesh_instance.mesh.get_surface_count() - 1, mat)
		mesh_instance.mesh = add_mesh_surface.call(
			st,
			add_box.call(leg_dimensions, left_leg_position, left_leg_rotation),
			mesh_instance.mesh as ArrayMesh,
		)
		mesh_instance.mesh.surface_set_material(mesh_instance.mesh.get_surface_count() - 1, mat)
		mesh_instance.mesh = add_mesh_surface.call(
			st,
			add_box.call(torso_dimensions, torso_position, torso_rotation),
			mesh_instance.mesh as ArrayMesh,
		)
		mesh_instance.mesh.surface_set_material(mesh_instance.mesh.get_surface_count() - 1, mat)
		mesh_instance.mesh = add_mesh_surface.call(
			st,
			add_box.call(arm_dimensions, right_arm_position, right_arm_rotation),
			mesh_instance.mesh as ArrayMesh,
		)
		mesh_instance.mesh.surface_set_material(mesh_instance.mesh.get_surface_count() - 1, mat)
		mesh_instance.mesh = add_mesh_surface.call(
			st,
			add_box.call(arm_dimensions, left_arm_position, left_arm_rotation),
			mesh_instance.mesh as ArrayMesh,
		)
		mesh_instance.mesh.surface_set_material(mesh_instance.mesh.get_surface_count() - 1, mat)
		mesh_instance.mesh = add_mesh_surface.call(
			st,
			add_box.call(head_dimensions, head_position, head_rotation),
			mesh_instance.mesh as ArrayMesh,
		)
		mesh_instance.mesh.surface_set_material(mesh_instance.mesh.get_surface_count() - 1, mat)
	return mesh_instance
