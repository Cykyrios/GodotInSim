class_name PTHFile
extends LFSPacket


var lfspth := ""
var version := 0
var revision := 0
var num_nodes := 0
var finish_line := 0
var path_nodes: Array[PathNode] = []


func read_from_path(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	var error := FileAccess.get_open_error()
	if error != OK:
		push_error("Error code %d occurred while opening file at %s" % [error, path])
		return
	buffer = file.get_buffer(file.get_length())
	lfspth = read_string(buffer, 6)
	version = read_byte(buffer)
	revision = read_byte(buffer)
	if version > 0 or revision > 0:
		push_warning("PTH Version/Revision is not supported.")
		return
	num_nodes = read_int(buffer)
	finish_line = read_int(buffer)
	path_nodes.clear()
	for i in num_nodes:
		var path_node := PathNode.new()
		path_node.centre_x = read_int(buffer)
		path_node.centre_y = read_int(buffer)
		path_node.centre_z = read_int(buffer)
		path_node.dir_x = read_float(buffer)
		path_node.dir_y = read_float(buffer)
		path_node.dir_z = read_float(buffer)
		path_node.limit_left = read_float(buffer)
		path_node.limit_right = read_float(buffer)
		path_node.drive_left = read_float(buffer)
		path_node.drive_right = read_float(buffer)
		path_nodes.append(path_node)
