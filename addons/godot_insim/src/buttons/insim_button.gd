class_name InSimButton
extends RefCounted

## InSim Button
##
## An object representing an InSim button, mostly mirroring [InSimBTNPacket]. Allows querying
## existing buttons by creating and storing the object after receiving an [InSimBTNPacket].
## Any change made should be followed by sending a new [InSimBTNPacket] to update the actual
## InSim button.

## If set in [member inst], the button will display everywhere - this is typically best avoided.
const INST_ALWAYS_ON := 0x80

## The request ID that sent the [InSimBTNPacket] to create this button.
var reqi := 0
## The list of unique connection IDs to display the button for (0: local, 255: everyone).
## If [code]0[/code] or [code]255[/code] are present, they should be the only value.
var ucids: Array[int] = []
## The button's click ID.
var click_id := 0:
	set(value):
		click_id = clampi(value, 0, InSimButtons.MAX_BUTTONS - 1)
## Some flags and mostly used internally by InSim.
var inst := 0
## Style flags for this button, see [enum InSim.ButtonStyle] and [enum InSim.ButtonColor].
var style := 0
## Number of characters that can be typed in - note that color codes, code page changes, and
## multibyte characters consume "invisible" characters.
var type_in := 0
## The button's position in LFS coordinates.
var position := Vector2i.ZERO
## The button's size in LFS coordinates.
var size := Vector2i.ZERO
## The text displayed by this button.
var text := ""
## The caption for this button (used as description for [member type_in]).
var caption := ""


## Creates and returns a new [InSimButton].
static func create(
	ucids: Array[int], click_id: int, inst: int, style: int, type_in: int, position: Vector2i,
	size: Vector2i, text: String, caption := ""
) -> InSimButton:
	var button := InSimButton.new()
	button.ucids = ucids
	button.click_id = click_id
	button.inst = inst
	button.style = style
	button.type_in = type_in
	button.position = position
	button.size = size
	button.text = text
	button.caption = caption
	return button


func get_updated_btn_packets(ignore_position_and_size := false) -> Array[InSimBTNPacket]:
	var packets: Array[InSimBTNPacket] = []
	for ucid in ucids:
		var packet := InSimBTNPacket.create(
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
			caption
		)
		if ignore_position_and_size:
			packet.left = 0
			packet.top = 0
			packet.width = 0
			packet.height = 0
		packets.append(packet)
	return packets
