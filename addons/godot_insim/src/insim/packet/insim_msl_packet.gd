class_name InSimMSLPacket
extends InSimPacket
## MSg Local packet - message to appear on local computer only
##
## This packet is sent to display a message only on the local client.

const PACKET_SIZE := 132  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_MSL  ## The packet's type, see [enum InSim.Packet].
const MSG_MAX_LENGTH := 128  # last byte must be zero, actual length is one character shorter

var sound := InSim.MessageSound.SND_SILENT  ## Sound effect (see [enum InSim.MessageSound])

var msg := ""  ## Message contents; last byte must be zero.


## Creates and returns a new [InSimMSLPacket] from the given parameters.
static func create(message: String, msg_sound := InSim.MessageSound.SND_SILENT) -> InSimMSLPacket:
	var packet := InSimMSLPacket.new()
	packet.msg = message
	packet.sound = msg_sound
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	if InSim.MessageSound.values().find(sound) == -1:
		sound = InSim.MessageSound.SND_SILENT
	add_byte(sound)
	msg = LFSText.lfs_bytes_to_unicode(add_string(MSG_MAX_LENGTH, msg))
	buffer.encode_u8(size - 1, 0)  # last byte must be zero


func _get_data_dictionary() -> Dictionary:
	return {
		"Sound": sound,
		"Msg": msg,
	}


func _get_pretty_text() -> String:
	return "(%s) %s" % [
		str(InSim.MessageSound.keys()[sound]) if (
			sound in InSim.MessageSound.values()
		) else "INVALID SOUND",
		msg,
	]
