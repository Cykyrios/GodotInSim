class_name SMXFile
extends LFSPacket


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
	lfssmx = read_string(buffer, 6)
	game_version = read_byte(buffer)
	game_revision = read_byte(buffer)
	smx_version = read_byte(buffer)
	if smx_version > 0:
		push_warning("SMX Version is not supported.")
		return
	dimensions = read_byte(buffer)
	resolution = read_byte(buffer)
	vertex_colors = read_byte(buffer)
	data_offset += 4  # zeros in header block
	track = read_string(buffer, 32)
	ground_color_red = read_byte(buffer)
	ground_color_green = read_byte(buffer)
	ground_color_blue = read_byte(buffer)
	data_offset += 9  # zeros in header block
	num_objects = read_int(buffer)
	objects.clear()
	for obj in num_objects:
		var object := SMXObject.new()
		object.centre_x = read_int(buffer)
		object.centre_y = read_int(buffer)
		object.centre_z = read_int(buffer)
		object.fill_centre_vector()
		object.radius = read_int(buffer)
		object.num_points = read_int(buffer)
		object.num_tris = read_int(buffer)
		for pt in object.num_points:
			var point := SMXPoint.new()
			point.x = read_int(buffer)
			point.y = read_int(buffer)
			point.z = read_int(buffer)
			point.fill_position_vector()
			point.buffer_color = read_unsigned(buffer)
			point.convert_color()
			object.points.append(point)
		for tri in object.num_tris:
			var triangle := SMXTriangle.new()
			triangle.vertex_a = read_word(buffer)
			triangle.vertex_b = read_word(buffer)
			triangle.vertex_c = read_word(buffer)
			triangle.zero = read_word(buffer)
			object.triangles.append(triangle)
		objects.append(object)
	num_cp = read_int(buffer)
	for cp in num_cp:
		cp_indices.append(read_int(buffer))
