class_name LYTFile
extends LFSPacket

## LYT file parser
##
## This class can read and write LFS layouts.

const HEADER_SIZE := 12

var header := ""
var version := 0
var revision := 0
var num_objects := 0
var laps := 0
var flags := 0
var objects: Array[LYTObject] = []


func read_from_path(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	var error := FileAccess.get_open_error()
	if error != OK:
		push_error("Error code %d occurred while opening file at %s" % [error, path])
		return
	buffer = file.get_buffer(file.get_length())
	header = read_string(6, false)
	version = read_byte()
	revision = read_byte()
	num_objects = read_word()
	laps = read_byte()
	flags = read_byte()
	if buffer.size() != HEADER_SIZE + num_objects * LYTObject.STRUCT_SIZE:
		push_error("LYT file data does not match object count (expected %d, found %d)" % [
				num_objects, int((buffer.size() - HEADER_SIZE) as float / LYTObject.STRUCT_SIZE)])
		return
	for i in num_objects:
		objects.append(LYTObject.create_from_buffer(read_buffer(LYTObject.STRUCT_SIZE)))


func write_to_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	var error := FileAccess.get_open_error()
	if error != OK:
		push_error("Failed to open file for writing: error %d" % [error])
		return
	resize_buffer(HEADER_SIZE + num_objects * LYTObject.STRUCT_SIZE)
	data_offset = 0
	var _discard := add_string(6, "LFSLYT", false)
	add_byte(version)
	add_byte(revision)
	add_word(num_objects)
	add_byte(laps)
	add_byte(flags)
	for i in num_objects:
		add_buffer(objects[i].get_buffer())
	if not file.store_buffer(buffer):
		push_error("Failed to write layout to file")
