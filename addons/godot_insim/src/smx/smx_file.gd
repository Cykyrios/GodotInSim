class_name SMXFile
extends LFSPacket

## SMX file parser
##
## This class can read SMX files in order to recreate the corresponding 3D models.

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


func read_from_path(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	var error := FileAccess.get_open_error()
	if error != OK:
		push_error("Error code %d occurred while opening file at %s" % [error, path])
		return
	buffer = file.get_buffer(file.get_length())
	lfssmx = read_string(6)
	game_version = read_byte()
	game_revision = read_byte()
	smx_version = read_byte()
	if smx_version > 0:
		push_warning("SMX Version is not supported.")
		return
	dimensions = read_byte()
	resolution = read_byte()
	vertex_colors = read_byte()
	data_offset += 4  # zeros in header block
	track = read_string(32)
	ground_color_red = read_byte()
	ground_color_green = read_byte()
	ground_color_blue = read_byte()
	data_offset += 9  # zeros in header block
	num_objects = read_int()
	objects.clear()
	for obj in num_objects:
		var object := SMXObject.new()
		object.centre_x = read_int()
		object.centre_y = read_int()
		object.centre_z = read_int()
		object.fill_centre_vector()
		object.radius = read_int()
		object.num_points = read_int()
		object.num_tris = read_int()
		for pt in object.num_points:
			var point := SMXPoint.new()
			point.x = read_int()
			point.y = read_int()
			point.z = read_int()
			point.fill_position_vector()
			point.buffer_color = read_unsigned()
			point.convert_color()
			object.points.append(point)
		for tri in object.num_tris:
			var triangle := SMXTriangle.new()
			triangle.vertex_a = read_word()
			triangle.vertex_b = read_word()
			triangle.vertex_c = read_word()
			triangle.zero = read_word()
			object.triangles.append(triangle)
		objects.append(object)
	num_cp = read_int()
	for cp in num_cp:
		cp_indices.append(read_int())
