class_name LYTObjectConcrete
extends LYTObject

## LYT control object
##
## Specific layout object representing a concrete object.

enum ConcreteColor {
	GREY,
	RED,
	BLUE,
	YELLOW,
}

const COLORS: Array[Color] = [
	Color.GRAY,
	Color.DARK_RED,
	Color.DARK_BLUE,
	Color.DARK_GOLDENROD,
]
const THICKNESS := 0.25
const WALL_HEIGHT := 0.75

var width := 0:
	set(value):
		width = value
		gis_width = pow(2, value + 1)
var length := 0:
	set(value):
		length = value
		gis_length = pow(2, value + 1)
var size_x := 0:
	set(value):
		size_x = value
		gis_size_x = 0.25 * (value + 1)
var size_y := 0:
	set(value):
		size_y = value
		gis_size_y = 0.25 * (value + 1)
var height := 0:
	set(value):
		height = value
		gis_height = 0.25 * (value + 1)
var pitch := 0:
	set(value):
		pitch = value
		gis_pitch = deg_to_rad(6 * value)
var color := ConcreteColor.GREY
var angle := 0:
	set(value):
		angle = value
		gis_angle = deg_to_rad(5.625 * (value + 1))

var gis_width := 0.0
var gis_length := 0.0
var gis_size_x := 0.0
var gis_size_y := 0.0
var gis_height := 0.0
var gis_pitch := 0.0
var gis_angle := 0.0


static func create(
	obj_x: int, obj_y: int, obj_z: int, obj_heading: int, obj_flags: int, obj_index: int
) -> LYTObjectConcrete:
	var object := super(obj_x, obj_y, obj_z, obj_heading, obj_flags, obj_index)
	var concrete_object := LYTObjectConcrete.new()
	concrete_object.set_from_buffer(object.get_buffer())
	if concrete_object.index in [
		InSim.AXOIndex.AXO_CONCRETE_SLAB,
		InSim.AXOIndex.AXO_CONCRETE_RAMP,
	]:
		concrete_object.width = (concrete_object.flags & 0x03) >> 0
	if concrete_object.index in [
		InSim.AXOIndex.AXO_CONCRETE_SLAB,
		InSim.AXOIndex.AXO_CONCRETE_RAMP,
		InSim.AXOIndex.AXO_CONCRETE_WALL,
		InSim.AXOIndex.AXO_CONCRETE_SLAB_WALL,
		InSim.AXOIndex.AXO_CONCRETE_RAMP_WALL,
		InSim.AXOIndex.AXO_CONCRETE_WEDGE,
	]:
		concrete_object.length = (concrete_object.flags & 0x0c) >> 2
	if concrete_object.index in [
		InSim.AXOIndex.AXO_CONCRETE_PILLAR,
	]:
		concrete_object.size_x = (concrete_object.flags & 0x03) >> 0
	if concrete_object.index in [
		InSim.AXOIndex.AXO_CONCRETE_PILLAR,
		InSim.AXOIndex.AXO_CONCRETE_SHORT_SLAB_WALL,
	]:
		concrete_object.size_y = (concrete_object.flags & 0x0c) >> 2
	if concrete_object.index in [
		InSim.AXOIndex.AXO_CONCRETE_RAMP,
		InSim.AXOIndex.AXO_CONCRETE_WALL,
		InSim.AXOIndex.AXO_CONCRETE_PILLAR,
		InSim.AXOIndex.AXO_CONCRETE_RAMP_WALL,
	]:
		concrete_object.height = (concrete_object.flags & 0xf0) >> 4
	if concrete_object.index in [
		InSim.AXOIndex.AXO_CONCRETE_SLAB,
		InSim.AXOIndex.AXO_CONCRETE_SLAB_WALL,
		InSim.AXOIndex.AXO_CONCRETE_SHORT_SLAB_WALL,
	]:
		concrete_object.pitch = (concrete_object.flags & 0xf0) >> 4
	if concrete_object.index in [
		InSim.AXOIndex.AXO_CONCRETE_WALL,
		InSim.AXOIndex.AXO_CONCRETE_SLAB_WALL,
		InSim.AXOIndex.AXO_CONCRETE_RAMP_WALL,
		InSim.AXOIndex.AXO_CONCRETE_SHORT_SLAB_WALL,
		InSim.AXOIndex.AXO_CONCRETE_WEDGE,
	]:
		concrete_object.color = (concrete_object.flags & 0x03) >> 0 as ConcreteColor
	if concrete_object.index in [
		InSim.AXOIndex.AXO_CONCRETE_WEDGE,
	]:
		concrete_object.angle = (concrete_object.flags & 0xf0) >> 4
	return concrete_object


func _get_mesh() -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var mesh := ArrayMesh.new()
	var arrays := []
	var _resize := arrays.resize(Mesh.ARRAY_MAX)
	var vertices := PackedVector3Array()
	var indices := PackedInt32Array()
	# Vertices are defined with axis order XYZ (X increases first, then Y, then Z)
	if index == InSim.AXOIndex.AXO_CONCRETE_RAMP:
		vertices = PackedVector3Array([
			Vector3(-0.5 * gis_width, -0.5 * gis_length, -THICKNESS),
			Vector3(0.5 * gis_width, -0.5 * gis_length, -THICKNESS),
			Vector3(-0.5 * gis_width, -0.5 * gis_length + 0.125, -THICKNESS),
			Vector3(0.5 * gis_width, -0.5 * gis_length + 0.125, -THICKNESS),
			Vector3(-0.5 * gis_width, 0.5 * gis_length + 0.125, gis_height - THICKNESS),
			Vector3(0.5 * gis_width, 0.5 * gis_length + 0.125, gis_height - THICKNESS),
			Vector3(-0.5 * gis_width, -0.5 * gis_length, 0),
			Vector3(0.5 * gis_width, -0.5 * gis_length, 0),
			Vector3(-0.5 * gis_width, 0.5 * gis_length, gis_height),
			Vector3(0.5 * gis_width, 0.5 * gis_length, gis_height),
			Vector3(-0.5 * gis_width, 0.5 * gis_length + 0.125, gis_height),
			Vector3(0.5 * gis_width, 0.5 * gis_length + 0.125, gis_height),
		])
		# Bottom faces first, even if "bottom upper edge" higher along Z than "top lower edge"
		indices = PackedInt32Array([
			0, 1, 2,  # bottom ledge
			3, 2, 1,
			2, 3, 4,  # Z- face
			5, 4, 3,
			8, 7, 6,  # Z+ face
			7, 8, 9,
			10, 9, 8,  # top ledge
			9, 10, 11,
			6, 1, 0,  # Y- face
			1, 6, 7,
			4, 5, 10,  # Y+ face
			11, 10, 5,
			0, 2, 6,  # X- face
			2, 4, 6,
			8, 6, 4,
			10, 8, 4,
			7, 3, 1,  # X+ face
			7, 5, 3,
			5, 7, 9,
			5, 9, 11,
		])
	elif index == InSim.AXOIndex.AXO_CONCRETE_WEDGE:
		vertices = PackedVector3Array([
			Vector3(0, 0, 0),
			Vector3(gis_length, 0, 0),
			Vector3(gis_length * cos(gis_angle), gis_length * sin(gis_angle), 0),
			Vector3(0, 0, THICKNESS),
			Vector3(gis_length, 0, THICKNESS),
			Vector3(gis_length * cos(gis_angle), gis_length * sin(gis_angle), THICKNESS),
		])
		indices = PackedInt32Array([
			0, 1, 2,  # Z- face
			5, 4, 3,  # Z+ face
			3, 1, 0,  # Y- face
			1, 3, 4,
			0, 2, 3,  # X- face
			5, 3, 2,
			4, 2, 1,  # X+ face
			2, 4, 5,
		])
	else:
		if index == InSim.AXOIndex.AXO_CONCRETE_SLAB:
			vertices = PackedVector3Array([
				Vector3(-0.5 * gis_width, -0.5 * gis_length, 0),
				Vector3(0.5 * gis_width, -0.5 * gis_length, 0),
				Vector3(-0.5 * gis_width, 0.5 * gis_length, 0),
				Vector3(0.5 * gis_width, 0.5 * gis_length, 0),
				Vector3(-0.5 * gis_width, -0.5 * gis_length, THICKNESS),
				Vector3(0.5 * gis_width, -0.5 * gis_length, THICKNESS),
				Vector3(-0.5 * gis_width, 0.5 * gis_length, THICKNESS),
				Vector3(0.5 * gis_width, 0.5 * gis_length, THICKNESS),
			])
			for i in vertices.size():
				vertices[i] = vertices[i].rotated(Vector3(1, 0, 0), gis_pitch)
		elif index == InSim.AXOIndex.AXO_CONCRETE_WALL:
			vertices = PackedVector3Array([
				Vector3(-0.5 * THICKNESS, -0.5 * gis_length, 0),
				Vector3(0.5 * THICKNESS, -0.5 * gis_length, 0),
				Vector3(-0.5 * THICKNESS, 0.5 * gis_length, 0),
				Vector3(0.5 * THICKNESS, 0.5 * gis_length, 0),
				Vector3(-0.5 * THICKNESS, -0.5 * gis_length, gis_height),
				Vector3(0.5 * THICKNESS, -0.5 * gis_length, gis_height),
				Vector3(-0.5 * THICKNESS, 0.5 * gis_length, gis_height),
				Vector3(0.5 * THICKNESS, 0.5 * gis_length, gis_height),
			])
		elif index == InSim.AXOIndex.AXO_CONCRETE_PILLAR:
			vertices = PackedVector3Array([
				Vector3(-0.5 * gis_size_x, -0.5 * gis_size_y, 0),
				Vector3(0.5 * gis_size_x, -0.5 * gis_size_y, 0),
				Vector3(-0.5 * gis_size_x, 0.5 * gis_size_y, 0),
				Vector3(0.5 * gis_size_x, 0.5 * gis_size_y, 0),
				Vector3(-0.5 * gis_size_x, -0.5 * gis_size_y, gis_height),
				Vector3(0.5 * gis_size_x, -0.5 * gis_size_y, gis_height),
				Vector3(-0.5 * gis_size_x, 0.5 * gis_size_y, gis_height),
				Vector3(0.5 * gis_size_x, 0.5 * gis_size_y, gis_height),
			])
		elif (
			index == InSim.AXOIndex.AXO_CONCRETE_SLAB_WALL
			or index == InSim.AXOIndex.AXO_CONCRETE_SHORT_SLAB_WALL
		):
			var wall_length := gis_size_y if index == InSim.AXOIndex.AXO_CONCRETE_SHORT_SLAB_WALL \
					else gis_length
			vertices = PackedVector3Array([
				Vector3(-0.5 * THICKNESS, -0.5 * wall_length, 0),
				Vector3(0.5 * THICKNESS, -0.5 * wall_length, 0),
				Vector3(-0.5 * THICKNESS, 0.5 * wall_length, 0),
				Vector3(0.5 * THICKNESS, 0.5 * wall_length, 0),
				Vector3(-0.5 * THICKNESS, -0.5 * wall_length, WALL_HEIGHT),
				Vector3(0.5 * THICKNESS, -0.5 * wall_length, WALL_HEIGHT),
				Vector3(-0.5 * THICKNESS, 0.5 * wall_length, WALL_HEIGHT),
				Vector3(0.5 * THICKNESS, 0.5 * wall_length, WALL_HEIGHT),
			])
			for i in vertices.size():
				vertices[i] = vertices[i].rotated(Vector3(1, 0, 0), gis_pitch)
		elif index == InSim.AXOIndex.AXO_CONCRETE_RAMP_WALL:
			vertices = PackedVector3Array([
				Vector3(-0.5 * THICKNESS, -0.5 * gis_length, 0),
				Vector3(0.5 * THICKNESS, -0.5 * gis_length, 0),
				Vector3(-0.5 * THICKNESS, 0.5 * gis_length, gis_height),
				Vector3(0.5 * THICKNESS, 0.5 * gis_length, gis_height),
				Vector3(-0.5 * THICKNESS, -0.5 * gis_length, WALL_HEIGHT),
				Vector3(0.5 * THICKNESS, -0.5 * gis_length, WALL_HEIGHT),
				Vector3(-0.5 * THICKNESS, 0.5 * gis_length, WALL_HEIGHT + gis_height),
				Vector3(0.5 * THICKNESS, 0.5 * gis_length, WALL_HEIGHT + gis_height),
			])
		indices = PackedInt32Array([
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
	mat.albedo_color = COLORS[color]
	mesh.surface_set_material(0, mat)
	return mesh_instance


func _update_flags() -> void:
	match index:
		InSim.AXOIndex.AXO_CONCRETE_SLAB:
			flags = (flags & ~0x03) | width
			flags = (flags & ~(0x0c >> 2)) | (length << 2)
			flags = (flags & ~(0xf0 >> 4)) | (pitch << 4)
		InSim.AXOIndex.AXO_CONCRETE_RAMP:
			flags = (flags & ~0x03) | width
			flags = (flags & ~(0x0c >> 2)) | (length << 2)
			flags = (flags & ~(0xf0 >> 4)) | (height << 4)
		InSim.AXOIndex.AXO_CONCRETE_WALL:
			flags = (flags & ~0x03) | color
			flags = (flags & ~(0x0c >> 2)) | (length << 2)
			flags = (flags & ~(0xf0 >> 4)) | (height << 4)
		InSim.AXOIndex.AXO_CONCRETE_PILLAR:
			flags = (flags & ~0x03) | size_x
			flags = (flags & ~(0x0c >> 2)) | (size_y << 2)
			flags = (flags & ~(0xf0 >> 4)) | (height << 4)
		InSim.AXOIndex.AXO_CONCRETE_SLAB_WALL:
			flags = (flags & ~0x03) | color
			flags = (flags & ~(0x0c >> 2)) | (length << 2)
			flags = (flags & ~(0xf0 >> 4)) | (pitch << 4)
		InSim.AXOIndex.AXO_CONCRETE_RAMP_WALL:
			flags = (flags & ~0x03) | color
			flags = (flags & ~(0x0c >> 2)) | (length << 2)
			flags = (flags & ~(0xf0 >> 4)) | (height << 4)
		InSim.AXOIndex.AXO_CONCRETE_SHORT_SLAB_WALL:
			flags = (flags & ~0x03) | color
			flags = (flags & ~(0x0c >> 2)) | (size_y << 2)
			flags = (flags & ~(0xf0 >> 4)) | (pitch << 4)
		InSim.AXOIndex.AXO_CONCRETE_WEDGE:
			flags = (flags & ~0x03) | color
			flags = (flags & ~(0x0c >> 2)) | (length << 2)
			flags = (flags & ~(0xf0 >> 4)) | (angle << 4)


func _update_flags_from_gis() -> void:
	width = roundi(sqrt(gis_width) - 1)
	length = roundi(sqrt(gis_length) - 1)
	size_x = roundi(gis_size_x / 0.25 - 1)
	size_y = roundi(gis_size_y / 0.25 - 1)
	height = roundi(gis_height / 0.25 - 1)
	angle = roundi(gis_angle / 5.625 - 1)
	pitch = roundi(rad_to_deg(gis_pitch) / 6.0)
