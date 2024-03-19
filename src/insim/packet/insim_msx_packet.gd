class_name InSimMSXPacket
extends InSimPacket

## MSg eXtended packet - like [InSimMSTPacket] but longer (not for commands)

const PACKET_SIZE := 100
const PACKET_TYPE := InSim.Packet.ISP_MSX
const MSG_MAX_LENGTH := 96  # last byte must be zero, actual length is one character shorter

var zero := 0

var msg := ""  ## last byte must be zero


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	if msg.length() >= MSG_MAX_LENGTH:
		msg = msg.left(MSG_MAX_LENGTH - 1)  # last byte must be zero
	add_string(MSG_MAX_LENGTH, msg)
	buffer.encode_u8(size - 1, 0)  # last byte must be zero


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"Msg": msg,
	}
