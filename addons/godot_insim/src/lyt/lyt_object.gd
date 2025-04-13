class_name LYTObject
extends RefCounted

## LYT object
##
## This class describes a layout object, as included in a layout (LYT) file.

const STRUCT_SIZE := 8

const XY_MULTIPLIER := 16.0
const Z_MULTIPLIER := 4.0
const HEADING_MULTIPLIER := 256 / 360.0

const MARKING_ALTITUDE := 0.01
const CONTROL_ALTITUDE := 0.2

var x := 0
var y := 0
var z := 0
var flags := 0
var index := InSim.AXOIndex.AXO_NULL
var heading := 0

var gis_position := Vector3.ZERO
var gis_heading := 0.0


## Creates and returns a [LYTObject] based on the given parameters.
static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObject:
	var object := LYTObject.new()
	object.x = obj_x
	object.y = obj_y
	object.z = obj_z
	object.flags = obj_flags
	object.index = obj_index as InSim.AXOIndex
	object.heading = obj_heading
	object.update_gis_values()
	return object


## Creates and returns a [LYTObject] based on the given parameters, using [code]gis_*[/code]
## values where possible.
static func create_from_gis(
	obj_position: Vector3, obj_heading: float, obj_flags: int, obj_index: int
) -> LYTObject:
	var object: LYTObject = LYTObject.new()
	object.gis_position = obj_position
	object.gis_heading = obj_heading
	object.flags = obj_flags
	object.index = obj_index as InSim.AXOIndex
	object.set_from_gis_values()
	return object


## Returns a [LYTObject] from the provided [param buffer]. Returns a blank object if [param buffer]
## is the wrong size.
static func create_from_buffer(buffer: PackedByteArray) -> LYTObject:
	if buffer.size() != STRUCT_SIZE:
		push_warning("Buffer size does not match LYTObject struct size.")
		return LYTObject.new()
	var object := LYTObject.new()
	object.set_from_buffer(buffer)
	return object


## Override to return a [MeshInstance3D] corresponding to the object. Returns an
## elongated cube by default.
func _get_mesh() -> MeshInstance3D:
	var color := Color.GRAY
	var dimensions := Vector3(0.5, 0.5, 1)
	var offset := Vector3.ZERO  # offsets whole mesh
	var taper_top := Vector2.ONE  # 0 to 1, scales top face
	var shift_top_y := 0.0  # offset for top face along Y axis
	match index:
		InSim.AXOIndex.AXO_CONE_RED, InSim.AXOIndex.AXO_CONE_RED2, InSim.AXOIndex.AXO_CONE_RED3, \
		InSim.AXOIndex.AXO_CONE_BLUE, InSim.AXOIndex.AXO_CONE_BLUE2, \
		InSim.AXOIndex.AXO_CONE_GREEN, InSim.AXOIndex.AXO_CONE_GREEN2, \
		InSim.AXOIndex.AXO_CONE_ORANGE, InSim.AXOIndex.AXO_CONE_WHITE, \
		InSim.AXOIndex.AXO_CONE_YELLOW, InSim.AXOIndex.AXO_CONE_YELLOW2, \
		InSim.AXOIndex.AXO_CONE_PTR_RED, InSim.AXOIndex.AXO_CONE_PTR_BLUE, \
		InSim.AXOIndex.AXO_CONE_PTR_GREEN, InSim.AXOIndex.AXO_CONE_PTR_YELLOW:
			return get_mesh_cone()
		InSim.AXOIndex.AXO_MARKER_CURVE_L, InSim.AXOIndex.AXO_MARKER_CURVE_R, \
		InSim.AXOIndex.AXO_MARKER_L, InSim.AXOIndex.AXO_MARKER_R, \
		InSim.AXOIndex.AXO_MARKER_HARD_L, InSim.AXOIndex.AXO_MARKER_HARD_R, \
		InSim.AXOIndex.AXO_MARKER_L_R, InSim.AXOIndex.AXO_MARKER_R_L, \
		InSim.AXOIndex.AXO_MARKER_S_L, InSim.AXOIndex.AXO_MARKER_S_R, \
		InSim.AXOIndex.AXO_MARKER_S2_L, InSim.AXOIndex.AXO_MARKER_S2_R, \
		InSim.AXOIndex.AXO_MARKER_U_L, InSim.AXOIndex.AXO_MARKER_U_R, \
		InSim.AXOIndex.AXO_DIST25, InSim.AXOIndex.AXO_DIST50, \
		InSim.AXOIndex.AXO_DIST75, InSim.AXOIndex.AXO_DIST100, \
		InSim.AXOIndex.AXO_DIST125, InSim.AXOIndex.AXO_DIST150, \
		InSim.AXOIndex.AXO_DIST200, InSim.AXOIndex.AXO_DIST250:
			return get_mesh_marker()
		InSim.AXOIndex.AXO_ARMCO1, InSim.AXOIndex.AXO_ARMCO3, InSim.AXOIndex.AXO_ARMCO5:
			return get_mesh_armco()
		InSim.AXOIndex.AXO_BARRIER_LONG, InSim.AXOIndex.AXO_BARRIER_RED, \
		InSim.AXOIndex.AXO_BARRIER_WHITE:
			return get_mesh_barrier()
		InSim.AXOIndex.AXO_BANNER1, InSim.AXOIndex.AXO_BANNER2:
			return get_mesh_banner()
		InSim.AXOIndex.AXO_RAMP1, InSim.AXOIndex.AXO_RAMP2:
			return get_mesh_ramp()
		InSim.AXOIndex.AXO_SPEED_HUMP_10M, InSim.AXOIndex.AXO_SPEED_HUMP_6M:
			return get_mesh_speed_hump()
		InSim.AXOIndex.AXO_POST_GREEN, InSim.AXOIndex.AXO_POST_ORANGE, \
		InSim.AXOIndex.AXO_POST_RED, InSim.AXOIndex.AXO_POST_WHITE:
			return get_mesh_post()
		InSim.AXOIndex.AXO_BALE:
			dimensions = Vector3(1.52, 0.7, 0.63)
			offset = Vector3(0, -0.35, 0)
			color = Color.BURLYWOOD
		InSim.AXOIndex.AXO_RAILING:
			return get_mesh_railing()
		InSim.AXOIndex.AXO_START_LIGHTS:
			dimensions = Vector3(0.5, 0.7, 2)
			color = Color.GOLD
		InSim.AXOIndex.AXO_SIGN_KEEP_LEFT, InSim.AXOIndex.AXO_SIGN_KEEP_RIGHT:
			dimensions = Vector3(0.8, 0.65, 1.1)
			offset = Vector3(0, -0.325, 0)
			taper_top = Vector2(1, 0.1)
			shift_top_y = -0.05
			color = Color.ROYAL_BLUE
		InSim.AXOIndex.AXO_SIGN_SPEED_80, InSim.AXOIndex.AXO_SIGN_SPEED_50:
			return get_mesh_sign_speed()
		InSim.AXOIndex.AXO_START_POSITION:
			return get_mesh_start_position()
		InSim.AXOIndex.AXO_PIT_START_POINT:
			return get_mesh_arrow(index, Color.WHITE)
		InSim.AXOIndex.AXO_PIT_STOP_BOX:
			return get_mesh_pit_box()
	var vertices := PackedVector3Array([
		offset + Vector3(-0.5 * dimensions.x, -0.5 * dimensions.y, 0),
		offset + Vector3(0.5 * dimensions.x, -0.5 * dimensions.y, 0),
		offset + Vector3(-0.5 * dimensions.x, 0.5 * dimensions.y, 0),
		offset + Vector3(0.5 * dimensions.x, 0.5 * dimensions.y, 0),
		offset + Vector3(
			-0.5 * dimensions.x * taper_top.x,
			-0.5 * dimensions.y * taper_top.y + shift_top_y,
			dimensions.z
		),
		offset + Vector3(
			0.5 * dimensions.x * taper_top.x,
			-0.5 * dimensions.y * taper_top.y + shift_top_y,
			dimensions.z
		),
		offset + Vector3(
			-0.5 * dimensions.x * taper_top.x,
			0.5 * dimensions.y * taper_top.y + shift_top_y,
			dimensions.z
		),
		offset + Vector3(
			0.5 * dimensions.x * taper_top.x,
			0.5 * dimensions.y * taper_top.y + shift_top_y,
			dimensions.z
		),
	])
	var indices := PackedInt32Array([
		0, 1, 2,  # Z- face
		3, 2, 1,
		6, 5, 4,  # Z+ face
		5, 6, 7,
		4, 1, 0,  # Y- face
		1, 4, 5,
		2, 3, 6,  # Y+ face
		7, 6, 3,
		0, 2, 4,  # X- face
		6, 4, 2,
		5, 3, 1,  # X+ face
		3, 5, 7,
	])
	var arrays := []
	var _resize := arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	var mat := generate_default_material()
	mat.albedo_color = color
	mesh.surface_set_material(0, mat)
	return mesh_instance


## Override this function to update the value of [member flags] based on the object-specific
## variables.
func _update_flags() -> void:
	pass


## Override this function to define the behavior corresponding to the [LYTObject].
## Object flags have different meanings depending on the object type.[br]
## [u]Note:[/u] Updating [code]gis_*[/code] variables from LFS-style flags is not necessary
## as those get updated via the original variables' setter functions.
func _update_flags_from_gis() -> void:
	pass


## Generates and returns a [StandardMaterial3D] as a default [LYTObject] material.
func generate_default_material() -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color.WEB_GRAY
	return mat


## Returns the object's complete data buffer.
func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _resize := buffer.resize(STRUCT_SIZE)
	buffer.encode_s16(0, x)
	buffer.encode_s16(2, y)
	buffer.encode_u8(4, z)
	buffer.encode_u8(5, flags)
	buffer.encode_u8(6, index)
	buffer.encode_u8(7, heading)
	return buffer


## Returns the object's 3D mesh as a [MeshInstance3D]. Define the mesh via [method _get_mesh].
func get_mesh() -> MeshInstance3D:
	return _get_mesh()


func get_mesh_armco() -> MeshInstance3D:
	const SPAN := 3.2
	const TIP_RADIUS := 0.15
	const TIP_OFFSET := 0.15
	const HEIGHT := 0.65
	const RAILING_HEIGHT := 0.3
	var spans := 1 + 2 * (index - InSim.AXOIndex.AXO_ARMCO1)
	var vertices := PackedVector3Array()
	var indices := PackedInt32Array()
	var support_vertices := PackedVector3Array([
		Vector3(-0.057, 0, 0),
		Vector3(0.057, 0, 0),
		Vector3(-0.057, 0, HEIGHT),
		Vector3(0.057, 0, HEIGHT),
		Vector3(-0.057, -0.04, 0),
		Vector3(-0.057, 0.04, 0),
		Vector3(-0.057, -0.04, HEIGHT),
		Vector3(-0.057, 0.04, HEIGHT),
		Vector3(0.057, -0.04, 0),
		Vector3(0.057, 0.04, 0),
		Vector3(0.057, -0.04, HEIGHT),
		Vector3(0.057, 0.04, HEIGHT),
	])
	var support_indices := PackedInt32Array([
		0, 1, 2, 3, 2, 1,
		2, 1, 0, 1, 2, 3,
		4, 5, 6, 7, 6, 5,
		6, 5, 4, 5, 6, 7,
		8, 9, 10, 11, 10, 9,
		10, 9, 8, 9, 10, 11,
	])
	for s in spans + 1:
		var support_vertex_count := support_vertices.size()
		for v in support_vertex_count:
			support_vertices[v] = support_vertices[v] + Vector3(0, SPAN, 0) \
					- (Vector3.ZERO if s > 0 else Vector3(0, (1 + 0.5 * spans) * SPAN, 0))
		if s > 0:
			for i in support_indices.size():
				support_indices[i] = support_indices[i] + support_vertex_count
		vertices.append_array(support_vertices.duplicate())
		indices.append_array(support_indices.duplicate())
	var rail_tip := 0.5 * spans * SPAN + TIP_OFFSET
	var rail_base := HEIGHT - RAILING_HEIGHT
	var rail_inside := 0.07
	var rail_vertices := PackedVector3Array()
	for i in 2:
		var side := -1 if i == 0 else 1
		rail_vertices.append_array([
			Vector3(rail_inside, rail_tip * side, HEIGHT),
			Vector3(rail_inside, rail_tip * side, rail_base),
			Vector3(0.15, rail_tip * side, rail_base + 0.2 * RAILING_HEIGHT),
			Vector3(rail_inside, rail_tip * side, rail_base + 0.4 * RAILING_HEIGHT),
			Vector3(rail_inside, rail_tip * side, rail_base + 0.6 * RAILING_HEIGHT),
			Vector3(0.15, rail_tip * side, rail_base + 0.8 * RAILING_HEIGHT),
		])
	var rail_indices := PackedInt32Array([
		0, 1, 6, 7, 6, 1,
		1, 2, 7, 8, 7, 2,
		2, 3, 8, 9, 8, 3,
		3, 4, 9, 10, 9, 4,
		4, 5, 10, 11, 10, 5,
		6, 5, 0, 5, 6, 11,
	])
	for l in 2:
		if l == 1:
			for v in rail_vertices.size():
				rail_vertices[v] = rail_vertices[v].rotated(Vector3(0, 0, 1), PI)
		vertices.append_array(rail_vertices.duplicate())
		var offset := (vertices.size() - rail_vertices.size()) if l == 0 else rail_vertices.size()
		for i in rail_indices.size():
			rail_indices[i] = rail_indices[i] + offset
		indices.append_array(rail_indices.duplicate())
	var end_vertices := PackedVector3Array()
	var tip_offset := 0.5 * spans * SPAN + TIP_OFFSET
	end_vertices.append_array([
		Vector3(rail_inside, tip_offset, rail_base),
		Vector3(rail_inside, tip_offset, HEIGHT),
	])
	var tip_resolution := 6
	for i in tip_resolution:
		var angle := PI * i / (tip_resolution - 1)
		end_vertices.append_array([
			Vector3(TIP_RADIUS * cos(angle), TIP_RADIUS * sin(angle) + tip_offset, rail_base),
			Vector3(TIP_RADIUS * cos(angle), TIP_RADIUS * sin(angle) + tip_offset, HEIGHT),
		])
	end_vertices.append_array([
		Vector3(-rail_inside, tip_offset, rail_base),
		Vector3(-rail_inside, tip_offset, HEIGHT),
	])
	var end_indices := PackedInt32Array()
	for i in 7:
		var idx := 2 * i
		end_indices.append_array([
			idx + 0, idx + 1, idx + 2, idx + 3, idx + 2, idx + 1,
			idx + 2, idx + 1, idx + 0, idx + 1, idx + 2, idx + 3,
		])
	var smooth_groups: Array[Vector2i] = [Vector2i(0, -1)]
	for l in 2:
		if l == 1:
			for v in end_vertices.size():
				end_vertices[v] = end_vertices[v].rotated(Vector3(0, 0, 1), PI)
		vertices.append_array(end_vertices.duplicate())
		var offset := (vertices.size() - end_vertices.size()) if l == 0 else end_vertices.size()
		for i in end_indices.size():
			end_indices[i] = end_indices[i] + offset
		for i in 10:  # 5 segments per round tip, front face + back face
			smooth_groups.append(Vector2i(indices.size() + 12 + 6 * i, i % 2))
		indices.append_array(end_indices.duplicate())
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var s := 0
	for i in indices.size():
		if s < smooth_groups.size() and i == smooth_groups[s].x:
			st.set_smooth_group(smooth_groups[s].y)
			s += 1
		st.add_vertex(vertices[indices[i]])
	st.generate_normals()
	var mesh := st.commit()
	var mat := generate_default_material()
	mat.albedo_color = Color.WEB_GRAY
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_arrow(axo_index: InSim.AXOIndex, color: Color) -> MeshInstance3D:
	if (
		axo_index != InSim.AXOIndex.AXO_PIT_START_POINT
		and (
			axo_index < InSim.AXOIndex.AXO_CHALK_AHEAD
			or axo_index > InSim.AXOIndex.AXO_CHALK_RIGHT3
		)
	):
		return MeshInstance3D.new()
	var vertices := PackedVector3Array()
	match index:
		InSim.AXOIndex.AXO_PIT_START_POINT:
			vertices.append_array([
				Vector3(0, 1.5, MARKING_ALTITUDE),
				Vector3(-0.17, 0.35, MARKING_ALTITUDE),
				Vector3(0, 0.35, MARKING_ALTITUDE),
				Vector3(0.17, 0.35, MARKING_ALTITUDE),
				Vector3(-0.06, 0.35, MARKING_ALTITUDE),
				Vector3(0.06, 0.35, MARKING_ALTITUDE),
				Vector3(-0.08, -0.5, MARKING_ALTITUDE),
				Vector3(0.08, -0.5, MARKING_ALTITUDE),
				Vector3(-0.1, -1.5, MARKING_ALTITUDE),
				Vector3(0.1, -1.5, MARKING_ALTITUDE),
			])
		InSim.AXOIndex.AXO_CHALK_AHEAD:
			vertices.append_array([
				Vector3(0, 1, MARKING_ALTITUDE),
				Vector3(-0.35, 0.25, MARKING_ALTITUDE),
				Vector3(0, 0.45, MARKING_ALTITUDE),
				Vector3(0.35, 0.25, MARKING_ALTITUDE),
				Vector3(-0.06, 0.45, MARKING_ALTITUDE),
				Vector3(0.06, 0.45, MARKING_ALTITUDE),
				Vector3(-0.06, -0.5, MARKING_ALTITUDE),
				Vector3(0.06, -0.5, MARKING_ALTITUDE),
				Vector3(-0.06, -1, MARKING_ALTITUDE),
				Vector3(0.06, -1, MARKING_ALTITUDE),
			])
		InSim.AXOIndex.AXO_CHALK_AHEAD2:
			vertices.append_array([
				Vector3(0, 1.6, MARKING_ALTITUDE),
				Vector3(-0.35, 0.85, MARKING_ALTITUDE),
				Vector3(0, 1.05, MARKING_ALTITUDE),
				Vector3(0.35, 0.85, MARKING_ALTITUDE),
				Vector3(-0.06, 1.05, MARKING_ALTITUDE),
				Vector3(0.06, 1.05, MARKING_ALTITUDE),
				Vector3(-0.06, -0.1, MARKING_ALTITUDE),
				Vector3(0.06, -0.1, MARKING_ALTITUDE),
				Vector3(-0.1, -1.8, MARKING_ALTITUDE),
				Vector3(0.1, -1.8, MARKING_ALTITUDE),
			])
		InSim.AXOIndex.AXO_CHALK_LEFT, InSim.AXOIndex.AXO_CHALK_RIGHT:
			var sign_right := -1 if index == InSim.AXOIndex.AXO_CHALK_LEFT else 1
			vertices.append_array([
				Vector3(0, 0.5, MARKING_ALTITUDE),
				Vector3(-0.35, -0.1, MARKING_ALTITUDE),
				Vector3(0, 0, MARKING_ALTITUDE),
				Vector3(0.35, -0.1, MARKING_ALTITUDE),
				Vector3(-0.05, 0, MARKING_ALTITUDE),
				Vector3(0.05, 0, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.25 - 0.08, sign_right * 0.03, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.25 + 0.08, -sign_right * 0.03, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.25 - 0.12, -1.07, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.25 + 0.12, -1.07, MARKING_ALTITUDE),
			])
			for i in 6:
				vertices[i] = vertices[i].rotated(Vector3(0, 0, 1), -sign_right * PI / 4) \
						+ Vector3(sign_right * 0.05, 0.55, 0)
		InSim.AXOIndex.AXO_CHALK_LEFT2, InSim.AXOIndex.AXO_CHALK_RIGHT2:
			var sign_right := -1 if index == InSim.AXOIndex.AXO_CHALK_LEFT2 else 1
			vertices.append_array([
				Vector3(sign_right * 0.95, 0.55, MARKING_ALTITUDE),
				Vector3(sign_right * 0.25, 0.55 + sign_right * 0.4, MARKING_ALTITUDE),
				Vector3(sign_right * 0.25, 0.55, MARKING_ALTITUDE),
				Vector3(sign_right * 0.25, 0.55 - sign_right * 0.4, MARKING_ALTITUDE),
				Vector3(sign_right * 0.25, 0.55 + sign_right * 0.06, MARKING_ALTITUDE),
				Vector3(sign_right * 0.25, 0.55 - sign_right * 0.06, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.75 - 0.15, 0.55 + sign_right * 0.06, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.75 + 0.15, 0.55 - sign_right * 0.06, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.75 - 0.15, -1.07, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.75 + 0.15, -1.07, MARKING_ALTITUDE),
			])
		InSim.AXOIndex.AXO_CHALK_LEFT3, InSim.AXOIndex.AXO_CHALK_RIGHT3:
			var sign_right := -1 if index == InSim.AXOIndex.AXO_CHALK_LEFT3 else 1
			vertices.append_array([
				Vector3(0, 0.5, MARKING_ALTITUDE),
				Vector3(-0.4, -0.2, MARKING_ALTITUDE),
				Vector3(0, 0, MARKING_ALTITUDE),
				Vector3(0.4, -0.2, MARKING_ALTITUDE),
				Vector3(-0.05, 0, MARKING_ALTITUDE),
				Vector3(0.05, 0, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.25 - 0.08, sign_right * 0.03, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.25 + 0.08, -sign_right * 0.03, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.25 - 0.12, -1.8, MARKING_ALTITUDE),
				Vector3(-sign_right * 0.25 + 0.12, -1.8, MARKING_ALTITUDE),
			])
			for i in 6:
				vertices[i] = vertices[i].rotated(Vector3(0, 0, 1), -sign_right * PI / 8) \
						+ Vector3(sign_right * 0.1, 1.3, 0)
	var indices := PackedInt32Array()
	indices.append_array([
		2, 1, 0,
		3, 2, 0,
		4, 5, 6,
		7, 6, 5,
		6, 7, 8,
		9, 8, 7,
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
	mat.albedo_color = color
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_banner() -> MeshInstance3D:
	const WIDTH := 5.95
	const SPREAD := 0.85
	const HEIGHT := 1.0
	const THICKNESS := 0.09
	var angle := atan(HEIGHT / (0.5 * SPREAD))
	var bottom_offset := THICKNESS / cos(PI / 2 - angle)
	var top_offset := THICKNESS / sin(PI / 2 - angle)
	var vertices := PackedVector3Array([
		Vector3(-0.5 * WIDTH, -0.5 * SPREAD, 0),
		Vector3(0.5 * WIDTH, -0.5 * SPREAD, 0),
		Vector3(-0.5 * WIDTH, -0.5 * SPREAD + bottom_offset, 0),
		Vector3(0.5 * WIDTH, -0.5 * SPREAD + bottom_offset, 0),
		Vector3(-0.5 * WIDTH, 0, HEIGHT),
		Vector3(0.5 * WIDTH, 0, HEIGHT),
		Vector3(-0.5 * WIDTH, 0, HEIGHT - top_offset),
		Vector3(0.5 * WIDTH, 0, HEIGHT - top_offset),
		Vector3(-0.5 * WIDTH, 0.5 * SPREAD, 0),
		Vector3(0.5 * WIDTH, 0.5 * SPREAD, 0),
		Vector3(-0.5 * WIDTH, 0.5 * SPREAD - bottom_offset, 0),
		Vector3(0.5 * WIDTH, 0.5 * SPREAD - bottom_offset, 0),
	])
	var indices := PackedInt32Array([
		4, 1, 0, 1, 4, 5,
		4, 8, 9, 9, 5, 4,
		8, 10, 11, 11, 9, 8,
		11, 10, 6, 6, 7, 11,
		2, 3, 6, 7, 6, 3,
		0, 1, 2, 3, 2, 1,
		0, 2, 6, 6, 4, 0,
		10, 8, 6, 4, 6, 8,
		7, 3, 1, 1, 5, 7,
		7, 9, 11, 9, 7, 5,
	])
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	for i in vertices.size():
		st.add_vertex(vertices[i])
	for idx in indices:
		st.add_index(idx)
	st.generate_normals()
	var mesh := st.commit()
	var mat := generate_default_material()
	mat.albedo_color = Color.LIGHT_GRAY if index == InSim.AXOIndex.AXO_BANNER1 else Color.DIM_GRAY
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_barrier() -> MeshInstance3D:
	const LENGTH := 1.38
	const BASE_WIDTH := 0.35
	const TOP_WIDTH := 0.15
	const HEIGHT := 0.8
	const BASE_HEIGHT := 0.15
	const TOP_HEIGHT := 0.17
	const SECTION_VERTICES := 8
	var barrier_colors: Array[Color] = [Color.RED.darkened(0.2), Color.WHITE]
	var sections := 1 if index != InSim.AXOIndex.AXO_BARRIER_LONG else 6
	var offset := 0.0 if index != InSim.AXOIndex.AXO_BARRIER_LONG else -LENGTH * (sections * 0.5)
	var first_color_idx := 0 if index != InSim.AXOIndex.AXO_BARRIER_WHITE else 1
	var vertices := PackedVector3Array()
	var colors := PackedColorArray()
	var _discard: Variant = null
	for s in sections:
		for i in 2:
			vertices.append_array([
				Vector3(-0.5 * BASE_WIDTH, (s - 0.5 + i) * LENGTH + offset, 0),
				Vector3(0.5 * BASE_WIDTH, (s - 0.5 + i) * LENGTH + offset, 0),
				Vector3(-0.5 * BASE_WIDTH, (s - 0.5 + i) * LENGTH + offset, BASE_HEIGHT),
				Vector3(0.5 * BASE_WIDTH, (s - 0.5 + i) * LENGTH + offset, BASE_HEIGHT),
				Vector3(-0.5 * TOP_WIDTH, (s - 0.5 + i) * LENGTH + offset, HEIGHT - TOP_HEIGHT),
				Vector3(0.5 * TOP_WIDTH, (s - 0.5 + i) * LENGTH + offset, HEIGHT - TOP_HEIGHT),
				Vector3(-0.43 * TOP_WIDTH, (s - 0.5 + i) * LENGTH + offset, HEIGHT),
				Vector3(0.43 * TOP_WIDTH, (s - 0.5 + i) * LENGTH + offset, HEIGHT),
			])
			for v in SECTION_VERTICES:
				_discard = colors.push_back(barrier_colors[(first_color_idx + s) % 2])
	var indices := PackedInt32Array([
		2, 1, 0, 1, 2, 3,
		4, 3, 2, 3, 4, 5,
		6, 5, 4, 5, 6, 7,
	])
	for s in sections:
		var face := 2 * s * SECTION_VERTICES
		indices.append_array([
			face, face + SECTION_VERTICES, face + SECTION_VERTICES + 2,
			face, face + SECTION_VERTICES + 2, face + 2,
			face + 2, face + SECTION_VERTICES + 2, face + SECTION_VERTICES + 4,
			face + 2, face + SECTION_VERTICES + 4, face + 4,
			face + 4, face + SECTION_VERTICES + 4, face + SECTION_VERTICES + 6,
			face + 4, face + SECTION_VERTICES + 6, face + 6,
			face + 6, face + SECTION_VERTICES + 6, face + SECTION_VERTICES + 7,
			face + 6, face + SECTION_VERTICES + 7, face + 7,
			face + 7, face + SECTION_VERTICES + 7, face + SECTION_VERTICES + 5,
			face + 7, face + SECTION_VERTICES + 5, face + 5,
			face + 5, face + SECTION_VERTICES + 5, face + SECTION_VERTICES + 3,
			face + 5, face + SECTION_VERTICES + 3, face + 3,
			face + 3, face + SECTION_VERTICES + 3, face + SECTION_VERTICES + 1,
			face + 3, face + SECTION_VERTICES + 1, face + 1,
			face + 1, face + SECTION_VERTICES + 1, face + SECTION_VERTICES,
			face + 1, face + SECTION_VERTICES, face,
		])
	var last_face := vertices.size() - SECTION_VERTICES
	indices.append_array([
		last_face, last_face + 1, last_face + 2, last_face + 3, last_face + 2, last_face + 1,
		last_face + 2, last_face + 3, last_face + 4, last_face + 5, last_face + 4, last_face + 3,
		last_face + 4, last_face + 5, last_face + 6, last_face + 7, last_face + 6, last_face + 5,
	])
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	for i in vertices.size():
		if i == 0 or colors[i] != colors[i - 1]:
			st.set_color(colors[i])
		st.add_vertex(vertices[i])
	for idx in indices:
		st.add_index(idx)
	st.generate_normals()
	var mesh := st.commit()
	var mat := generate_default_material()
	mat.albedo_color = Color.WHITE
	mat.vertex_color_use_as_albedo = true
	mat.vertex_color_is_srgb = true
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_checkpoint(half_width: int) -> MeshInstance3D:
	var vertices := PackedVector3Array()
	for i in 2:
		var x_sign := -1 if i == 0 else 1
		var _discard: Variant = null
		_discard = vertices.push_back(Vector3(x_sign * (half_width - 0.5), 0, CONTROL_ALTITUDE))
		_discard = vertices.push_back(Vector3(x_sign * (half_width - 0.5), -0.5, CONTROL_ALTITUDE))
		_discard = vertices.push_back(Vector3(x_sign * half_width, -0.5, CONTROL_ALTITUDE))
		_discard = vertices.push_back(Vector3(x_sign * half_width, 0.5, CONTROL_ALTITUDE))
	var indices := PackedInt32Array()
	indices = PackedInt32Array([
		0, 1, 2,
		0, 2, 3,
		6, 5, 4,
		7, 6, 4,
		0, 3, 7,
		7, 4, 0,
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
	mat.albedo_color = Color.YELLOW
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_circle(radius: int) -> MeshInstance3D:
	const SEGMENTS := 32
	var vertices := PackedVector3Array()
	var _resize := vertices.resize(2 * SEGMENTS)
	for i in SEGMENTS:
		var angle := 2 * PI * i / SEGMENTS
		vertices[2 * i] = Vector3(
			radius * cos(angle),
			radius * sin(angle),
			CONTROL_ALTITUDE
		)
		vertices[2 * i + 1] = Vector3(
			(radius - 0.5) * cos(angle),
			(radius - 0.5) * sin(angle),
			CONTROL_ALTITUDE
		)
	# If diameter is zero, scale all points instead of removing the mesh altogether.
	if radius == 0:
		for i in vertices.size():
			vertices[i] = Vector3(0, 0, vertices[i].z)
	var indices := PackedInt32Array()
	for i in SEGMENTS:
		indices.append_array([2 * i, 2 * i + 1, 2 * i + 2])
		indices.append_array([2 * i + 3, 2 * i + 2, 2 * i + 1])
	var vertex_count := vertices.size()
	for i in indices.size():
		indices[i] = wrapi(indices[i], 0, vertex_count)
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
	mat.albedo_color = Color.YELLOW
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_cone() -> MeshInstance3D:
	const SEGMENTS := 8
	const CHAMFER := 0.02
	const THICKNESS := 0.04
	const HEIGHT := 0.66
	const TIP_HEIGHT := 0.025
	const RADIUS_TOP := 0.035
	var radius_base := 0.12 if index == InSim.AXOIndex.AXO_CONE_RED \
			else 0.15 if (
				index == InSim.AXOIndex.AXO_CONE_RED3 or index >= InSim.AXOIndex.AXO_CONE_PTR_RED
			) else 0.13
	var base_width := 0.38 if index == InSim.AXOIndex.AXO_CONE_RED \
			else 0.46 if (
				index == InSim.AXOIndex.AXO_CONE_RED3 or index >= InSim.AXOIndex.AXO_CONE_PTR_RED
			) else 0.4
	var base_low := 0.5 * base_width
	var base_high := 0.5 * base_width - CHAMFER
	var vertices := PackedVector3Array([
		Vector3(-base_low, -base_low, 0),
		Vector3(base_low, -base_low, 0),
		Vector3(-base_low, base_low, 0),
		Vector3(base_low, base_low, 0),
		Vector3(-base_high, -base_high, THICKNESS),
		Vector3(base_high, -base_high, THICKNESS),
		Vector3(-base_high, base_high, THICKNESS),
		Vector3(base_high, base_high, THICKNESS),
	])
	var base_vertices := vertices.size()
	var _discard: Variant = null
	for r in 2:
		var radius := radius_base if r == 0 else RADIUS_TOP
		var ring_height := (1.5 * THICKNESS) if r == 0 else HEIGHT - TIP_HEIGHT
		for i in SEGMENTS:
			var angle := 2 * PI * i / SEGMENTS
			_discard = vertices.push_back(Vector3(
				radius * cos(angle),
				radius * sin(angle),
				ring_height
			))
	_discard = vertices.push_back(Vector3(0, 0, HEIGHT))
	if index >= InSim.AXOIndex.AXO_CONE_PTR_RED:
		for i in vertices.size():
			vertices[i] = vertices[i].rotated(Vector3(1, 0, 0), deg_to_rad(106.5)) \
					+ Vector3(0, 0.27, 0.2)
	var indices := PackedInt32Array([
		0, 1, 2, 3, 2, 1,
		4, 1, 0, 1, 4, 5,
		5, 3, 1, 3, 5, 7,
		2, 3, 7, 7, 6, 2,
		0, 2, 6, 6, 4, 0,
		4, 13, 14, 14, 5, 4, 5, 14, 15,
		15, 8, 5, 8, 7, 5, 7, 8, 9,
		7, 9, 10, 6, 7, 10, 6, 10, 11,
		6, 11, 12, 4, 6, 12, 4, 12, 13,
	])
	var smooth_groups: Array[Vector2i] = [
		Vector2i(0, 0),
		Vector2i(6 * 1, 1),
		Vector2i(6 * 2, 2),
		Vector2i(6 * 3, 3),
		Vector2i(6 * 4, 4),
		Vector2i(6 * 5, 0),
		Vector2i(indices.size(), 1),
	]
	for i in SEGMENTS:
		var offset := base_vertices + i
		if i < SEGMENTS - 1:
			indices.append_array([offset + SEGMENTS, offset + 1, offset])
			indices.append_array([offset + 1, offset + SEGMENTS, offset + SEGMENTS + 1])
		else:
			indices.append_array([
				offset + SEGMENTS,
				offset + 1 - SEGMENTS,
				offset,
			])
			indices.append_array([
				offset + 1 - SEGMENTS,
				offset + SEGMENTS,
				offset + 1,
			])
	smooth_groups.append(Vector2i(indices.size(), 0))
	var vertex_count := vertices.size()
	for i in SEGMENTS:
		var offset := vertex_count - 1 - SEGMENTS + i
		if i < SEGMENTS - 1:
			indices.append_array([vertex_count - 1, offset + 1, offset])
		else:
			indices.append_array([
				vertex_count - 1,
				offset + 1 - SEGMENTS,
				offset,
			])
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var s := 0
	for i in indices.size():
		if s < smooth_groups.size() and i == smooth_groups[s].x:
			st.set_smooth_group(smooth_groups[s].y)
			s += 1
		st.add_vertex(vertices[indices[i]])
	st.generate_normals()
	var mesh := st.commit()
	var color := Color.BLACK
	match index:
		InSim.AXOIndex.AXO_CONE_RED:
			color = Color.RED
		InSim.AXOIndex.AXO_CONE_RED2:
			color = Color.ORANGE_RED
		InSim.AXOIndex.AXO_CONE_RED3:
			color = Color.INDIAN_RED
		InSim.AXOIndex.AXO_CONE_BLUE:
			color = Color.BLUE
		InSim.AXOIndex.AXO_CONE_BLUE2:
			color = Color.DEEP_SKY_BLUE
		InSim.AXOIndex.AXO_CONE_GREEN:
			color = Color.FOREST_GREEN
		InSim.AXOIndex.AXO_CONE_GREEN2:
			color = Color.GREEN
		InSim.AXOIndex.AXO_CONE_ORANGE:
			color = Color.ORANGE
		InSim.AXOIndex.AXO_CONE_WHITE:
			color = Color.WHITE
		InSim.AXOIndex.AXO_CONE_YELLOW:
			color = Color.YELLOW
		InSim.AXOIndex.AXO_CONE_YELLOW2:
			color = Color.GOLD
		InSim.AXOIndex.AXO_CONE_PTR_RED:
			color = Color.RED
		InSim.AXOIndex.AXO_CONE_PTR_BLUE:
			color = Color.SKY_BLUE
		InSim.AXOIndex.AXO_CONE_PTR_GREEN:
			color = Color.GREEN
		InSim.AXOIndex.AXO_CONE_PTR_YELLOW:
			color = Color.GOLD
	var mat := generate_default_material()
	mat.albedo_color = color
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_marker() -> MeshInstance3D:
	const WIDTH := 1.42
	const BASE_THICKNESS := 0.39
	const TOP_THICKNESS := 0.15
	const BASE_OFFSET := -0.025
	const TOP_OFFSET := -0.015
	const HEIGHT := 1.01
	var vertices_base := PackedVector3Array([
		Vector3(-0.5 * WIDTH, -0.5 * BASE_THICKNESS + BASE_OFFSET, 0),
		Vector3(0.5 * WIDTH, -0.5 * BASE_THICKNESS + BASE_OFFSET, 0),
		Vector3(-0.5 * WIDTH, 0.5 * BASE_THICKNESS + BASE_OFFSET, 0),
		Vector3(0.5 * WIDTH, 0.5 * BASE_THICKNESS + BASE_OFFSET, 0),
		Vector3(-0.5 * WIDTH, -0.5 * TOP_THICKNESS + TOP_OFFSET, HEIGHT),
		Vector3(0.5 * WIDTH, -0.5 * TOP_THICKNESS + TOP_OFFSET, HEIGHT),
		Vector3(-0.5 * WIDTH, 0.5 * TOP_THICKNESS + TOP_OFFSET, HEIGHT),
		Vector3(0.5 * WIDTH, 0.5 * TOP_THICKNESS + TOP_OFFSET, HEIGHT),
	])
	var _discard: Variant = null
	var indices_base := PackedInt32Array([
		0, 1, 2, 3, 2, 1,  # Z- face
		6, 5, 4, 5, 6, 7,  # Z+ face
		4, 1, 0, 1, 4, 5,  # Y- face
		2, 3, 6, 7, 6, 3,  # Y+ face
		0, 2, 4, 6, 4, 2,  # X- face
		5, 3, 1, 3, 5, 7,  # X+ face
	])
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	var base_color := Color.BURLYWOOD.lightened(0.2)
	st.set_color(base_color)
	for i in indices_base.size():
		if i == 18:
			st.set_color(Color.WHITE)
		if i == 24:
			st.set_color(base_color)
		st.add_vertex(vertices_base[indices_base[i]])
	st.generate_normals()
	var mesh := st.commit()
	var mat := generate_default_material()
	mat.vertex_color_use_as_albedo = true
	mat.vertex_color_is_srgb = true
	mat.albedo_color = Color.WHITE
	mesh.surface_set_material(0, mat)

	var arrow_vertices := PackedVector3Array([
		Vector3(-0.25, 0, 0),
		Vector3(0.25, 0, 0),
		Vector3(0, 0, 0.25),
		Vector3(-0.1, 0, 0),  # end of arrow line
		Vector3(0.1, 0, 0),
	])
	var arrow_indices := PackedInt32Array([
		0, 2, 1,
	])
	# Arrow line definition, assuming left turn for all variations
	# Horizontal flip for right turns and fixing indices happens later
	match index:
		InSim.AXOIndex.AXO_MARKER_CURVE_L, InSim.AXOIndex.AXO_MARKER_CURVE_R:
			for v in arrow_vertices.size():
				arrow_vertices[v] = arrow_vertices[v].rotated(Vector3(0, 1, 0), -PI / 3) \
						+ Vector3(-0.2, 0, 0.2)
			arrow_vertices.append_array([
				Vector3(0, 0, -0.1),
				Vector3(0.2, 0, 0.05),
				Vector3(0, 0, -0.45),
				Vector3(0.2, 0, -0.45),
			])
		InSim.AXOIndex.AXO_MARKER_L, InSim.AXOIndex.AXO_MARKER_R:
			for v in arrow_vertices.size():
				arrow_vertices[v] = arrow_vertices[v].rotated(Vector3(0, 1, 0), -PI / 2) \
						+ Vector3(-0.25, 0, 0.2)
			arrow_vertices.append_array([
				Vector3(0.2, 0, 0.1),
				Vector3(0.4, 0, 0.3),
				Vector3(0.2, 0, -0.4),
				Vector3(0.4, 0, -0.4),
			])
		InSim.AXOIndex.AXO_MARKER_HARD_L, InSim.AXOIndex.AXO_MARKER_HARD_R:
			for v in arrow_vertices.size():
				arrow_vertices[v] = arrow_vertices[v].rotated(Vector3(0, 1, 0), -PI * 3 / 4) \
						+ Vector3(-0.15, 0, 0)
			arrow_vertices.append_array([
				Vector3(0.1, 0, 0.05),
				Vector3(0.3, 0, 0.45),
				Vector3(0.1, 0, -0.4),
				Vector3(0.3, 0, -0.4),
			])
		InSim.AXOIndex.AXO_MARKER_L_R, InSim.AXOIndex.AXO_MARKER_R_L:
			for v in arrow_vertices.size():
				arrow_vertices[v] = arrow_vertices[v] + Vector3(-0.25, 0, 0.2)
			arrow_vertices.append_array([
				Vector3(-0.35, 0, -0.1),
				Vector3(-0.15, 0, 0.1),
				Vector3(0.1, 0, -0.1),
				Vector3(0.3, 0, 0.1),
				Vector3(0.1, 0, -0.4),
				Vector3(0.3, 0, -0.4),
			])
		InSim.AXOIndex.AXO_MARKER_S_L, InSim.AXOIndex.AXO_MARKER_S_R:
			for v in arrow_vertices.size():
				arrow_vertices[v] = arrow_vertices[v].rotated(Vector3(0, 1, 0), -PI / 2) \
						+ Vector3(-0.3, 0, -0.1)
			arrow_vertices.append_array([
				Vector3(0.1, 0, -0.2),
				Vector3(-0.1, 0, 0),
				Vector3(0.1, 0, 0.2),
				Vector3(-0.1, 0, 0.4),
				Vector3(0.3, 0, 0.2),
				Vector3(0.5, 0, 0.4),
				Vector3(0.3, 0, -0.4),
				Vector3(0.5, 0, -0.4),
			])
		InSim.AXOIndex.AXO_MARKER_S2_L, InSim.AXOIndex.AXO_MARKER_S2_R:
			for v in arrow_vertices.size():
				arrow_vertices[v] = arrow_vertices[v] + Vector3(-0.4, 0, 0.2)
			arrow_vertices.append_array([
				Vector3(-0.5, 0, -0.2),
				Vector3(-0.3, 0, 0),
				Vector3(0.1, 0, -0.2),
				Vector3(-0.1, 0, 0),
				Vector3(0.1, 0, 0.2),
				Vector3(-0.1, 0, 0.4),
				Vector3(0.3, 0, 0.2),
				Vector3(0.5, 0, 0.4),
				Vector3(0.3, 0, -0.4),
				Vector3(0.5, 0, -0.4),
			])
		InSim.AXOIndex.AXO_MARKER_U_L, InSim.AXOIndex.AXO_MARKER_U_R:
			for v in arrow_vertices.size():
				arrow_vertices[v] = arrow_vertices[v].rotated(Vector3(0, 1, 0), PI) \
						+ Vector3(-0.2, 0, -0.1)
			arrow_vertices.append_array([
				Vector3(-0.1, 0, 0.2),
				Vector3(-0.3, 0, 0.4),
				Vector3(0.2, 0, 0.2),
				Vector3(0.4, 0, 0.4),
				Vector3(0.2, 0, -0.4),
				Vector3(0.4, 0, -0.4),
			])
	var arrow_line_pairs := int(0.5 * (arrow_vertices.size() - 3))  # 3 for arrow head
	for i in arrow_line_pairs - 1:
		var idx := 3 + 2 * i
		arrow_indices.append_array([
			idx, idx + 1, idx + 3, idx + 3, idx + 2, idx,
		])
	if index in [
		InSim.AXOIndex.AXO_MARKER_CURVE_R,
		InSim.AXOIndex.AXO_MARKER_R,
		InSim.AXOIndex.AXO_MARKER_HARD_R,
		InSim.AXOIndex.AXO_MARKER_R_L,
		InSim.AXOIndex.AXO_MARKER_S_R,
		InSim.AXOIndex.AXO_MARKER_S2_R,
		InSim.AXOIndex.AXO_MARKER_U_R,
	]:
		for v in arrow_vertices.size():
			arrow_vertices[v] = arrow_vertices[v].bounce(Vector3(1, 0, 0))
		for i in int(arrow_indices.size() / 3.0):
			var idx := 3 * i
			var swap := arrow_indices[idx]
			arrow_indices[idx] = arrow_indices[idx + 2]
			arrow_indices[idx + 2] = swap
	var number_width := 0.45  # monospace font character size equivalent
	var number_thickness := 0.1
	var number_0_vertices := PackedVector3Array()
	var zero_segments := 16
	for i in zero_segments:
		var angle := 2 * PI * i / zero_segments
		var a_ext := 0.2
		var b_ext := 0.35
		var a_int := a_ext - number_thickness
		var b_int := b_ext - number_thickness
		number_0_vertices.append_array([
			Vector3(a_ext * cos(angle), 0, b_ext * sin(angle)),
			Vector3(a_int * cos(angle), 0, b_int * sin(angle)),
		])
	var number_0_indices := PackedInt32Array()
	for i in zero_segments:
		var idx := 2 * i
		if i < zero_segments - 1:
			number_0_indices.append_array([
				idx, idx + 1, idx + 3, idx + 3, idx + 2, idx,
			])
		else:
			number_0_indices.append_array([
				idx, idx + 1, 1, 1, 0, idx,
			])
	var number_1_vertices := PackedVector3Array([
		Vector3(0.1 - number_thickness, 0, -0.35),
		Vector3(0.1, 0, -0.35),
		Vector3(0.1 - number_thickness, 0, 0.25),
		Vector3(0.1, 0, 0.35),
		Vector3(0.1 - 2 * number_thickness, 0, 0.25),
		Vector3(0.1 - 1.5 * number_thickness, 0, 0.35),
	])
	var number_1_indices := PackedInt32Array([
		2, 1, 0, 1, 2, 3,
		4, 3, 2, 3, 4, 5,
	])
	var number_2_vertices := PackedVector3Array([
		Vector3(0.2, 0, -0.35),
		Vector3(0.2, 0, -0.35 + number_thickness),
		Vector3(-0.2, 0, -0.35),
		Vector3(-0.2 + 2 * number_thickness, 0, -0.35 + number_thickness),
		Vector3(0.2 - number_thickness, 0, 0).rotated(Vector3(0, 1, 0), deg_to_rad(10)) \
		+ Vector3(-0.05, 0, 0),
		Vector3(0.2, 0, 0).rotated(Vector3(0, 1, 0), deg_to_rad(10)) + Vector3(-0.05, 0, 0),
	])
	var number_2_turn_segments := 7
	for i in number_2_turn_segments:
		var angle := -PI / 6.0 * i
		number_2_vertices.append_array([
			Vector3(0.2 - number_thickness, 0, 0).rotated(Vector3(0, 1, 0), angle) \
					+ Vector3(0, 0, 0.15),
			Vector3(0.2, 0, 0).rotated(Vector3(0, 1, 0), angle) + Vector3(0, 0, 0.15),
		])
	var number_2_indices := PackedInt32Array([
		2, 1, 0, 1, 2, 3,
		4, 3, 2, 3, 4, 5,
	])
	for i in number_2_turn_segments:
		var offset := 4 + 2 * i
		number_2_indices.append_array([
			offset + 2, offset + 1, offset, offset + 1, offset + 2, offset + 3
		])
	var number_5_vertices := PackedVector3Array([
		Vector3(0.2, 0, 0.35 - number_thickness),
		Vector3(0.2, 0, 0.35),
		Vector3(-0.01, 0, 0.35 - number_thickness),
		Vector3(-0.1, 0, 0.35),
		Vector3(-0.03, 0, 0.098),
		Vector3(-0.15, 0, -0.02),
	])
	var number_5_turn_segments := 9
	for i in number_5_turn_segments:
		var angle := PI * (-0.5 + i / 6.0)
		number_5_vertices.append_array([
			Vector3(0.225, 0, 0).rotated(Vector3(0, 1, 0), angle) - Vector3(0, 0, 0.125),
			Vector3(0.225 - number_thickness, 0, 0).rotated(Vector3(0, 1, 0), angle) \
					- Vector3(0, 0, 0.125),
		])
	var number_5_indices := PackedInt32Array([
		2, 1, 0, 1, 2, 3,
		4, 3, 2, 3, 4, 5,
	])
	for i in number_5_turn_segments:
		var offset := 4 + 2 * i
		number_5_indices.append_array([
			offset + 2, offset + 1, offset, offset + 1, offset + 2, offset + 3
		])
	var number_7_vertices := PackedVector3Array([
		Vector3(-0.05 - number_thickness, 0, 0) + Vector3(0, 0, -0.35),
		Vector3(-0.05, 0, -0.35),
		Vector3(0.25 - 1.5 * number_thickness, 0, 0.35 - number_thickness),
		Vector3(0.25, 0, 0.35),
		Vector3(-0.25, 0, 0.35 - number_thickness),
		Vector3(-0.25, 0, 0.35),
	])
	var number_7_indices := PackedInt32Array([
		2, 1, 0, 1, 2, 3,
		4, 3, 2, 3, 4, 5,
	])
	var marker_vertices := PackedVector3Array()
	var marker_indices := PackedInt32Array()
	if index >= InSim.AXOIndex.AXO_MARKER_CURVE_L and index <= InSim.AXOIndex.AXO_MARKER_U_R:
		marker_vertices.append_array(arrow_vertices)
		marker_indices.append_array(arrow_indices)
	else:
		var add_numbers := func add_numbers(numbers: Array[int]
		) -> Array:
			var vertices := PackedVector3Array()
			var indices := PackedInt32Array()
			for n in numbers.size():
				var number := numbers[n]
				if number not in [0, 1, 2, 5, 7]:
					continue
				var new_vertices := (
					number_0_vertices if number == 0 \
					else number_1_vertices if number == 1 \
					else number_2_vertices if number == 2 \
					else number_5_vertices if number == 5 \
					else number_7_vertices if number == 7 \
					else PackedVector3Array()
				)
				var new_indices := (
					number_0_indices if number == 0 \
					else number_1_indices if number == 1 \
					else number_2_indices if number == 2 \
					else number_5_indices if number == 5 \
					else number_7_indices if number == 7 \
					else PackedInt32Array()
				)
				var index_offset := vertices.size()
				vertices.append_array(new_vertices.duplicate())
				indices.append_array(new_indices.duplicate())
				for v in new_vertices.size():
					vertices[-1 - v] = vertices[-1 - v] + Vector3(n * number_width, 0, 0)
				for i in new_indices.size():
					indices[-1 - i] = indices[-1 - i] + index_offset
			for v in vertices.size():
				vertices[v] = vertices[v] - Vector3(0.5 * (numbers.size() - 1) * number_width, 0, 0)
			return [vertices, indices]
		var number_array := []
		match index:
			InSim.AXOIndex.AXO_DIST25:
				number_array = add_numbers.call([2, 5] as Array[int])
			InSim.AXOIndex.AXO_DIST50:
				number_array = add_numbers.call([5, 0] as Array[int])
			InSim.AXOIndex.AXO_DIST75:
				number_array = add_numbers.call([7, 5] as Array[int])
			InSim.AXOIndex.AXO_DIST100:
				number_array = add_numbers.call([1, 0, 0] as Array[int])
			InSim.AXOIndex.AXO_DIST125:
				number_array = add_numbers.call([1, 2, 5] as Array[int])
			InSim.AXOIndex.AXO_DIST150:
				number_array = add_numbers.call([1, 5, 0] as Array[int])
			InSim.AXOIndex.AXO_DIST200:
				number_array = add_numbers.call([2, 0, 0] as Array[int])
			InSim.AXOIndex.AXO_DIST250:
				number_array = add_numbers.call([2, 5, 0] as Array[int])
		marker_vertices = number_array[0]
		marker_indices = number_array[1]
	var marking_angle := atan(
		(BASE_OFFSET - TOP_OFFSET + 0.5 * (BASE_THICKNESS - TOP_THICKNESS)) / HEIGHT
	)
	var marking_offset := TOP_OFFSET + 0.5 * TOP_THICKNESS + 0.5 * HEIGHT * tan(marking_angle)
	for v in marker_vertices.size():
		marker_vertices[v] = marker_vertices[v].rotated(Vector3(0, 0, 1), PI) \
				.rotated(Vector3(1, 0, 0), marking_angle) \
				+ Vector3(0, marking_offset + 0.01, 0.5 * HEIGHT)
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(0)
	for v in marker_vertices:
		st.add_vertex(v)
	for idx in marker_indices:
		st.add_index(idx)
	st.generate_normals()
	mesh = st.commit(mesh)
	mat = generate_default_material()
	mat.albedo_color = Color.BLACK
	mesh.surface_set_material(1, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_pit_box() -> MeshInstance3D:
	var vertices := PackedVector3Array()
	for i in 2:
		var x_sign := -1 if i == 0 else 1
		var _discard := vertices.push_back(Vector3(x_sign * 0.58, 2.125, MARKING_ALTITUDE))
		_discard = vertices.push_back(Vector3(x_sign * 0.58, 1.98, MARKING_ALTITUDE))
		_discard = vertices.push_back(Vector3(x_sign * 1.15, 2.125, MARKING_ALTITUDE))
		_discard = vertices.push_back(Vector3(x_sign * 1.02, 1.98, MARKING_ALTITUDE))
		_discard = vertices.push_back(Vector3(x_sign * 1.15, 1.15, MARKING_ALTITUDE))
		_discard = vertices.push_back(Vector3(x_sign * 1.02, 1.15, MARKING_ALTITUDE))
	var vertex_count := vertices.size()
	vertices.append_array(vertices)
	for i in vertex_count:
		vertices[vertex_count + i] = vertices[i].rotated(Vector3(0, 0, 1), PI)
	var indices := PackedInt32Array()
	indices.append_array([
		0, 1, 2,
		3, 2, 1,
		2, 3, 4,
		5, 4, 3,
		8, 7, 6,
		7, 8, 9,
		10, 9, 8,
		9, 10, 11,
	])
	var index_count := indices.size()
	indices.append_array(indices)
	for i in index_count:
		indices[index_count + i] = indices[i] + vertex_count
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
	mat.albedo_color = Color.GOLDENROD
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_post() -> MeshInstance3D:
	const SEGMENTS := 8
	const THICKNESS := 0.06
	const BASE := 0.2
	const RADIUS := 0.06
	const HEIGHT := 1.15
	var vertices := PackedVector3Array([Vector3.ZERO])
	var _discard: Variant = null
	for r in 3:
		var radius := BASE if r == 0 else RADIUS
		var ring_height := 0.0 if r == 0 else THICKNESS if r == 1 else HEIGHT
		for i in SEGMENTS:
			var offset := 0.75 * PI / 4 if (r == 0 and i % 2 == 1) else 0.0
			var angle := 2 * PI * i / SEGMENTS
			_discard = vertices.push_back(Vector3(
				radius * cos(angle + offset),
				radius * sin(angle + offset),
				ring_height
			))
	_discard = vertices.push_back(Vector3(0, 0, HEIGHT))
	var indices := PackedInt32Array()
	var smooth_groups: Array[Vector2i] = [Vector2i(0, 0)]
	for i in SEGMENTS:
		if i < SEGMENTS - 1:
			indices.append_array([0, i + 1, i + 2])
		else:
			indices.append_array([
				0,
				i + 1,
				1,
			])
	for r in 2:
		smooth_groups.append(Vector2i(indices.size(), smooth_groups.size() % 2))
		for i in SEGMENTS:
			var offset := 1 + r * SEGMENTS + i
			if i < SEGMENTS - 1:
				indices.append_array([offset + SEGMENTS, offset + 1, offset])
				indices.append_array([offset + 1, offset + SEGMENTS, offset + SEGMENTS + 1])
			else:
				indices.append_array([
					offset + SEGMENTS,
					offset + 1 - SEGMENTS,
					offset,
				])
				indices.append_array([
					offset + 1 - SEGMENTS,
					offset + SEGMENTS,
					offset + 1,
				])
	smooth_groups.append(Vector2i(indices.size(), smooth_groups.size() % 2))
	var vertex_count := vertices.size()
	for i in SEGMENTS:
		var offset := vertex_count - 1 - SEGMENTS + i
		if i < SEGMENTS - 1:
			indices.append_array([vertex_count - 1, offset + 1, offset])
		else:
			indices.append_array([
				vertex_count - 1,
				offset + 1 - SEGMENTS,
				offset,
			])
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var s := 0
	for i in indices.size():
		if s < smooth_groups.size() and i == smooth_groups[s].x:
			st.set_smooth_group(smooth_groups[s].y)
			s += 1
		st.add_vertex(vertices[indices[i]])
	st.generate_normals()
	var mesh := st.commit()
	var color := Color.BLACK
	match index:
		InSim.AXOIndex.AXO_POST_GREEN:
			color = Color.GREEN
		InSim.AXOIndex.AXO_POST_ORANGE:
			color = Color.ORANGE
		InSim.AXOIndex.AXO_POST_RED:
			color = Color.RED
		InSim.AXOIndex.AXO_POST_WHITE:
			color = Color.WHITE
	var mat := generate_default_material()
	mat.albedo_color = color
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_railing() -> MeshInstance3D:
	const RAIL_SEGMENTS := 6
	const SPAN := 2.28
	const RADIUS := 0.04
	const BEND_RADIUS := 0.15
	const BEND_RESOLUTION := 3
	const HEIGHT := 1.1
	const SUPPORT_LENGTH := 0.84
	const SUPPORT_HEIGHT := 0.05
	const MID_RAIL_LOW := 0.05
	const MID_RAIL_HIGH := 0.88
	const VERTICAL_MEMBERS := 8
	const VERTICAL_RESOLUTION := 4
	const VERTICAL_RADIUS := 0.015
	var vertices := PackedVector3Array()
	var indices := PackedInt32Array()
	var index_offset := 0
	var smooth_groups: Array[Vector2i] = [Vector2i(0, -1)]
	var support_vertices := PackedVector3Array([
		Vector3(-RADIUS, -0.5 * SUPPORT_LENGTH, 0),
		Vector3(RADIUS, -0.5 * SUPPORT_LENGTH, 0),
		Vector3(-RADIUS, 0.5 * SUPPORT_LENGTH, 0),
		Vector3(RADIUS, 0.5 * SUPPORT_LENGTH, 0),
		Vector3(-RADIUS, 0, SUPPORT_HEIGHT),
		Vector3(RADIUS, 0, SUPPORT_HEIGHT),
	])
	var support_indices := PackedInt32Array([
		0, 1, 2, 3, 2, 1,
		0, 4, 1, 1, 4, 5,
		2, 3, 4, 5, 4, 3,
		0, 2, 4,
		5, 3, 1,
	])
	for s in 2:
		vertices.append_array(support_vertices.duplicate())
		indices.append_array(support_indices.duplicate())
		for v in support_vertices.size():
			vertices[-1 - v] = support_vertices[-1 - v] + Vector3(SPAN * (s - 0.5), 0, 0)
		if s > 0:
			for i in support_indices.size():
				indices[-1 - i] = support_indices[-1 - i] + index_offset
		index_offset += support_vertices.size()
	var mid_width := RADIUS
	var mid_offset := 0.0 if (RAIL_SEGMENTS % 4 == 0) else RADIUS * sin(PI / RAIL_SEGMENTS)
	var mid_vertices := PackedVector3Array([
		Vector3(-(0.5 * SPAN - mid_offset), -mid_width, 0),
		Vector3((0.5 * SPAN - mid_offset), -mid_width, 0),
		Vector3(-(0.5 * SPAN - mid_offset), mid_width, 0),
		Vector3((0.5 * SPAN - mid_offset), mid_width, 0),
		Vector3(-(0.5 * SPAN - mid_offset), -mid_width, 0.03),
		Vector3((0.5 * SPAN - mid_offset), -mid_width, 0.03),
		Vector3(-(0.5 * SPAN - mid_offset), mid_width, 0.03),
		Vector3((0.5 * SPAN - mid_offset), mid_width, 0.03),
	])
	var mid_indices := PackedInt32Array([
		0, 1, 2, 3, 2, 1,
		6, 5, 4, 5, 6, 7,
		4, 1, 0, 1, 4, 5,
		2, 3, 6, 7, 6, 3,
	])
	for r in 2:
		var height := MID_RAIL_LOW if r == 0 else (MID_RAIL_HIGH - MID_RAIL_LOW)
		for v in mid_vertices.size():
			mid_vertices[v] = mid_vertices[v] + Vector3(0, 0, height)
		vertices.append_array(mid_vertices.duplicate())
		indices.append_array(mid_indices.duplicate())
		for i in mid_indices.size():
			indices[-1 - i] = mid_indices[-1 - i] + index_offset
		index_offset += mid_vertices.size()
	# Vertical members
	var vertical_vertices := PackedVector3Array()
	var vertical_indices := PackedInt32Array()
	for i in 2:
		for s in VERTICAL_RESOLUTION:
			var angle := 2 * PI * s / VERTICAL_RESOLUTION
			var _discard := vertical_vertices.append(Vector3(
				VERTICAL_RADIUS * cos(angle),
				VERTICAL_RADIUS * sin(angle),
				MID_RAIL_LOW if i == 0 else MID_RAIL_HIGH
			))
	for s in VERTICAL_RESOLUTION:
		if s < VERTICAL_RESOLUTION - 1:
			vertical_indices.append_array([
				s, s + VERTICAL_RESOLUTION, s + 1,
				s + 1, s + VERTICAL_RESOLUTION, s + VERTICAL_RESOLUTION + 1,
			])
		else:
			vertical_indices.append_array([
				s, s + VERTICAL_RESOLUTION, s + 1 - VERTICAL_RESOLUTION,
				s + 1 - VERTICAL_RESOLUTION, s + VERTICAL_RESOLUTION, s + 1,
			])
	smooth_groups.append(Vector2i(indices.size(), 0))
	for m in VERTICAL_MEMBERS:
		vertices.append_array(vertical_vertices.duplicate())
		indices.append_array(vertical_indices.duplicate())
		for v in vertical_vertices.size():
			vertices[-1 - v] = vertices[-1 - v] \
					+ Vector3(SPAN * ((m + 1) as float / (VERTICAL_MEMBERS + 1) - 0.5), 0, 0)
		for i in vertical_indices.size():
			indices[-1 - i] = indices[-1 - i] + index_offset
		index_offset += vertical_vertices.size()
	# Railing
	var ring_vertices := PackedVector3Array()
	var grow_factor := 1 / (1.0 if (RAIL_SEGMENTS % 4 == 0) else cos(PI / RAIL_SEGMENTS))
	for i in RAIL_SEGMENTS:
		var angle := 2 * PI * i / RAIL_SEGMENTS
		var _discard := ring_vertices.append(Vector3(
			RADIUS * cos(angle),
			RADIUS * sin(angle) * grow_factor,
			0
		))
	var transform_ring := func transform_ring(
		angle: float, translation: Vector3
	) -> PackedVector3Array:
		var result := ring_vertices.duplicate()
		for v in result.size():
			result[v] = result[v].rotated(Vector3(0, 1, 0), angle) + translation
		return result
	var rail_vertices := PackedVector3Array()
	var rail_angle := 0.0
	rail_vertices.append_array(transform_ring.call(rail_angle,
			Vector3(-0.5 * SPAN, 0, 0.02)) as PackedVector3Array)
	rail_vertices.append_array(transform_ring.call(rail_angle,
			Vector3(-0.5 * SPAN, 0, HEIGHT - BEND_RADIUS)) as PackedVector3Array)
	for i in BEND_RESOLUTION:
		rail_angle += PI / 2 / BEND_RESOLUTION
		rail_vertices.append_array(transform_ring.call(
			rail_angle,
			Vector3(
				-0.5 * SPAN + BEND_RADIUS * (1 - cos(rail_angle)),
				0,
				HEIGHT - BEND_RADIUS * (1 - sin(rail_angle))
			)
		) as PackedVector3Array)
	rail_vertices.append_array(transform_ring.call(rail_angle,
			Vector3(0.5 * SPAN - BEND_RADIUS, 0, HEIGHT)) as PackedVector3Array)
	for i in BEND_RESOLUTION:
		rail_angle += PI / 2 / BEND_RESOLUTION
		rail_vertices.append_array(transform_ring.call(
			rail_angle,
			Vector3(
				0.5 * SPAN - BEND_RADIUS * (1 + cos(rail_angle)),
				0,
				HEIGHT - BEND_RADIUS * (1 - sin(rail_angle))
			)
		) as PackedVector3Array)
	rail_vertices.append_array(transform_ring.call(rail_angle,
			Vector3(0.5 * SPAN, 0, 0.02)) as PackedVector3Array)
	var rail_indices := PackedInt32Array()
	for i in 3 + 2 * BEND_RESOLUTION:  # 3 straights + 2 bends
		for s in RAIL_SEGMENTS:
			if s < RAIL_SEGMENTS - 1:
				rail_indices.append_array([
					s, s + RAIL_SEGMENTS, s + 1,
					s + 1, s + RAIL_SEGMENTS, s + RAIL_SEGMENTS + 1,
				])
			else:
				rail_indices.append_array([
					s, s + RAIL_SEGMENTS, s + 1 - RAIL_SEGMENTS,
					s + 1 - RAIL_SEGMENTS, s + RAIL_SEGMENTS, s + 1,
				])
		for r in 3 * 2 * ring_vertices.size():
			rail_indices[-1 - r] = rail_indices[-1 - r] + index_offset
		index_offset += ring_vertices.size()
	vertices.append_array(rail_vertices)
	indices.append_array(rail_indices)
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var s := 0
	for i in indices.size():
		if s < smooth_groups.size() and i == smooth_groups[s].x:
			st.set_smooth_group(smooth_groups[s].y)
			s += 1
		st.add_vertex(vertices[indices[i]])
	st.generate_normals()
	var mesh := st.commit()
	var mat := generate_default_material()
	mat.albedo_color = Color.WEB_GRAY
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_ramp() -> MeshInstance3D:
	const LENGTH := 11.26
	const HEIGHT := 0.87
	const THICKNESS := 0.16
	const SUPPORT_OFFSET := 3.885
	const SUPPORT_LENGTH := 0.155
	const OFFSET := 3.625
	var width := 0.52 if index == InSim.AXOIndex.AXO_RAMP1 else 2.8
	var support_width := width - 0.1
	var angle := atan(HEIGHT / LENGTH)
	var bottom_offset := THICKNESS / cos(PI / 2 - angle) * 0.85  # LFS thickness not constant
	var support_offset := OFFSET + SUPPORT_OFFSET
	var support_height := (SUPPORT_OFFSET + 0.5 * LENGTH) * sin(angle) \
			- 0.5 * THICKNESS / sin(PI / 2 - angle)  # simplified, good enough
	var vertices := PackedVector3Array([
		# Ramp
		Vector3(-0.5 * width, OFFSET - 0.5 * LENGTH, 0),
		Vector3(0.5 * width, OFFSET - 0.5 * LENGTH, 0),
		Vector3(-0.5 * width, OFFSET - 0.5 * LENGTH + bottom_offset, 0),
		Vector3(0.5 * width, OFFSET - 0.5 * LENGTH + bottom_offset, 0),
		Vector3(-0.5 * width, OFFSET + 0.5 * LENGTH, HEIGHT),
		Vector3(0.5 * width, OFFSET + 0.5 * LENGTH, HEIGHT),
		Vector3(-0.5 * width, OFFSET + 0.5 * LENGTH, HEIGHT - THICKNESS),
		Vector3(0.5 * width, OFFSET + 0.5 * LENGTH, HEIGHT - THICKNESS),
		# Support
		Vector3(-0.5 * support_width, support_offset - 0.5 * SUPPORT_LENGTH, 0),
		Vector3(0.5 * support_width, support_offset - 0.5 * SUPPORT_LENGTH, 0),
		Vector3(-0.5 * support_width, support_offset + 0.5 * SUPPORT_LENGTH, 0),
		Vector3(0.5 * support_width, support_offset + 0.5 * SUPPORT_LENGTH, 0),
		Vector3(-0.5 * support_width, support_offset - 0.5 * SUPPORT_LENGTH, support_height),
		Vector3(0.5 * support_width, support_offset - 0.5 * SUPPORT_LENGTH, support_height),
		Vector3(-0.5 * support_width, support_offset + 0.5 * SUPPORT_LENGTH, support_height),
		Vector3(0.5 * support_width, support_offset + 0.5 * SUPPORT_LENGTH, support_height),
	])
	var indices := PackedInt32Array([
		# Ramp
		0, 1, 2, 3, 2, 1,
		6, 5, 4, 5, 6, 7,
		4, 1, 0, 1, 4, 5,
		2, 3, 6, 7, 6, 3,
		0, 2, 4, 6, 4, 2,
		5, 3, 1, 3, 5, 7,
		# Support
		8, 9, 10, 11, 10, 9,
		12, 9, 8, 9, 12, 13,
		10, 11, 14, 15, 14, 11,
		8, 10, 12, 14, 12, 10,
		13, 11, 9, 11, 13, 15,
	])
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	for i in vertices.size():
		st.add_vertex(vertices[i])
	for i in indices.size():
		st.add_index(indices[i])
	st.generate_normals()
	var mesh := st.commit()
	var mat := generate_default_material()
	mat.albedo_color = Color.GRAY
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_sign_speed() -> MeshInstance3D:
	const WIDTH := 1.05
	const SPREAD := 1.23
	const TOP_LENGTH := 0.095
	const HEIGHT := 1.295
	const THICKNESS := 0.135
	var sign_angle := atan(HEIGHT / (0.5 * (SPREAD - TOP_LENGTH)))
	var bottom_offset := THICKNESS / cos(PI / 2 - sign_angle)
	var height_bottom := (0.5 * SPREAD - bottom_offset) * tan(sign_angle)
	var vertices := PackedVector3Array([
		Vector3(-0.5 * WIDTH, -0.5 * SPREAD, 0),
		Vector3(0.5 * WIDTH, -0.5 * SPREAD, 0),
		Vector3(-0.5 * WIDTH, -0.5 * SPREAD + bottom_offset, 0),
		Vector3(0.5 * WIDTH, -0.5 * SPREAD + bottom_offset, 0),
		Vector3(-0.5 * WIDTH, -0.5 * TOP_LENGTH, HEIGHT),
		Vector3(0.5 * WIDTH, -0.5 * TOP_LENGTH, HEIGHT),
		Vector3(-0.5 * WIDTH, 0, height_bottom),
		Vector3(0.5 * WIDTH, 0, height_bottom),
		Vector3(-0.5 * WIDTH, 0.5 * TOP_LENGTH, HEIGHT),
		Vector3(0.5 * WIDTH, 0.5 * TOP_LENGTH, HEIGHT),
		Vector3(-0.5 * WIDTH, 0.5 * SPREAD, 0),
		Vector3(0.5 * WIDTH, 0.5 * SPREAD, 0),
		Vector3(-0.5 * WIDTH, 0.5 * SPREAD - bottom_offset, 0),
		Vector3(0.5 * WIDTH, 0.5 * SPREAD - bottom_offset, 0),
	])
	var indices := PackedInt32Array([
		4, 1, 0, 1, 4, 5,
		8, 5, 4, 5, 8, 9,
		8, 10, 11, 11, 9, 8,
		12, 11, 10, 11, 12, 13,
		13, 12, 6, 6, 7, 13,
		2, 3, 6, 7, 6, 3,
		0, 1, 2, 3, 2, 1,
		0, 2, 6, 6, 4, 0,
		10, 8, 6, 12, 10, 6,
		4, 6, 8,
		7, 3, 1, 1, 5, 7,
		7, 11, 13, 7, 9, 11,
		9, 7, 5,
	])
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	for i in indices.size():
		st.add_vertex(vertices[indices[i]])
	st.generate_normals()
	var mesh := st.commit()
	var mat := generate_default_material()
	mat.albedo_color = Color.GRAY
	mesh.surface_set_material(0, mat)

	var number_thickness := 0.1
	var number_0_vertices := PackedVector3Array()
	var zero_segments := 16
	for i in zero_segments:
		var angle := 2 * PI * i / zero_segments
		var a_ext := 0.2
		var b_ext := 0.35
		var a_int := a_ext - number_thickness
		var b_int := b_ext - number_thickness
		number_0_vertices.append_array([
			Vector3(a_ext * cos(angle), 0, b_ext * sin(angle)),
			Vector3(a_int * cos(angle), 0, b_int * sin(angle)),
		])
	var number_0_indices := PackedInt32Array()
	for i in zero_segments:
		var idx := 2 * i
		if i < zero_segments - 1:
			number_0_indices.append_array([
				idx, idx + 1, idx + 3, idx + 3, idx + 2, idx,
			])
		else:
			number_0_indices.append_array([
				idx, idx + 1, 1, 1, 0, idx,
			])
	var number_5_vertices := PackedVector3Array([
		Vector3(0.2, 0, 0.35 - number_thickness),
		Vector3(0.2, 0, 0.35),
		Vector3(-0.01, 0, 0.35 - number_thickness),
		Vector3(-0.1, 0, 0.35),
		Vector3(-0.03, 0, 0.098),
		Vector3(-0.15, 0, -0.02),
	])
	var number_5_turn_segments := 9
	for i in number_5_turn_segments:
		var angle := PI * (-0.5 + i / 6.0)
		number_5_vertices.append_array([
			Vector3(0.225, 0, 0).rotated(Vector3(0, 1, 0), angle) - Vector3(0, 0, 0.125),
			Vector3(0.225 - number_thickness, 0, 0).rotated(Vector3(0, 1, 0), angle) \
					- Vector3(0, 0, 0.125),
		])
	var number_5_indices := PackedInt32Array([
		2, 1, 0, 1, 2, 3,
		4, 3, 2, 3, 4, 5,
	])
	for i in number_5_turn_segments:
		var offset := 4 + 2 * i
		number_5_indices.append_array([
			offset + 2, offset + 1, offset, offset + 1, offset + 2, offset + 3
		])
	var number_8_vertices := PackedVector3Array()
	var eight_segments := 16
	for c in 2:
		for i in eight_segments:
			var angle := 2 * PI * i / eight_segments
			var a_ext := 0.2
			var b_ext := 0.2
			var a_int := a_ext - number_thickness
			var b_int := b_ext - number_thickness
			var offset := (-1 if c == 0 else 1) * (b_ext - 0.5 * number_thickness)
			number_8_vertices.append_array([
				Vector3(a_ext * cos(angle), 0, b_ext * sin(angle) + offset),
				Vector3(a_int * cos(angle), 0, b_int * sin(angle) + offset),
			])
	var number_8_indices := PackedInt32Array()
	for c in 2:
		for i in eight_segments:
			var idx := 2 * c * eight_segments + 2 * i
			if i < eight_segments - 1:
				number_8_indices.append_array([
					idx, idx + 1, idx + 3, idx + 3, idx + 2, idx,
				])
			else:
				var first_idx := 0 if c == 0 else 2 * eight_segments
				number_8_indices.append_array([
					idx, idx + 1, first_idx + 1, first_idx + 1, first_idx + 0, idx,
				])
	var number_width := 0.45  # monospace font character size equivalent
	var number_vertices := PackedVector3Array()
	var number_indices := PackedInt32Array()
	for n in 2:
		if n == 0:
			number_vertices.append_array(
				(number_8_vertices if index == InSim.AXOIndex.AXO_SIGN_SPEED_80 \
				else number_5_vertices).duplicate()
			)
			for v in number_vertices.size():
				number_vertices[v] = number_vertices[v] + Vector3(-0.5 * number_width, 0, 0)
			number_indices.append_array(
				(number_8_indices if index == InSim.AXOIndex.AXO_SIGN_SPEED_80 \
				else number_5_indices).duplicate()
			)
		else:
			var index_offset := number_vertices.size()
			number_vertices.append_array(number_0_vertices.duplicate())
			for v in number_0_vertices.size():
				number_vertices[-1 - v] = number_vertices[-1 - v] \
						+ Vector3(0.5 * number_width, 0, 0)
			number_indices.append_array(number_0_indices.duplicate())
			for i in number_0_indices.size():
				number_indices[-1 - i] = number_indices[-1 - i] + index_offset
	var marking_height := 0.4 * HEIGHT
	var marking_offset := 0.5 * SPREAD - marking_height * tan(PI / 2 - sign_angle)
	for v in number_vertices.size():
		number_vertices[v] = (number_vertices[v] * 2 / 3.0) \
				.rotated(Vector3(0, 0, 1), PI) \
				.rotated(Vector3(1, 0, 0), PI / 2 - sign_angle) \
				+ Vector3(0, marking_offset + 0.01, marking_height)
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_smooth_group(-1)
	for i in number_indices.size():
		st.add_vertex(number_vertices[number_indices[i]])
	st.generate_normals()
	mesh = st.commit(mesh)
	mat = generate_default_material()
	mat.albedo_color = Color.BLACK
	mesh.surface_set_material(1, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_speed_hump() -> MeshInstance3D:
	const END_SEGMENTS := 5
	const BASE_WIDTH := 0.5
	const TOP_WIDTH := 0.18
	const HEIGHT := 0.08
	const STEP := 0.25
	var hump_colors: Array[Color] = [Color.GOLDENROD.lightened(0.1), Color.SLATE_GRAY.darkened(0.5)]
	var length := 9.5 if index == InSim.AXOIndex.AXO_SPEED_HUMP_10M else 5.5
	var steps := int(0.5 * length / STEP) - 1
	var vertices := PackedVector3Array()
	var indices := PackedInt32Array()
	var colors := PackedColorArray()
	var smooth_groups: Array[Vector2i] = [Vector2i(0, 0)]
	var section_vertices := PackedVector3Array([
		Vector3(-0.5 * BASE_WIDTH, 0, 0),
		Vector3(-0.5 * TOP_WIDTH, 0, HEIGHT),
		Vector3(0.5 * TOP_WIDTH, 0, HEIGHT),
		Vector3(0.5 * BASE_WIDTH, 0, 0),
	])
	var SECTION := 4
	for i in steps + 1:
		vertices.append_array(section_vertices.duplicate())
		for v in SECTION:
			vertices[-1 - v] = vertices[-1 - v] + Vector3(0, i * STEP, 0)
	for i in steps:
		smooth_groups.append(Vector2i(indices.size() + 6 * (SECTION - 1), 1))
		smooth_groups.append(Vector2i(indices.size() + 6 * SECTION, 0))
		var offset := i * SECTION
		indices.append_array([
			offset + 0, offset + SECTION + 0, offset + SECTION + 1,
			offset + SECTION + 1, offset + 1, offset + 0,
			offset + 1, offset + SECTION + 1, offset + SECTION + 2,
			offset + SECTION + 2, offset + 2, offset + 1,
			offset + 2, offset + SECTION + 2, offset + SECTION + 3,
			offset + SECTION + 3, offset + 3, offset + 2,
			offset + 3, offset + SECTION + 3, offset + SECTION + 0,
			offset + SECTION + 0, offset + 0, offset + 3,
		])
		var section_colors := PackedColorArray()
		var _resize_colors := section_colors.resize(6 * SECTION)
		section_colors.fill(hump_colors[i % 2])
		colors.append_array(section_colors)
	var end_vertices := PackedVector3Array()
	for i in END_SEGMENTS + 1:
		var angle := PI * i / END_SEGMENTS
		end_vertices.append_array([
			Vector3(0.5 * BASE_WIDTH * cos(angle), 0.5 * BASE_WIDTH * sin(angle), 0),
			Vector3(0.5 * TOP_WIDTH * cos(angle), 0.5 * TOP_WIDTH * sin(angle), HEIGHT)
		])
	var end_indices := PackedInt32Array()
	for i in END_SEGMENTS:
		var idx := 2 * i
		end_indices.append_array([
			idx, idx + 1, idx + 2,
			idx + 3, idx + 2, idx + 1,
		])
	var vertex_count := end_vertices.size()
	for i in int(END_SEGMENTS / 2.0):
		var idx := 2 * i
		end_indices.append_array([
			idx + 3, idx + 1, vertex_count - idx - 1,
			vertex_count - idx - 1, vertex_count - idx - 3, idx + 3,
		])
	var index_offset := vertices.size()
	vertices.append_array(end_vertices.duplicate())
	for v in end_vertices.size():
		vertices[-1 - v] = vertices[-1 - v] + Vector3(0, steps * STEP, 0)
	indices.append_array(end_indices.duplicate())
	for i in end_indices.size():
		indices[-1 - i] = indices[-1 - i] + index_offset
	var new_colors := PackedColorArray()
	var _resize := new_colors.resize(end_indices.size())
	new_colors.fill(hump_colors[0])
	colors.append_array(new_colors)
	# Duplicate everything for other half
	vertex_count = vertices.size()
	index_offset = vertex_count
	vertices.append_array(vertices.duplicate())
	for v in vertex_count:
		vertices[-1 - v] = vertices[-1 - v].rotated(Vector3(0, 0, 1),  PI) + Vector3(0, -STEP, 0)
	var index_count := indices.size()
	indices.append_array(indices.duplicate())
	for i in index_count:
		indices[-1 - i] = indices[-1 - i] + index_offset
	colors.append_array(colors.duplicate())
	var group_count := smooth_groups.size()
	smooth_groups.append_array(smooth_groups.duplicate())
	for g in group_count:
		smooth_groups[-1 - g] = Vector2i(
			smooth_groups[-1 - g].x + index_count,
			smooth_groups[-1 - g].y
		)
	# Fill missing section
	smooth_groups.append(Vector2i(indices.size() + 6 * (SECTION - 1), 1))
	smooth_groups.append(Vector2i(indices.size() + 6 * SECTION, 0))
	indices.append_array([
		index_offset + SECTION - 1, 0, 1,
		1, index_offset + SECTION - 2, index_offset + SECTION - 1,
		index_offset + SECTION - 2, 1, 2,
		2, index_offset + SECTION - 3, index_offset + SECTION - 2,
		index_offset + SECTION - 3, 2, 3,
		3, index_offset + SECTION - 4, index_offset + SECTION - 3,
		index_offset + SECTION - 4, 3, 0,
		0, index_offset + SECTION - 1, index_offset + SECTION - 4,
	])
	var last_colors := PackedColorArray()
	_resize = last_colors.resize(6 * SECTION)
	last_colors.fill(hump_colors[1])
	colors.append_array(last_colors)
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var s := 0
	for i in indices.size():
		if s < smooth_groups.size() and i == smooth_groups[s].x:
			st.set_smooth_group(smooth_groups[s].y)
			s += 1
		st.set_color(colors[i])
		st.add_vertex(vertices[indices[i]])
	st.generate_normals()
	var mesh := st.commit()
	var mat := generate_default_material()
	mat.vertex_color_use_as_albedo = true
	mat.vertex_color_is_srgb = true
	mat.albedo_color = Color.WHITE
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


func get_mesh_start_position() -> MeshInstance3D:
	var vertices := PackedVector3Array()
	for i in 2:
		var x_sign := -1 if i == 0 else 1
		var _discard := vertices.push_back(Vector3(x_sign * 1.03, 2.0, MARKING_ALTITUDE))
		_discard = vertices.push_back(Vector3(x_sign * 1.03, 1.15, MARKING_ALTITUDE))
		_discard = vertices.push_back(Vector3(x_sign * 1.15, 1.15, MARKING_ALTITUDE))
		_discard = vertices.push_back(Vector3(x_sign * 1.15, 2.13, MARKING_ALTITUDE))
	var indices := PackedInt32Array()
	indices = PackedInt32Array([
		0, 1, 2,
		0, 2, 3,
		6, 5, 4,
		7, 6, 4,
		0, 3, 7,
		7, 4, 0,
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
	mat.albedo_color = Color.WHITE
	mesh.surface_set_material(0, mat)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	return mesh_instance


## Sets the object's variables from the given [param buffer]. Also updates [code]gis_*[/code]
## variables (see [method update_gis_values] for details).
func set_from_buffer(buffer: PackedByteArray) -> void:
	x = buffer.decode_s16(0)
	y = buffer.decode_s16(2)
	z = buffer.decode_u8(4)
	flags = buffer.decode_u8(5)
	index = buffer.decode_u8(6) as InSim.AXOIndex
	heading = buffer.decode_u8(7)
	update_gis_values()


## Uses the [code]gis_*[/code] variables to set LFS-style variables.
func set_from_gis_values() -> void:
	x = roundi(gis_position.x * XY_MULTIPLIER)
	y = roundi(gis_position.y * XY_MULTIPLIER)
	z = roundi(gis_position.z * Z_MULTIPLIER)
	heading = roundi((rad_to_deg(gis_heading) + 180) * HEADING_MULTIPLIER)


## Updates [member flags] to reflect the values of the object's specific variables.
## Define update logic in [method _update_flags].
func update_flags() -> void:
	_update_flags()


## Updates LFS-style sub-variables corresponding to the object's [member flags], based on the
## corresponding [code]gis_*[/code] values. See [method _update_flags_from_gis].
func update_flags_from_gis() -> void:
	_update_flags_from_gis()


## Updates the [code]gis_*[/code] variables from LFS-style values.
func update_gis_values() -> void:
	gis_position = Vector3(
		x / XY_MULTIPLIER,
		y / XY_MULTIPLIER,
		z / Z_MULTIPLIER
	)
	gis_heading = deg_to_rad(heading / HEADING_MULTIPLIER - 180)
