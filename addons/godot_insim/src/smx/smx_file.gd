class_name SMXFile
extends LFSPacket
## SMX file parser
##
## This class can read SMX files in order to recreate the corresponding 3D models, and can also
## save SMX data to files.

## The SMX header size.
const HEADER_SIZE := 64
## The SMX footer size (containing checkpoint data).
const FOOTER_SIZE := 4

## First part of the header, should always be equal to [code]LFSSMX[/code].
var lfssmx := ""
## Used to determine file validity.
var game_version := 0
## Used to determine file validity.
var game_revision := 0
## Used to determine file validity.
var smx_version := 0
## Always 3.
var dimensions := 0
## High/low resolution.
var resolution := 0
## Always 1.
var vertex_colors := 0
## The track environment's name.
var track := ""
## Ground color red component.
var ground_color_red := 0
## Ground color green component.
var ground_color_green := 0
## Ground color blue component.
var ground_color_blue := 0
## The number of objects included in the file.
var num_objects := 0

## The number of checkpoint objects.
var num_cp := 0
## The indices of each checkpoint.
var cp_indices: Array[int] = []

## The objects included in the file.
var objects: Array[SMXObject] = []

## The triangle mesh built from the data in this file.
var triangle_mesh := TriangleMesh.new()


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
		mesh.surface_set_material(0, mat)
	return track_mesh


## Performs a raycast query against the SMX mesh and, if an intersection is found, updates
## the [param mesh]'s position and orientation to match the ground's altitude and normal direction.
## The base position of the raycast is determined by the [param object]'s position.[br]
## [br]
## [b]Note:[/b] A check for the non-floating status of the [param object] should be performed
## prior to calling this function; as a reminder, concrete objects are always floating, and
## other objects should only be checked for ground contact if they do not have the
## [code]0x80[/code] bit set in their [member LYTObject.flags].
func place_object_on_ground(mesh: MeshInstance3D, object: LYTObject) -> void:
	var raycast_result := raycast_from_position(object.gis_position)
	if not raycast_result.is_empty():
		mesh.position = raycast_result["position"]
		var normal := raycast_result["normal"] as Vector3
		var basis_x := Vector3(1, 0, 0).rotated(Vector3(0, 0, 1), object.gis_heading)
		var basis_z := normal if normal.dot(Vector3(0, 0, 1)) > 0 else -normal
		var basis_y := basis_z.cross(basis_x)
		basis_x = basis_y.cross(basis_z)
		mesh.basis = Basis(basis_x, basis_y, basis_z)


## Casts a ray from [param position] to check for intersection with the SMX mesh. Casts the ray
## down first (along -Z) from 2 meters above the given [param position] (as per LFS documentation
## for the LYT format), then up if no intersection is found. Returns a [Dictionary]
## with the intersection location (if any) and the corresponding face normal.[br]
## See [method TriangleMesh.intersect_ray] for details.
func raycast_from_position(position: Vector3) -> Dictionary:
	if not triangle_mesh:
		update_triangle_mesh()
	var result := triangle_mesh.intersect_ray(position + Vector3(0, 0, 2), Vector3(0, 0, -1))
	if result.is_empty():
		result = triangle_mesh.intersect_ray(position, Vector3(0, 0, 1))
	return result


## Saves the [SMXFile] to [param path]. This is mainly intended for modifying or creating new
## SMX meshes.
func save_to_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if not file:
		push_error("Failed to open file for writing: error %d" % [FileAccess.get_open_error()])
		return
	var objects_size := 0
	for object in objects:
		objects_size += (
			SMXObject.STRUCT_SIZE
			+ object.num_tris * SMXTriangle.STRUCT_SIZE
			+ object.num_points * SMXPoint.STRUCT_SIZE
		)
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


## Updates the [TriangleMesh] corresponding to the currently loaded [SMXFile]. This is required
## for raycast queries such as [method raycast_from_position].
func update_triangle_mesh() -> void:
	var mesh := get_mesh()
	var triangles := PackedVector3Array()
	for mesh_instance: MeshInstance3D in mesh.get_children():
		triangles.append_array(mesh_instance.mesh.get_faces())
	var success := triangle_mesh.create_from_faces(triangles)
	if not success:
		push_error("Failed to build BVH for SMX file.")
