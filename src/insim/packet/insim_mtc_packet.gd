class_name InSimMTCPacket
extends InSimPacket

## Msg To Connection packet - hosts only - send to a connection / a player / all

const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := 136
const PACKET_TYPE := InSim.Packet.ISP_MTC
const TEXT_MAX_LENGTH := 128  # last byte must be zero, actual length is one character shorter

var sound := InSim.MessageSound.SND_SILENT  ## sound effect (see [enum InSim.MessageSound])

var ucid := 0  ## connection's unique id (0 = host / 255 = all)
var player_id := 0  ## player's unique id (if zero, use [member ucid])
var sp2 := 0
var sp3 := 0

var text := ""  ## up to 128 characters of text - last byte must be zero


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(sound)
	add_byte(ucid)
	add_byte(player_id)
	add_byte(sp2)
	add_byte(sp3)
	add_string_variable_length(text, TEXT_MAX_LENGTH, SIZE_MULTIPLIER)
	trim_packet_size()


func _get_data_dictionary() -> Dictionary:
	return {
		"Sound": sound,
		"UCID": ucid,
		"PLID": player_id,
		"Sp2": sp2,
		"Sp3": sp3,
		"Text": text,
	}


func trim_packet_size() -> void:
	for i in TEXT_MAX_LENGTH:
		if buffer[PACKET_MAX_SIZE - i - 1] != 0:
			size = PACKET_MAX_SIZE - i + 1  # + 1 to keep final zero
			resize_buffer(size)
			break
