class_name InSimMTCPacket
extends InSimPacket


const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := 136
const TEXT_MAX_LENGTH := 128  # last byte must be zero, actual length is one character shorter

var ucid := 0
var player_id := 0
var sp2 := 0
var sp3 := 0

var text := ""


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = InSim.Packet.ISP_MTC
	super()


func _get_data_dictionary() -> Dictionary:
	var data := {
		"UCID": ucid,
		"PLID": player_id,
		"Sp2": sp2,
		"Sp3": sp3,
		"Text": text,
	}
	return data


func _fill_buffer() -> void:
	data_offset = HEADER_SIZE
	add_byte(ucid)
	add_byte(player_id)
	add_byte(sp2)
	add_byte(sp3)
	var text_length := text.length()
	if text_length >= TEXT_MAX_LENGTH:
		text = text.left(TEXT_MAX_LENGTH - 1)  # last byte must be zero
		text_length = TEXT_MAX_LENGTH
	var remainder := text_length % 4
	text_length += remainder
	if remainder == 0 and text_length < TEXT_MAX_LENGTH:
		text_length += 4
	add_string(text_length, text)
	buffer.encode_u8(size - 1, 0)  # last byte must be zero
