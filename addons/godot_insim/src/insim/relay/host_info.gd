class_name HostInfo
extends InSimStruct
## Host Info struct
##
## This class contains host data for use with InSim Relay.

const STRUCT_SIZE := 40  ## The size of this struct's data

const HOST_NAME_LENGTH := 32  ## The maximum host name length
const TRACK_NAME_LENGTH := 6  ## The maximum length of a track's name

var host_name := ""  ## Host name
var track := ""  ## Track name
var flags := 0  ## Flags
var num_conns := 0  ## Number of connections


func _to_string() -> String:
	return "HName:%s, Track:%s, Flags:%d, NumConns:%d" % [host_name, track, flags, num_conns]


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	var data_offset := 0
	host_name = LFSText.lfs_bytes_to_unicode(buffer.slice(data_offset, data_offset + HOST_NAME_LENGTH))
	data_offset += HOST_NAME_LENGTH
	track = LFSText.lfs_bytes_to_unicode(buffer.slice(data_offset, data_offset + TRACK_NAME_LENGTH))
	data_offset += TRACK_NAME_LENGTH
	flags = buffer.decode_u8(data_offset)
	data_offset += 1
	num_conns = buffer.decode_u8(data_offset)
