class_name InSimMSXPacket
extends InSimPacket
## MSg eXtended packet - like [InSimMSTPacket] but longer (not for commands)
##
## This packet is sent to type longer messages than [InSimMSTPacket], but doesn't work for commands.

const PACKET_SIZE := 100  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_MSX  ## The packet's type, see [enum InSim.Packet].
## Maximum message length
const MSG_MAX_LENGTH := 96  # last byte must be zero, actual length is one character shorter

var zero := 0  ## Zero byte

var msg := ""  ## Message contents; last byte must be zero.


## Creates and returns a new [InSimMSXPacket] with the given [param message].
static func create(message: String) -> InSimMSXPacket:
	var packet := InSimMSXPacket.new()
	packet.msg = message
	return packet


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
	return msg
