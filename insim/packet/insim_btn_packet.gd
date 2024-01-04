class_name InSimBTNPacket
extends InSimPacket


const TEXT_MAX_LENGTH := 240  # last byte must be zero, actual length is one character shorter
const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := PACKET_MIN_SIZE + TEXT_MAX_LENGTH
const PACKET_TYPE := InSim.Packet.ISP_BTN

var ucid := 0

var click_id := 0
var inst := 0
var button_style := 0
var type_in := 0

var left := 0
var top := 0
var width := 0
var height := 0

var text := ""
var caption := ""


func _init(req := 1) -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE
	req_i = req


func _fill_buffer() -> void:
	super()
	add_byte(ucid)
	add_byte(click_id)
	add_byte(inst)
	add_byte(button_style)
	add_byte(type_in)
	add_byte(left)
	add_byte(top)
	add_byte(width)
	add_byte(height)
	var caption_length := caption.length()
	if caption_length > 0:
		add_byte(0)
		add_string(caption_length, caption)
		add_byte(0)
		caption_length += 2
	var text_length := text.length()
	if text_length >= TEXT_MAX_LENGTH - caption_length:
		text = text.left(TEXT_MAX_LENGTH - caption_length)
		text_length = text.length()
	var remainder := text_length % SIZE_MULTIPLIER
	text_length += remainder
	if remainder == 0 and text_length < TEXT_MAX_LENGTH - caption_length:
		text_length += SIZE_MULTIPLIER
	add_string(text_length, text)
	buffer.encode_u8(size - 1, 0)  # last byte must be zero
	trim_packet_size()


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"ClickID": click_id,
		"Inst": inst,
		"BStyle": button_style,
		"TypeIn": type_in,
		"L": left,
		"T": top,
		"W": width,
		"H": height,
		"Text": text,
		"Caption": caption,
	}


func trim_packet_size() -> void:
	for i in TEXT_MAX_LENGTH:
		if buffer[PACKET_MAX_SIZE - i - 1] != 0:
			size = PACKET_MAX_SIZE - i
			resize_buffer(size)
