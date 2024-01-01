class_name InSimMSTPacket
extends InSimPacket


const MSG_MAX_LENGTH := 64  # last byte must be zero, actual length is one character shorter

var msg := ""


func _init() -> void:
	size = 68
	type = InSim.Packet.ISP_MST
	super()


func _get_data_dictionary() -> Dictionary:
	var data := {
		"Msg": msg,
	}
	return data


func _fill_buffer() -> void:
	data_offset = HEADER_SIZE
	if msg.length() >= MSG_MAX_LENGTH:
		msg = msg.left(MSG_MAX_LENGTH - 1)  # last byte must be zero
	add_string(MSG_MAX_LENGTH, msg)
	buffer.encode_u8(size - 1, 0)  # last byte must be zero
