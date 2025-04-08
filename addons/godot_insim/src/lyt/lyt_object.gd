class_name LYTObject
extends RefCounted

## LYT object
##
## This class describes a layout object, as included in a layout (LYT) file.

const STRUCT_SIZE := 8

const XY_MULTIPLIER := 16.0
const Z_MULTIPLIER := 4.0
const HEADING_MULTIPLIER := 256 / 360.0

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
	var mesh_instance := MeshInstance3D.new()
	var mesh := ArrayMesh.new()
	var color := Color.GRAY
	var arrays := []
	var _resize := arrays.resize(Mesh.ARRAY_MAX)
	var dimensions := Vector3(0.5, 0.5, 1)
	var offset := Vector3.ZERO  # offsets whole mesh
	var taper_top := Vector2.ONE  # 0 to 1, scales top face
	var shift_top_y := 0.0  # offset for top face along Y axis
	match index:
		InSim.AXOIndex.AXO_CHALK_LINE:
			dimensions = Vector3(8, 0.25, 0.05)
		InSim.AXOIndex.AXO_CHALK_LINE2:
			dimensions = Vector3(0.2, 4.8, 0.05)
		InSim.AXOIndex.AXO_CHALK_AHEAD:
			dimensions = Vector3(0.4, 2, 0.05)
		InSim.AXOIndex.AXO_CHALK_AHEAD2:
			dimensions = Vector3(0.4, 3.5, 0.05)
		InSim.AXOIndex.AXO_CHALK_LEFT, InSim.AXOIndex.AXO_CHALK_RIGHT:
			dimensions = Vector3(0.7, 2, 0.05)
		InSim.AXOIndex.AXO_CHALK_LEFT2, InSim.AXOIndex.AXO_CHALK_RIGHT2:
			dimensions = Vector3(1.8, 2.5, 0.05)
		InSim.AXOIndex.AXO_CHALK_LEFT3, InSim.AXOIndex.AXO_CHALK_RIGHT3:
			dimensions = Vector3(0.7, 3.5, 0.05)
		InSim.AXOIndex.AXO_CONE_RED, InSim.AXOIndex.AXO_CONE_RED2, InSim.AXOIndex.AXO_CONE_RED3, \
		InSim.AXOIndex.AXO_CONE_BLUE, InSim.AXOIndex.AXO_CONE_BLUE2, \
		InSim.AXOIndex.AXO_CONE_GREEN, InSim.AXOIndex.AXO_CONE_GREEN2, \
		InSim.AXOIndex.AXO_CONE_ORANGE, InSim.AXOIndex.AXO_CONE_WHITE, \
		InSim.AXOIndex.AXO_CONE_YELLOW, InSim.AXOIndex.AXO_CONE_YELLOW2:
			dimensions = Vector3(0.38, 0.38, 0.65)
			taper_top = Vector2.ONE * 0.25
		InSim.AXOIndex.AXO_CONE_PTR_RED, InSim.AXOIndex.AXO_CONE_PTR_BLUE, \
		InSim.AXOIndex.AXO_CONE_PTR_GREEN, InSim.AXOIndex.AXO_CONE_PTR_YELLOW:
			dimensions = Vector3(0.45, 0.7, 0.45)
		InSim.AXOIndex.AXO_TYRE_SINGLE, InSim.AXOIndex.AXO_TYRE_STACK2, \
		InSim.AXOIndex.AXO_TYRE_STACK3, InSim.AXOIndex.AXO_TYRE_STACK4:
			var stack_height := (index + 1 - InSim.AXOIndex.AXO_TYRE_SINGLE)
			dimensions = Vector3(0.6, 0.6, 0.2 * stack_height)
		InSim.AXOIndex.AXO_TYRE_SINGLE_BIG, InSim.AXOIndex.AXO_TYRE_STACK2_BIG, \
		InSim.AXOIndex.AXO_TYRE_STACK3_BIG, InSim.AXOIndex.AXO_TYRE_STACK4_BIG:
			var stack_height := (index + 1 - InSim.AXOIndex.AXO_TYRE_SINGLE_BIG)
			dimensions = Vector3(0.78, 0.78, 0.27 * stack_height)
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
		InSim.AXOIndex.AXO_ARMCO1, InSim.AXOIndex.AXO_ARMCO3, InSim.AXOIndex.AXO_ARMCO5:
			var length := 3.2 * (1 + 2 * (index - InSim.AXOIndex.AXO_ARMCO1)) + 0.55
			dimensions = Vector3(0.3, length, 0.65)
		InSim.AXOIndex.AXO_BARRIER_LONG, InSim.AXOIndex.AXO_BARRIER_RED, \
		InSim.AXOIndex.AXO_BARRIER_WHITE:
			var length := 1.375 * (1 if index > InSim.AXOIndex.AXO_BARRIER_LONG else 6)
			dimensions = Vector3(0.35, length, 0.8)
			if index == InSim.AXOIndex.AXO_BARRIER_LONG:
				offset = Vector3(0, -0.69, 0)
			taper_top = Vector2(0.4, 1)
		InSim.AXOIndex.AXO_BANNER1, InSim.AXOIndex.AXO_BANNER2:
			dimensions = Vector3(5.95, 0.85, 0.98)
			taper_top = Vector2(1, 0)
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
		InSim.AXOIndex.AXO_POST_GREEN, InSim.AXOIndex.AXO_POST_ORANGE, \
		InSim.AXOIndex.AXO_POST_RED, InSim.AXOIndex.AXO_POST_WHITE:
			dimensions = Vector3(0.3, 0.3, 1.15)
			taper_top = Vector2.ONE * 0.4
		InSim.AXOIndex.AXO_BALE:
			dimensions = Vector3(1.52, 0.7, 0.63)
			offset = Vector3(0, -0.35, 0)
		InSim.AXOIndex.AXO_RAILING:
			dimensions = Vector3(2.35, 0.1, 1.1)
		InSim.AXOIndex.AXO_START_LIGHTS:
			dimensions = Vector3(0.5, 0.7, 2)
		InSim.AXOIndex.AXO_SIGN_KEEP_LEFT, InSim.AXOIndex.AXO_SIGN_KEEP_RIGHT:
			dimensions = Vector3(0.8, 0.65, 1.1)
			offset = Vector3(0, -0.325, 0)
			taper_top = Vector2(1, 0.1)
			shift_top_y = -0.05
		InSim.AXOIndex.AXO_SIGN_SPEED_80, InSim.AXOIndex.AXO_SIGN_SPEED_50:
			dimensions = Vector3(1, 1.2, 1.3)
			taper_top = Vector2(1, 0.1)
		InSim.AXOIndex.AXO_START_POSITION:
			dimensions = Vector3(2.4, 1, 0.05)
			offset = Vector3(0, 1.6, 0)
		InSim.AXOIndex.AXO_PIT_START_POINT:
			dimensions = Vector3(0.4, 3, 0.05)
		InSim.AXOIndex.AXO_PIT_STOP_BOX:
			dimensions = Vector3(2.3, 4.2, 0.05)
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
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
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
