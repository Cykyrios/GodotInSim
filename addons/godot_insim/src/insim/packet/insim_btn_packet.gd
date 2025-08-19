class_name InSimBTNPacket
extends InSimPacket
## BuTtoN packet - button header - followed by 0 to 240 characters
##
## This packet is sent to create or modify an InSim button.

## Maximum text length
const TEXT_MAX_LENGTH := 240  # last byte must be zero, actual length is one character shorter
const CAPTION_MAX_LENGTH := 128  ## Maximum caption length
const PACKET_MIN_SIZE := 12  ## Minimum packet size
const PACKET_MAX_SIZE := PACKET_MIN_SIZE + TEXT_MAX_LENGTH  ## Maximum packet size
const PACKET_TYPE := InSim.Packet.ISP_BTN  ## The packet's type, see [enum InSim.Packet].

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


## Creates and returns a new [InSimBTNPacket] from the given parameters.
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
	var caption_length := caption.length()
	if caption_length > 0:
		add_byte(0)
		var _caption := add_string(mini(caption_length, CAPTION_MAX_LENGTH), caption, false)
		add_byte(0)
		caption_length += 2
	var _buffer := add_string_variable_length(
		text, TEXT_MAX_LENGTH - caption_length, INSIM_SIZE_MULTIPLIER
	)
	_trim_packet_size()


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
	for key: String in InSim.ButtonStyle:
		if button_style & InSim.ButtonStyle[key]:
			button_flags.append(key)
	var target := (
		"everyone" if ucid == InSim.UCID_ALL
		else "UCID %d" % [ucid]
	)
	var button_text := text
	var button_color := button_style & 0b0111
	if button_color != 0:
		button_text = "[color=%s]%s[/color]" % [
			LFSText.get_button_color(button_color).to_html(false),
			text,
		]
	return "Button for %s: ID %d, %s, %d-%d:%dx%d, \"%s\"" % [
		target, click_id, button_flags,
		left, top, width, height,
		button_text + "^9" + (" (%s^9)" % [caption] if caption else ""),
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(
		dict,
		["UCID", "ClickID", "Inst", "BStyle", "TypeIn", "L", "T", "W", "H", "Text", "Caption"],
	):
		return
	ucid = dict["UCID"]
	click_id = dict["ClickID"]
	inst = dict["Inst"]
	button_style = dict["BStyle"]
	type_in = dict["TypeIn"]
	left = dict["L"]
	top = dict["T"]
	width = dict["W"]
	height = dict["H"]
	text = dict["Text"]
	caption = dict["Caption"]


func _trim_packet_size() -> void:
	if size < PACKET_MAX_SIZE and size >= PACKET_MIN_SIZE:
		_adjust_packet_size()
		size = mini(size, PACKET_MAX_SIZE)
		resize_buffer(size)
		return
	for i in TEXT_MAX_LENGTH:
		if buffer[PACKET_MAX_SIZE - i - 1] != 0:
			size = PACKET_MAX_SIZE - i + 1  # + 1 to keep final zero
			resize_buffer(size)
			break
