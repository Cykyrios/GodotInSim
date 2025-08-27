class_name LYTObjectTyre
extends LYTObject
## LYT tyre object
##
## Specific layout object representing a tyre or tyre stack.

## Tyre colors
enum TyreColor {
	BLACK,
	WHITE,
	RED,
	BLUE,
	GREEN,
	YELLOW,
}

## Tyre colors
const COLORS: Array[Color] = [
	Color(0.2, 0.2, 0.2),
	Color.LIGHT_GRAY,
	Color(0.7, 0.25, 0.15),
	Color.ROYAL_BLUE,
	Color.SEA_GREEN,
	Color.GOLDENROD,
]

var color := TyreColor.BLACK  ## Tyre color


func _apply_flags() -> void:
	color = flags & 0b111 as TyreColor


func _get_mesh() -> MeshInstance3D:
	const LOOPS := 4  # number of circles defining a tyre's shape
	const SEGMENTS := 12
	const CHAMFER := 0.07  # diameter ratio
	var stack_height := (
		1 if index in [InSim.AXOIndex.AXO_TYRE_SINGLE, InSim.AXOIndex.AXO_TYRE_SINGLE_BIG]
		else 2 if index in [InSim.AXOIndex.AXO_TYRE_STACK2, InSim.AXOIndex.AXO_TYRE_STACK2_BIG]
		else 3 if index in [InSim.AXOIndex.AXO_TYRE_STACK3, InSim.AXOIndex.AXO_TYRE_STACK3_BIG]
		else 4
	)
	var radius_max := 0.33 if index <= InSim.AXOIndex.AXO_TYRE_STACK4 else 0.44
	var radius_min := radius_max * (1 - CHAMFER)
	var tyre_width := 0.2 if index <= InSim.AXOIndex.AXO_TYRE_STACK4 else 0.27
	var vertices := PackedVector3Array([
		Vector3(0, 0, 0),
		Vector3(0, 0, stack_height * tyre_width),
	])
	for h in stack_height:
		for l in LOOPS:
			var radius := radius_max if l in [1, 2] else radius_min
			var chamfer_height := radius_max * CHAMFER
			var loop_height := (
				0.0 if l == 0
				else chamfer_height if l == 1
				else (tyre_width - chamfer_height) if l == 2
				else tyre_width
			)
			for i in SEGMENTS:
				var _discard := vertices.push_back(Vector3(
					radius * (1 - CHAMFER) * cos(2 * PI * i / SEGMENTS),
					radius * (1 - CHAMFER) * sin(2 * PI * i / SEGMENTS),
					tyre_width * h + loop_height,
				))
	var indices := PackedInt32Array()
	var smooth_groups: Array[Vector2i] = [Vector2i(0, 0)]  # index + group
	for i in SEGMENTS:
		var _discard := indices.push_back(0)
		_discard = indices.push_back(1 + i + (SEGMENTS if i == 0 else 0))
		_discard = indices.push_back(2 + i)
	for h in stack_height:
		var h_offset := h * LOOPS * SEGMENTS
		for l in 3:
			smooth_groups.append(Vector2i(
				indices.size(),
				1 if smooth_groups[-1].y == 0 else 0
			))
			var l_offset := l * SEGMENTS
			for i in SEGMENTS:
				var offset := 2 + h_offset + l_offset
				var last_offset := SEGMENTS if i == SEGMENTS - 1 else 0
				var _discard := indices.push_back(offset + i)
				_discard = indices.push_back(offset + SEGMENTS + i)
				_discard = indices.push_back(offset + i + 1 - last_offset)
				_discard = indices.push_back(offset + i + 1 - last_offset)
				_discard = indices.push_back(offset + SEGMENTS + i)
				_discard = indices.push_back(offset + SEGMENTS + i + 1 - last_offset)
	var vertex_count := vertices.size()
	smooth_groups.append(Vector2i(
		indices.size(),
		1 if smooth_groups[-1].y == 0 else 0
	))
	for i in SEGMENTS:
		var _discard := indices.push_back(1)
		_discard = indices.push_back(vertex_count - 1 - i)
		_discard = indices.push_back(
			vertex_count - 2 - i + (SEGMENTS if i == (SEGMENTS - 1) else 0)
		)
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(0)
	var s := 0
	for i in indices.size():
		if s < smooth_groups.size() and i == smooth_groups[s].x:
			st.set_smooth_group(smooth_groups[s].y)
			s += 1
		st.add_vertex(vertices[indices[i]])
	st.generate_normals()
	var mesh := st.commit()
	var mat := generate_default_material()
	mat.albedo_color = COLORS[color]
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func _update_flags() -> void:
	flags = (flags & ~0b111) | color
