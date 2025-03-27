class_name InSimMSTPacket
extends InSimPacket

## MSg Type packet - send to LFS to type message or command

const PACKET_SIZE := 68
const PACKET_TYPE := InSim.Packet.ISP_MST
const MSG_MAX_LENGTH := 64  # last byte must be zero, actual length is one character shorter

var zero := 0

var msg := ""  ## last byte must be zero


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	msg = LFSText.lfs_bytes_to_unicode(add_string(MSG_MAX_LENGTH, msg))
	buffer.encode_u8(size - 1, 0)  # last byte must be zero


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"Msg": msg,
	}


func _get_pretty_text() -> String:
	return LFSText.lfs_colors_to_bbcode(msg)


static func create(message: String) -> InSimMSTPacket:
	var packet := InSimMSTPacket.new()
	packet.msg = message
	return packet
