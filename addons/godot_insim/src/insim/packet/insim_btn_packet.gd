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
	sendable = true


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
	var caption_length := caption.length()  # NOTE: max caption length is 128
	if caption_length > 0:
		add_byte(0)
		var _caption := add_string(caption_length, caption)
		add_byte(0)
		caption_length += 2
	var _buffer := add_string_variable_length(text, TEXT_MAX_LENGTH - caption_length,
			SIZE_MULTIPLIER)
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


func _get_pretty_text() -> String:
	var button_flags: Array[String] = []
	for i in InSim.ButtonStyle.size():
		if button_style & InSim.ButtonStyle.values()[i]:
			button_flags.append(InSim.ButtonStyle.keys()[i])
	var target := "local" if ucid == 0 else "everyone" if ucid == 255 else "UCID %d" % [ucid]
	return "Button for %s: ID %d, %s, %d-%d:%dx%d, \"%s\"" % [target, click_id, button_flags,
			left, top, width, height, text]


static func create(
	btn_ucid: int, btn_click_id: int, btn_inst: int, btn_style: int,
	btn_type := 0, btn_left := 0, btn_top := 0, btn_width := 0, btn_height := 0,
	btn_text := "", btn_caption := ""
) -> InSimBTNPacket:
	var packet := InSimBTNPacket.new()
	packet.ucid = btn_ucid
	packet.click_id = btn_click_id
	packet.inst = btn_inst
	packet.button_style = btn_style
	packet.type_in = btn_type
	packet.left = btn_left
	packet.top = btn_top
	packet.width = btn_width
	packet.height = btn_height
	packet.text = btn_text
	packet.caption = btn_caption
	return packet


func trim_packet_size() -> void:
	for i in TEXT_MAX_LENGTH:
		if buffer[PACKET_MAX_SIZE - i - 1] != 0:
			size = PACKET_MAX_SIZE - i + 1  # + 1 to keep final zero
			resize_buffer(size)
			break
