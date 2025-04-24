class_name InSimButtons
extends RefCounted


## The maximum number of buttons across all InSim apps.
const MAX_BUTTONS := 240

## The range of click IDs this instance can use. This range should remain as small as possible
## to allow other instances or InSim apps to manage their own range of buttons.
var id_range := Vector2i(0, MAX_BUTTONS - 1):
	set(value):
		id_range = Vector2i(
			clampi(value.x, 0, MAX_BUTTONS - 1),
			clampi(value.y, value.x, MAX_BUTTONS - 1)
		)
## Current known buttons, as a [Dictionary] with keys corresponding to connection IDs
## (including 0 for local buttons and 255 for buttons common to all connections), and values
## corresponding to [InSimButtonDictionary] objects for each connection ID, containing
## the actual [InSimButton] objects. Any InSim app using buttons should listen to [InSimBTNPacket]
## and [InSimBFNPacket] to keep this dictionary as up to date as possible, using
## [code]req_i[/code] to distinguish buttons created by other apps.
var buttons: Dictionary[int, InSimButtonDictionary] = {}


## Creates an [InSimButton] from the given parameters, which is added to the [member buttons]
## [Dictionary] for each UCID in [param ucids]. Button creation can fail if there is no clickID
## available for the button for each UCID. Successfully created buttons generate a corresponding
## [InSimBTNPacket], an array of which is returned.[br]
## To create buttons with text tailored to each UCID in [param ucids], you should pass a valid
## [Callable] as [param text_function], which takes an [int] as its single argument, corresponding
## to the player's UCID, and returns a [String]. See the example below, which sends a button
## to each connection and displays their name:
## [codeblock]
## insim.send_packets(insim.buttons.add_button(
##     insim.connections.keys(),
##     Vector2i(0, 0),
##     Vector2i(30, 5),
##     InSim.ButtonStyle.ISB_DARK,
##     true,
##     "ignored text",  # Text is ignored if the following Callable is valid
##     func(ucid: int) -> String: return insim.get_connection_nickname(ucid),
## ))
## [/codeblock]
func add_button(
	ucids: Array[int], position: Vector2i, size: Vector2i, style: int, show_everywhere: bool,
	text: String, text_function := Callable(), type_in := 0, caption := ""
) -> Array[InSimBTNPacket]:
	var inst := 0 | (InSimButton.INST_ALWAYS_ON if show_everywhere else 0)
	var packets: Array[InSimBTNPacket] = []
	for ucid in ucids:
		if not has_ucid(ucid):
			buttons[ucid] = InSimButtonDictionary.new()
		var new_id := get_free_id(ucid)
		if new_id == -1:
			push_warning("Cannot create button: no clickID available.")
			continue
		var button := InSimButton.create(
			ucid, new_id, inst, style, type_in, position, size, text, caption
		)
		if text_function.is_valid():
			button.text = text_function.call(ucid)
		buttons[ucid].buttons[new_id] = button
		var packet := button.get_btn_packet()
		packets.append(packet)
	return packets


## Returns an [InSimBFNPacket] requesting the deletion of the given button, if the button is
## found in the [member buttons] [Dictionary]; otherwise, returns [code]null[/code].
func delete_button(button: InSimButton, ucids: Array[int]) -> Array[InSimBFNPacket]:
	var packets: Array[InSimBFNPacket] = []
	var button_id := button.click_id
	for ucid in ucids:
		if not has_ucid(ucid):
			continue
		if buttons[ucid].has_id(button_id):
			var packet := InSimBFNPacket.create(
				InSim.ButtonFunction.BFN_DEL_BTN, ucid, button.click_id, 0
			)
			packets.append(packet)
			var _discard := buttons[ucid].buttons.erase(button_id)
			if buttons[ucid].buttons.is_empty():
				_discard = buttons.erase(ucid)
	return packets


## Returns the [InSimButton] at the given [param id], or [code]null[/code] if it does not exist.
func get_button_from_ucid_and_id(ucid: int, id: int) -> InSimButton:
	if has_ucid(ucid):
		if buttons[ucid].has_id(id):
			return buttons[ucid].buttons[id]
	return null


## Returns a free [code]click_id[/code] value to create a new button, or [code]-1[/code]
## if no ID is available in the [member id_range] for the specified [param ucid].
func get_free_id(ucid: int) -> int:
	if not has_ucid(ucid):
		return id_range.x
	for i in id_range.y - id_range.x + 1:
		var test_id := id_range.x + i
		if buttons[ucid].has_id(test_id):
			continue
		return test_id
	return -1


## Returns [code]true[/code] if the given [param ucid] has an entry in [member buttons].
func has_ucid(ucid: int) -> bool:
	return true if buttons.has(ucid) else false
