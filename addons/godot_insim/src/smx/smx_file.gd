class_name SMXFile
extends LFSPacket

## SMX file parser
##
## This class can read SMX files in order to recreate the corresponding 3D models.

const HEADER_SIZE := 64
const FOOTER_SIZE := 4

var lfssmx := ""
var game_version := 0
var game_revision := 0
var smx_version := 0
var dimensions := 0
var resolution := 0
var vertex_colors := 0
var track := ""
var ground_color_red := 0
var ground_color_green := 0
var ground_color_blue := 0
var num_objects := 0

var num_cp := 0
var cp_indices: Array[int] = []

var objects: Array[SMXObject] = []


## Creates and returns a [SMXFile] from the file at [param path]. An empty [SMXFile] is returned
## if the file cannot be loaded.
static func load_from_file(path: String) -> SMXFile:
	var file := FileAccess.open(path, FileAccess.READ)
	var error := FileAccess.get_open_error()
	if error != OK:
		push_error("Error code %d occurred while opening file at %s" % [error, path])
		return
	var smx := SMXFile.new()
	smx.buffer = file.get_buffer(file.get_length())
	smx.lfssmx = smx.read_string(6)
	smx.game_version = smx.read_byte()
	smx.game_revision = smx.read_byte()
	smx.smx_version = smx.read_byte()
	if smx.smx_version > 0:
		push_warning("SMX Version is not supported.")
		return
	smx.dimensions = smx.read_byte()
	smx.resolution = smx.read_byte()
	smx.vertex_colors = smx.read_byte()
	smx.data_offset += 4  # zeros in header block
	smx.track = smx.read_string(32)
	smx.ground_color_red = smx.read_byte()
	smx.ground_color_green = smx.read_byte()
	smx.ground_color_blue = smx.read_byte()
	smx.data_offset += 9  # zeros in header block
	smx.num_objects = smx.read_int()
	smx.objects.clear()
	for obj in smx.num_objects:
		var object := SMXObject.new()
		object.centre_x = smx.read_int()
		object.centre_y = smx.read_int()
		object.centre_z = smx.read_int()
		object.fill_centre_vector()
		object.radius = smx.read_int()
		object.num_points = smx.read_int()
		object.num_tris = smx.read_int()
		for pt in object.num_points:
			var point := SMXPoint.new()
			point.x = smx.read_int()
			point.y = smx.read_int()
			point.z = smx.read_int()
			point.fill_position_vector()
			point.buffer_color = smx.read_unsigned()
			point.convert_color()
			object.points.append(point)
		for tri in object.num_tris:
			var triangle := SMXTriangle.new()
			triangle.vertex_a = smx.read_word()
			triangle.vertex_b = smx.read_word()
			triangle.vertex_c = smx.read_word()
			triangle.zero = smx.read_word()
			object.triangles.append(triangle)
		smx.objects.append(object)
	smx.num_cp = smx.read_int()
	for cp in smx.num_cp:
		smx.cp_indices.append(smx.read_int())
	return smx


## Returns a [Node3D] with [MeshInstance3D] children for each object in the [SMXFile].
func get_mesh() -> Node3D:
	var track_mesh := Node3D.new()
	track_mesh.name = track
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.vertex_color_is_srgb = true
	var mesh_instance: MeshInstance3D = null
	var mesh: ArrayMesh = null
	for i in num_objects:
		var object := objects[i]
		if object.num_tris == 0:
			continue
		mesh_instance = MeshInstance3D.new()
		track_mesh.add_child(mesh_instance)
		mesh = ArrayMesh.new()
		mesh_instance.mesh = mesh
		var points := object.points
		var arrays := []
		var _resize := arrays.resize(Mesh.ARRAY_MAX)
		var vertices := PackedVector3Array()
		var colors := PackedColorArray()
		for triangle in object.triangles:
			var _discard := vertices.push_back(points[triangle.vertex_a].position)
			_discard = vertices.push_back(points[triangle.vertex_c].position)
			_discard = vertices.push_back(points[triangle.vertex_b].position)
			_discard = colors.push_back(points[triangle.vertex_a].color)
			_discard = colors.push_back(points[triangle.vertex_c].color)
			_discard = colors.push_back(points[triangle.vertex_b].color)
		arrays[Mesh.ARRAY_VERTEX] = vertices
		arrays[Mesh.ARRAY_COLOR] = colors
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		mesh.surface_set_material(mesh.get_surface_count() - 1, mat)
	return track_mesh


## Saves the [SMXFile] to [param path]. This is mainly intended for modifying or creating new
## SMX meshes.
func save_to_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if not file:
		push_error("Failed to open file for writing: error %d" % [FileAccess.get_open_error()])
		return
	var objects_size := 0
	for object in objects:
		objects_size += SMXObject.STRUCT_SIZE + object.num_tris * SMXTriangle.STRUCT_SIZE \
				+ object.num_points * SMXPoint.STRUCT_SIZE
	resize_buffer(HEADER_SIZE + objects_size + FOOTER_SIZE + 4 * num_cp)
	var _string := add_string(6, "LFSSMX", false)
	add_byte(game_version)
	add_byte(game_revision)
	add_byte(smx_version)
	add_byte(dimensions)
	add_byte(resolution)
	add_byte(vertex_colors)
	add_buffer([0, 0, 0, 0])
	_string = add_string(32, track, false)
	add_byte(ground_color_red)
	add_byte(ground_color_green)
	add_byte(ground_color_blue)
	add_buffer([0, 0, 0, 0, 0, 0, 0, 0, 0])
	add_int(num_objects)
	for object in objects:
		object.fill_xyz()
		add_int(object.centre_x)
		add_int(object.centre_y)
		add_int(object.centre_z)
		add_int(object.radius)
		add_int(object.num_points)
		add_int(object.num_tris)
		for point in object.points:
			point.fill_xyz()
			point.color_to_buffer_color()
			add_int(point.x)
			add_int(point.y)
			add_int(point.z)
			add_unsigned(point.buffer_color)
		for triangle in object.triangles:
			add_word(triangle.vertex_a)
			add_word(triangle.vertex_b)
			add_word(triangle.vertex_c)
			add_word(0)
	add_int(num_cp)
	for cp in cp_indices:
		add_int(cp)
	var success := file.store_buffer(buffer)
	if not success:
		push_error("Failed to write SMX data to file.")
