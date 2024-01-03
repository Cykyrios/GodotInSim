class_name InSimMSLPacket
extends InSimPacket


const PACKET_SIZE := 132
const PACKET_TYPE := InSim.Packet.ISP_MSL
const MSG_MAX_LENGTH := 128  # last byte must be zero, actual length is one character shorter

var sound := InSim.MessageSound.SND_SILENT

var msg := ""


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _get_data_dictionary() -> Dictionary:
	var data := {
		"Sound": sound,
		"Msg": msg,
	}
	return data


func _fill_buffer() -> void:
	super()
	add_byte(sound)
	if msg.length() >= MSG_MAX_LENGTH:
		msg = msg.left(MSG_MAX_LENGTH - 1)  # last byte must be zero
	add_string(MSG_MAX_LENGTH, msg)
	buffer.encode_u8(size - 1, 0)  # last byte must be zero
