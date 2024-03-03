class_name InSimBTNPacket
extends InSimPacket

## BuTtoN packet - button header - followed by 0 to 240 characters

const TEXT_MAX_LENGTH := 240  # last byte must be zero, actual length is one character shorter
const PACKET_MIN_SIZE := 12
const PACKET_MAX_SIZE := PACKET_MIN_SIZE + TEXT_MAX_LENGTH
const PACKET_TYPE := InSim.Packet.ISP_BTN

var ucid := 0  ## connection to display the button (0 = local / 255 = all)

var click_id := 0  ## button ID (0 to 239)
var inst := 0  ## some extra flags
var button_style := 0  ## button style flags - see [enum InSim.ButtonStyle]
var type_in := 0  ## max chars to type in - if set, the user can click this button to type in text

var left := 0  ## left   : 0 - 200
var top := 0  ## top    : 0 - 200
var width := 0  ## width  : 0 - 200
var height := 0  ## height : 0 - 200

var text := ""  ## 0 to 240 characters of text, including [member caption]
var caption := ""  ## displayed when hovering the button, length included in [member text]


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
	var text_length := text.length() + caption_length
	if text_length >= TEXT_MAX_LENGTH:
		text = text.left(TEXT_MAX_LENGTH)
		text_length = text.length()
	var remainder := text_length % SIZE_MULTIPLIER
	if remainder > 0:
		text_length += SIZE_MULTIPLIER - remainder
	if remainder == 0 and text_length < TEXT_MAX_LENGTH:
		text_length += SIZE_MULTIPLIER
	add_string(text_length, text)
	trim_packet_size()
	buffer.encode_u8(size - 1, 0)  # last byte must be zero


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
			break
