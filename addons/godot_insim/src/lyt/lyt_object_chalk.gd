class_name LYTObjectChalk
extends LYTObject

## LYT control object
##
## Specific layout object representing a chalk line.

enum ChalkColor {
	WHITE,
	RED,
	BLUE,
	YELLOW,
}

const COLORS: Array[Color] = [
	Color.WHITE,
	Color.RED,
	Color.ROYAL_BLUE,
	Color.YELLOW,
]

var color := ChalkColor.WHITE


static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectChalk:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var chalk_object := LYTObjectChalk.new()
	chalk_object.set_from_buffer(object.get_buffer())
	chalk_object.color = object.flags & 0b11 as ChalkColor
	return chalk_object


func _get_mesh() -> MeshInstance3D:
	if index >= InSim.AXOIndex.AXO_CHALK_AHEAD:
		return get_mesh_arrow(index, COLORS[color])
	var width := 8.0 if index == InSim.AXOIndex.AXO_CHALK_LINE else 0.2
	var length := 0.25 if index == InSim.AXOIndex.AXO_CHALK_LINE else 4.8
	var vertices := PackedVector3Array([
		Vector3(-0.5 * width, -0.5 * length, MARKING_ALTITUDE),
		Vector3(0.5 * width, -0.5 * length, MARKING_ALTITUDE),
		Vector3(-0.5 * width, 0.5 * length, MARKING_ALTITUDE),
		Vector3(0.5 * width, 0.5 * length, MARKING_ALTITUDE),
	])
	var indices := PackedInt32Array([
		2, 1, 0,
		1, 2, 3,
	])
	if index == InSim.AXOIndex.AXO_CHALK_LINE:
		for i in 2:
			var offset := 3.9 * (1 if i == 0 else -1)
			vertices.append_array([
				Vector3(offset - 0.1, -0.45, MARKING_ALTITUDE),
				Vector3(offset + 0.1, -0.45, MARKING_ALTITUDE),
				Vector3(offset - 0.1, 0.45, MARKING_ALTITUDE),
				Vector3(offset + 0.1, 0.45, MARKING_ALTITUDE),
			])
			var first_index := vertices.size() - 4
			indices.append_array([
				first_index + 2, first_index + 1, first_index + 0,
				first_index + 1, first_index + 2, first_index + 3,
			])
	var arrays := []
	var _resize := arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = COLORS[color]
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func _update_flags() -> void:
	flags = (flags & ~0b11) | color
