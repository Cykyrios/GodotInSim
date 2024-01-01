class_name InSimMTCPacket
extends InSimPacket


const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := 136
const PACKET_TYPE := InSim.Packet.ISP_MTC
const TEXT_MAX_LENGTH := 128  # last byte must be zero, actual length is one character shorter

var sound := InSim.Sound.SND_SILENT

var ucid := 0
var player_id := 0
var sp2 := 0
var sp3 := 0

var text := ""


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE


func _get_data_dictionary() -> Dictionary:
	var data := {
		"Sound": sound,
		"UCID": ucid,
		"PLID": player_id,
		"Sp2": sp2,
		"Sp3": sp3,
		"Text": text,
	}
	return data


func _fill_buffer() -> void:
	super()
	add_byte(sound)
	add_byte(ucid)
	add_byte(player_id)
	add_byte(sp2)
	add_byte(sp3)
	var text_length := text.length()
	if text_length >= TEXT_MAX_LENGTH:
		text = text.left(TEXT_MAX_LENGTH - 1)  # last byte must be zero
		text_length = TEXT_MAX_LENGTH
	var remainder := text_length % SIZE_MULTIPLIER
	text_length += remainder
	if remainder == 0 and text_length < TEXT_MAX_LENGTH:
		text_length += SIZE_MULTIPLIER
	add_string(text_length, text)
	buffer.encode_u8(size - 1, 0)  # last byte must be zero
	trim_packet_size()


func trim_packet_size() -> void:
	for i in TEXT_MAX_LENGTH:
		if buffer[PACKET_MAX_SIZE - i - 1] != 0:
			size = PACKET_MAX_SIZE - i
			@warning_ignore("integer_division")
			buffer.encode_u8(0, size / SIZE_MULTIPLIER)
