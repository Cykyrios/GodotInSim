class_name InSimMSTPacket
extends InSimPacket
## MSg Type packet - send to LFS to type message or command
##
## This packet is sent to type a message or command.

const PACKET_SIZE := 68  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_MST  ## The packet's type, see [enum InSim.Packet].
## Maximum message length
const MSG_MAX_LENGTH := 64  # last byte must be zero, actual length is one character shorter

var msg := ""  ## Message contents; last byte must be zero.


## Creates and returns a new [InSimMSTPacket] with the given [param message].
static func create(message: String) -> InSimMSTPacket:
	var packet := InSimMSTPacket.new()
	packet.msg = message
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(0)  # zero
	msg = LFSText.lfs_bytes_to_unicode(add_string(MSG_MAX_LENGTH, msg))
	buffer.encode_u8(size - 1, 0)  # last byte must be zero


func _get_data_dictionary() -> Dictionary:
	return {
		"Msg": msg,
	}


func _get_pretty_text() -> String:
	return msg


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["Msg"]):
		return
	msg = dict["Msg"]
