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
	var arrays := []
	var _resize := arrays.resize(Mesh.ARRAY_MAX)
	var vertices := PackedVector3Array([
		Vector3(-0.25, -0.25, 0),
		Vector3(0.25, -0.25, 0),
		Vector3(-0.25, 0.25, 0),
		Vector3(0.25, 0.25, 0),
		Vector3(-0.25, -0.25, 1),
		Vector3(0.25, -0.25, 1),
		Vector3(-0.25, 0.25, 1),
		Vector3(0.25, 0.25, 1),
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
