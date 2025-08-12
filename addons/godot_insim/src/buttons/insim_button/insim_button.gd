class_name InSimButton
extends RefCounted
## InSim Button base class
##
## An object representing an InSim button, mostly mirroring [InSimBTNPacket]. Allows querying
## existing buttons by creating and storing the object after receiving an [InSimBTNPacket].
## Any change made should be followed by sending a new [InSimBTNPacket] to update the actual
## InSim button, which can be done by calling [method get_btn_packet].[br]
## [b]Note:[/b] This class is not intended to be used directly, you should use [InSimSoloButton]
## and [InSimMultiButton] instead when interacting with [InSimButtonManager].

## If set in [member inst], the button will display everywhere - this is typically best avoided.
const INST_ALWAYS_ON := 0x80

## A custom identifier, which can be used to keep track of, update or delete the button.
var name := ""
## The request ID that sent the [InSimBTNPacket] to create this button.
var reqi := 0
## Some flags and mostly used internally by InSim.
var inst := 0
## Style flags for this button, see [enum InSim.ButtonStyle] and [enum InSim.ButtonColor].
var style := 0
## The button's position in LFS coordinates.
var position := Vector2i.ZERO
## The button's size in LFS coordinates.
var size := Vector2i.ZERO


## Virtual function to override. Returns an [InSimBTNPacket] representing this button
## for the given [param for_ucid].
@warning_ignore("unused_parameter")
func _get_btn_packet(for_ucid: int) -> InSimBTNPacket:
	return InSimBTNPacket.new()


## Virtual function to override. Returns the button's caption. See [method get_caption]
## for more details.
@warning_ignore("unused_parameter")
func _get_caption(for_ucid: int) -> String:
	return ""


## Virtual function to override. Returns the button's clickID. See [method get_click_id]
## for more details.
@warning_ignore("unused_parameter")
func _get_click_id(for_ucid: int) -> int:
	return -1


## Virtual function to override. Returns the button's text. See [method get_text]
## for more details.
@warning_ignore("unused_parameter")
func _get_text(for_ucid: int) -> String:
	return ""


## Virtual function to override. Returns the button's type_in. See [method get_type_in]
## for more details.
@warning_ignore("unused_parameter")
func _get_type_in(for_ucid: int) -> int:
	return -1


## Returns an [InSimBTNPacket] corresponding to this [InSimButton] for the given [param for_ucid],
## if relevant. If [param ignore_position_and_size] is [code]true[/code], the button's position
## and size are set to zero; this is useful to update an existing button without having to
## recreate an [InSimBTNPacket] from scratch after modifying the button.[br]
## [b]Note:[/b] This function is mainly intended for internal use by the [InSimButtonManager].
func get_btn_packet(for_ucid: int, ignore_position_and_size := false) -> InSimBTNPacket:
	var packet := _get_btn_packet(for_ucid)
	if ignore_position_and_size:
		packet.left = 0
		packet.top = 0
		packet.width = 0
		packet.height = 0
	return packet


## Returns the button's clickID. If the button can have multiple values, return
## the one corresponding to the given [param for_ucid]. See [method _get_click_id]
## for implementation.[br]
## [b]Note:[/b] The clickID is only implemented in child classes.
func get_click_id(for_ucid: int) -> int:
	return _get_click_id(for_ucid)


## Returns the button's caption. If the button can have multiple values, return
## the one corresponding to the given [param for_ucid]. See [method _get_caption]
## for implementation.[br]
## [b]Note:[/b] The caption is only implemented in child classes.
func get_caption(for_ucid: int) -> String:
	return _get_caption(for_ucid)


## Returns the button's text. If the button can have multiple values, return
## the one corresponding to the given [param for_ucid]. See [method _get_text]
## for implementation.[br]
## [b]Note:[/b] The text is only implemented in child classes.
func get_text(for_ucid: int) -> String:
	return _get_text(for_ucid)


## Returns the button's type_in. If the button can have multiple values, return
## the one corresponding to the given [param for_ucid]. See [method _get_type_in]
## for implementation.[br]
## [b]Note:[/b] The type_in is only implemented in child classes.
func get_type_in(for_ucid: int) -> int:
	return _get_type_in(for_ucid)
