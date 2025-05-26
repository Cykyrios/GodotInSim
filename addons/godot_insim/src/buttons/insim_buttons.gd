class_name InSimButtons
extends RefCounted
## InSimButton manager
##
## This class keeps track of existing [InSimButton]s and allows adding/deleting buttons.
## An instance is included in the [InSim] object.

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
## List of button click IDs, and the number of users of those IDs. The list has a fixed size
## of [constant MAX_BUTTONS], and each added button increases an ID's count by one, including
## UCID 255; conversely, deleting a button decreases the count by one, except when deleting
## a button for UCID 255, which resets the count to zero.
var used_ids: Array[int] = []
## Current known buttons, as a [Dictionary] with keys corresponding to connection IDs
## (including 0 for local buttons and 255 for buttons common to all connections), and values
## corresponding to [InSimButtonDictionary] objects for each connection ID, containing
## the actual [InSimButton] objects. Any InSim app using buttons should listen to [InSimBTNPacket]
## and [InSimBFNPacket] to keep this dictionary as up to date as possible, using
## [code]req_i[/code] to distinguish buttons created by other apps.
var buttons: Dictionary[int, InSimButtonDictionary] = {}


func _init() -> void:
	var _resize := used_ids.resize(MAX_BUTTONS)
	used_ids.fill(0)


## Creates an [InSimButton] from the given parameters, which is added to the [member buttons]
## [Dictionary] for each UCID in [param ucids]. Button creation can fail if there is no clickID
## available for the button for each UCID. Successfully created buttons generate a corresponding
## [InSimBTNPacket], an array of which is returned.[br]
## [param text] usually takes a [String], but you can create buttons with text tailored
## to each UCID in [param ucids] by passing a valid [Callable] instead, which takes an [int]
## as its single argument, corresponding to the player's UCID, and returns a [String].
## See the example below, which sends a button to each connection and displays their name:
## [codeblock]
## insim.add_button(
##     [],  # empty array, will retrieve all connections
##     Vector2i(0, 0),
##     Vector2i(30, 5),
##     InSim.ButtonStyle.ISB_DARK,
##     func(ucid: int) -> String: return insim.get_connection_nickname(ucid),
## )
## [/codeblock]
func add_button(
	ucids: Array[int], position: Vector2i, size: Vector2i, style: int, text: Variant,
	button_name := "", type_in := 0, caption := "", show_everywhere := false
) -> Array[InSimBTNPacket]:
	var inst := 0 | (InSimButton.INST_ALWAYS_ON if show_everywhere else 0)
	var packets: Array[InSimBTNPacket] = []
	var new_id := get_free_id()
	if new_id == -1:
		push_warning("Cannot create button: no clickID available.")
		return packets
	var text_type := typeof(text)
	for ucid in ucids:
		if not has_ucid(ucid):
			buttons[ucid] = InSimButtonDictionary.new()
		var button_text := "^1INVALID"  # Serves as an error message if no String or valid Callable
		if text_type in [TYPE_STRING, TYPE_STRING_NAME]:
			button_text = str(text)
		elif text_type == TYPE_CALLABLE:
			var text_function := text as Callable
			if text_function.is_valid():
				button_text = text_function.call(ucid)
		var button := InSimButton.create(
			ucid, new_id, inst, style, position, size, button_text, button_name, type_in, caption
		)
		used_ids[new_id] += 1
		buttons[ucid].buttons[new_id] = button
		var packet := button.get_btn_packet()
		packets.append(packet)
	return packets


## Returns an array of [InSimBFNPacket]s requesting the deletion of the given button
## [param click_id] for all [param ucids].
func delete_button_by_id(click_id: int, ucids: Array[int]) -> Array[InSimBFNPacket]:
	var packets: Array[InSimBFNPacket] = []
	for ucid in ucids:
		if not has_ucid(ucid):
			continue
		if buttons[ucid].has_id(click_id):
			used_ids[click_id] = 0 if ucid == 255 \
					else clampi(used_ids[click_id] - 1, 0, MAX_BUTTONS)
			var packet := InSimBFNPacket.create(
				InSim.ButtonFunction.BFN_DEL_BTN, ucid, click_id, 0
			)
			packets.append(packet)
			var _discard := buttons[ucid].buttons.erase(click_id)
			if buttons[ucid].buttons.is_empty():
				_discard = buttons.erase(ucid)
	return packets


## Returns an array of [InSimBFNPacket]s requesting the deletion of the given button
## [param name] for all [param ucids].
func delete_buttons_by_name(name: StringName, ucids: Array[int]) -> Array[InSimBFNPacket]:
	var packets: Array[InSimBFNPacket] = []
	for ucid in ucids:
		if not has_ucid(ucid):
			continue
		for button_id in buttons[ucid].buttons:
			var button := buttons[ucid].buttons[button_id]
			if button.name == name:
				packets.append_array(delete_button_by_id(button.click_id, [ucid]))
				var _discard := buttons[ucid].buttons.erase(button.click_id)
				if buttons[ucid].buttons.is_empty():
					_discard = buttons.erase(ucid)
	return packets


## Returns an array of [InSimBFNPacket]s requesting the deletion of all buttons that have a
## [member InSimButton.name] starting with [param prefix] for all [param ucids].
func delete_buttons_by_prefix(prefix: String, ucids: Array[int]) -> Array[InSimBFNPacket]:
	var packets: Array[InSimBFNPacket] = []
	for ucid in ucids:
		if not has_ucid(ucid):
			continue
		for button_id in buttons[ucid].buttons:
			var button := buttons[ucid].buttons[button_id]
			if button.name.begins_with(prefix):
				packets.append_array(delete_button_by_id(button.click_id, [ucid]))
				var _discard := buttons[ucid].buttons.erase(button.click_id)
				if buttons[ucid].buttons.is_empty():
					_discard = buttons.erase(ucid)
	return packets


## Returns the [InSimButton] at the given [param id], or [code]null[/code] if it does not exist.
func get_button_by_id(id: int, ucid: int) -> InSimButton:
	if has_ucid(ucid):
		if buttons[ucid].has_id(id):
			return buttons[ucid].buttons[id]
	return null


## Returns the first [InSimButton] matching the given [param name] and [param ucid],
## or [code]null[/code] if no matching button is found.
func get_button_by_name(name: StringName, ucid: int) -> InSimButton:
	if has_ucid(ucid):
		for click_id in buttons[ucid].buttons:
			var button := buttons[ucid].buttons[click_id]
			if button.name == name:
				return button
	return null


## Returns all [InSimButton]s whose [member InSimButton.name] starts with the given
## [param prefix] and [param ucid], or an empty array if no matching button is found.
func get_button_by_prefix(prefix: StringName, ucid: int) -> Array[InSimButton]:
	var matching_buttons: Array[InSimButton] = []
	if has_ucid(ucid):
		for click_id in buttons[ucid].buttons:
			var button := buttons[ucid].buttons[click_id]
			if button.name.begins_with(prefix):
				matching_buttons.append(button)
	return matching_buttons


## Returns a free [code]click_id[/code] value to create a new button, or [code]-1[/code]
## if no ID is available in the [member id_range].[br]
## [b]Note:[/b] At this time, all UCIDs share the same button click IDs; individual mappings
## will be added later.
func get_free_id() -> int:
	for i in id_range.y - id_range.x + 1:
		var test_id := id_range.x + i
		if used_ids[test_id] > 0:
			continue
		return test_id
	return -1


## Returns [code]true[/code] if the given [param ucid] has an entry in [member buttons].
func has_ucid(ucid: int) -> bool:
	return true if buttons.has(ucid) else false
