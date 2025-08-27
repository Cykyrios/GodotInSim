class_name LYTFile
extends LFSPacket
## LYT file parser
##
## This class can read and write LFS layouts.

const HEADER_SIZE := 12  ## LYT header data size
const CURRENT_VERSION := 0  ## File format version
const CURRENT_REVISION := 252  ## File format revision

var header := ""  ## Header, always equalto LFSLYT
var version := 0  ## File format version
var revision := 0  ## File format revision
var num_objects := 0  ## Number of objects in the layout
var laps := 0  ## Number of laps
var flags := 0  ## Layout flags, always equal to 7 for recent files.
var objects: Array[LYTObject] = []  ## An array containing the objects in the layout.


## Reads the layout file at [param path] and returns a [LYTFile] object. Objects in the layout
## are made into specific [LYTObject] subtypes if their index matches specific object types.
static func load_from_file(path: String) -> LYTFile:
	var file := FileAccess.open(path, FileAccess.READ)
	var error := FileAccess.get_open_error()
	if error != OK:
		push_error("Error code %d occurred while opening file at %s" % [error, path])
		return LYTFile.new()
	var layout := LYTFile.new()
	layout.buffer = file.get_buffer(file.get_length())
	layout.header = layout.read_string(6, false)
	layout.version = layout.read_byte()
	layout.revision = layout.read_byte()
	layout.num_objects = layout.read_word()
	layout.laps = layout.read_byte()
	layout.flags = layout.read_byte()
	if (
		layout.header != "LFSLYT"
		or layout.version > CURRENT_VERSION
		or layout.revision > CURRENT_REVISION
	):
		push_error("Invalid file header")
		return layout
	if layout.buffer.size() != HEADER_SIZE + layout.num_objects * LYTObject.STRUCT_SIZE:
		push_error("LYT file data does not match object count (expected %d, found %d)" % [
			layout.num_objects,
			int((layout.buffer.size() - HEADER_SIZE) as float / LYTObject.STRUCT_SIZE)
		])
		return layout
	for i in layout.num_objects:
		layout.objects.append(
			LYTObject.create_from_buffer(layout.read_buffer(LYTObject.STRUCT_SIZE))
		)
	return layout


## Returns an array of [InSimAXMPacket] containing the layout data, to be sent and added to LFS.
func get_axm_packets(ucid := 0) -> Array[InSimAXMPacket]:
	var axm_packets: Array[InSimAXMPacket] = []
	for i in int(objects.size() as float / InSimAXMPacket.MAX_OBJECTS) + 1:
		var packet_objects: Array[ObjectInfo] = []
		for o in InSimAXMPacket.MAX_OBJECTS:
			var object_idx := i * InSimAXMPacket.MAX_OBJECTS + o
			if object_idx >= objects.size():
				break
			var object := objects[object_idx]
			packet_objects.append(ObjectInfo.create(
				object.x, object.y, object.z, object.heading, object.flags, object.index
			))
		var packet := InSimAXMPacket.create(
			packet_objects.size(),
			ucid,
			InSim.PMOAction.PMO_ADD_OBJECTS,
			0,
			packet_objects
		)
		axm_packets.append(packet)
	return axm_packets


## Saves the layout to a file at [param path]. Forces [member flags] to indicate the most recent
## format (bits 0, 1 and 2 set).
func save_to_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	var error := FileAccess.get_open_error()
	if error != OK:
		push_error("Failed to open file for writing: error %d" % [error])
		return
	version = CURRENT_VERSION
	revision = CURRENT_REVISION
	flags = (flags & ~0b111) | 7
	resize_buffer(HEADER_SIZE + num_objects * LYTObject.STRUCT_SIZE)
	data_offset = 0
	var _discard := add_string(6, "LFSLYT", false)
	add_byte(version)
	add_byte(revision)
	add_word(num_objects)
	add_byte(laps)
	add_byte(flags)
	for i in num_objects:
		objects[i].update_flags()
		add_buffer(objects[i].get_buffer())
	if not file.store_buffer(buffer):
		push_error("Failed to write layout to file")
