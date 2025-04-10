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
		InSim.AXOIndex.AXO_CONE_YELLOW, InSim.AXOIndex.AXO_CONE_YELLOW2:
			dimensions = Vector3(0.38, 0.38, 0.65)
			taper_top = Vector2.ONE * 0.25
			if index == InSim.AXOIndex.AXO_CONE_RED:
				color = Color.RED
			if index == InSim.AXOIndex.AXO_CONE_RED2:
				color = Color.ORANGE_RED
			if index == InSim.AXOIndex.AXO_CONE_RED3:
				color = Color.INDIAN_RED
			elif index == InSim.AXOIndex.AXO_CONE_BLUE:
				color = Color.BLUE
			elif index == InSim.AXOIndex.AXO_CONE_BLUE2:
				color = Color.DEEP_SKY_BLUE
			elif index == InSim.AXOIndex.AXO_CONE_GREEN:
				color = Color.FOREST_GREEN
			elif index == InSim.AXOIndex.AXO_CONE_GREEN2:
				color = Color.GREEN
			elif index == InSim.AXOIndex.AXO_CONE_ORANGE:
				color = Color.ORANGE
			elif index == InSim.AXOIndex.AXO_CONE_WHITE:
				color = Color.WHITE
			elif index == InSim.AXOIndex.AXO_CONE_YELLOW:
				color = Color.YELLOW
			elif index == InSim.AXOIndex.AXO_CONE_YELLOW2:
				color = Color.GOLD
		InSim.AXOIndex.AXO_CONE_PTR_RED, InSim.AXOIndex.AXO_CONE_PTR_BLUE, \
		InSim.AXOIndex.AXO_CONE_PTR_GREEN, InSim.AXOIndex.AXO_CONE_PTR_YELLOW:
			dimensions = Vector3(0.45, 0.7, 0.45)
			if index == InSim.AXOIndex.AXO_CONE_PTR_RED:
				color = Color.RED
			elif index == InSim.AXOIndex.AXO_CONE_PTR_BLUE:
				color = Color.SKY_BLUE
			elif index == InSim.AXOIndex.AXO_CONE_PTR_GREEN:
				color = Color.GREEN
			else:
				color = Color.GOLD
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
			dimensions = Vector3(1.42, 0.4, 1)
			offset = Vector3(0, -0.02, 0)
			taper_top = Vector2(1, 0.4)
			color = Color.BURLYWOOD
		InSim.AXOIndex.AXO_ARMCO1, InSim.AXOIndex.AXO_ARMCO3, InSim.AXOIndex.AXO_ARMCO5:
			var length := 3.2 * (1 + 2 * (index - InSim.AXOIndex.AXO_ARMCO1)) + 0.55
			dimensions = Vector3(0.3, length, 0.65)
			color = Color.WEB_GRAY
		InSim.AXOIndex.AXO_BARRIER_LONG, InSim.AXOIndex.AXO_BARRIER_RED, \
		InSim.AXOIndex.AXO_BARRIER_WHITE:
			var length := 1.375 * (1 if index > InSim.AXOIndex.AXO_BARRIER_LONG else 6)
			dimensions = Vector3(0.35, length, 0.8)
			if index == InSim.AXOIndex.AXO_BARRIER_LONG:
				offset = Vector3(0, -0.69, 0)
			taper_top = Vector2(0.4, 1)
			if index == InSim.AXOIndex.AXO_BARRIER_RED:
				color = Color.RED
			elif index == InSim.AXOIndex.AXO_BARRIER_WHITE:
				color = Color.WHITE
			else:
				color = Color.PINK
		InSim.AXOIndex.AXO_BANNER1, InSim.AXOIndex.AXO_BANNER2:
			dimensions = Vector3(5.95, 0.85, 0.98)
			taper_top = Vector2(1, 0)
			if index == InSim.AXOIndex.AXO_BANNER2:
				color = Color.DIM_GRAY
		InSim.AXOIndex.AXO_RAMP1, InSim.AXOIndex.AXO_RAMP2:
			var width := 0.5 if index == InSim.AXOIndex.AXO_RAMP1 else 2.8
			dimensions = Vector3(width, 11.25, 0.85)
			offset = Vector3(0, 3.6, 0)
			taper_top = Vector2(1, 0)
			shift_top_y = 0.5 * dimensions.y
		InSim.AXOIndex.AXO_SPEED_HUMP_10M, InSim.AXOIndex.AXO_SPEED_HUMP_6M:
			var length := 9.75 if index == InSim.AXOIndex.AXO_SPEED_HUMP_10M else 5.75
			dimensions = Vector3(0.5, length, 0.08)
			offset = Vector3(0, -0.125, 0)
			taper_top = Vector2(0.35, 1)
			color = Color.DARK_GOLDENROD
		InSim.AXOIndex.AXO_POST_GREEN, InSim.AXOIndex.AXO_POST_ORANGE, \
		InSim.AXOIndex.AXO_POST_RED, InSim.AXOIndex.AXO_POST_WHITE:
			dimensions = Vector3(0.3, 0.3, 1.15)
			taper_top = Vector2.ONE * 0.4
			if index == InSim.AXOIndex.AXO_POST_GREEN:
				color = Color.GREEN
			elif index == InSim.AXOIndex.AXO_POST_ORANGE:
				color = Color.ORANGE
			elif index == InSim.AXOIndex.AXO_POST_RED:
				color = Color.RED
			else:
				color = Color.WHITE
		InSim.AXOIndex.AXO_BALE:
			dimensions = Vector3(1.52, 0.7, 0.63)
			offset = Vector3(0, -0.35, 0)
			color = Color.SANDY_BROWN
		InSim.AXOIndex.AXO_RAILING:
			dimensions = Vector3(2.35, 0.1, 1.1)
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
			dimensions = Vector3(1, 1.2, 1.3)
			taper_top = Vector2(1, 0.1)
			color = Color.RED
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
	var mat := StandardMaterial3D.new()
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
	var arrays := []
	var _resize := arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
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
	var arrays := []
	var _resize := arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var mat := StandardMaterial3D.new()
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
	var arrays := []
	_resize = arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color.YELLOW
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mesh.surface_set_material(0, mat)
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
	var arrays := []
	var _resize := arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color.GOLDENROD
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
	var arrays := []
	var _resize := arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var mat := StandardMaterial3D.new()
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
