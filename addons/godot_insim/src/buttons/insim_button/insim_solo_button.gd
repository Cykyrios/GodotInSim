class_name InSimSoloButton
extends InSimButton
## InSim Button assigned to a single UCID
##
## The [InSimSoloButton] represents a single button: one UCID, one clickID. If the button's
## UCID is [constant InSim.UCID_ALL], this button technically represents more than
## one button, but is still considered as a single "broadcast" button.

## The unique connection ID to display the button for (0: local/host, 255: everyone).
var ucid := 0
## The button's clickID.
var click_id := 0:
	set(value):
		click_id = clampi(value, 0, InSimButtonManager.MAX_BUTTONS - 1)
## Number of characters that can be typed in.[br]
## [b]Note:[/b] Color codes, codepage change codes, and multibyte characters all count
## toward that number (e.g. typing a Japanese character will add [code]^J[/code] and
## 2 more bytes (for a multibyte character) to make up one character, so your first
## Japanese character would actually cost 4 characters (bytes), and subsequent multibyte
## characters would cost an additional 2).
var type_in := 0
## The text displayed by this button.
var text := ""
## The caption for this button (used as description for [member type_in]).
var caption := ""


func _init(
	b_ucid: int, b_click_id: int, b_inst: int, b_style: int, b_position: Vector2i,
	b_size: Vector2i, b_text: String, b_name := "", b_type_in := 0, b_caption := ""
) -> void:
	ucid = b_ucid
	click_id = b_click_id
	inst = b_inst
	style = b_style
	type_in = b_type_in
	position = b_position
	size = b_size
	text = b_text
	name = b_name
	caption = b_caption


@warning_ignore("unused_parameter")
func _get_btn_packet(for_ucid: int) -> InSimBTNPacket:
	return InSimBTNPacket.create(
		ucid,
		click_id,
		inst,
		style,
		type_in,
		position.x,
		position.y,
		size.x,
		size.y,
		text,
		caption,
	)


@warning_ignore("unused_parameter")
func _get_caption(for_ucid: int) -> String:
	return caption


@warning_ignore("unused_parameter")
func _get_click_id(for_ucid: int) -> int:
	return click_id


@warning_ignore("unused_parameter")
func _get_text(for_ucid: int) -> String:
	return text


@warning_ignore("unused_parameter")
func _get_type_in(for_ucid: int) -> int:
	return type_in
