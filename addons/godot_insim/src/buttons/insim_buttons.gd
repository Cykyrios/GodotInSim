class_name InSimButtons
extends RefCounted
## InSimButton manager
##
## This class keeps track of existing [InSimButton]s and allows adding/deleting buttons.
## An instance is included in the [InSim] object.

## The maximum number of buttons across all InSim apps.
const MAX_BUTTONS := 240
## The UCID value corresponding to all players; you can use this when creating global buttons.
const EVERYONE := 255

## A reference to the parent [InSim] instance, used to fetch [member InSim.connections] for
## per-player button management.
var insim: InSim = null
## Determines whether buttons cleared by pressing [kbd]Shift + I[/kbd] are remembered or
## forgotten, i.e. whether their corresponding mappings are deleted.
## [signal InSim.connection_cleared_buttons] is emitted right after an InSim clear request.
var forget_cleared_buttons := false

## The range of click IDs this instance can use. This range should remain as small as possible
## to allow other instances or InSim apps to manage their own range of buttons.
var id_range := Vector2i(0, MAX_BUTTONS - 1):
	set(value):
		id_range = Vector2i(
			clampi(value.x, 0, MAX_BUTTONS - 1),
			clampi(value.y, value.x, MAX_BUTTONS - 1)
		)
## A dictionary mapping all button clickIDs for every connection. You should not need
## to use this directly.
var id_map: Dictionary[int, Array] = {}
## Current known buttons, as a [Dictionary] with keys corresponding to connection IDs
## (including 0 for local buttons and 255 for buttons common to all connections), and values
## corresponding to [InSimButtonDictionary] objects for each connection ID, containing
## the actual [InSimButton] objects. Any InSim app using buttons should listen to [InSimBTNPacket]
## and [InSimBFNPacket] to keep this dictionary as up to date as possible, using
## [code]req_i[/code] to distinguish buttons created by other apps.
var buttons: Dictionary[int, InSimButtonDictionary] = {}
## The list of current global button IDs, i.e. buttons that were creating with a UCID of 255;
## those are converted to individual buttons for each UCID in the server, and the buttons'
## clickIDs become reserved overall until the corresponding buttons are cleared. The dictionary's
## keys are the button clickIDs, and the values are the lists of UCIDs displaying buttons with
## those clickIDs. When a player connects, they are sent all currently existing global buttons;
## conversely, buttons are removed when a player disconnects.
var global_buttons: Dictionary[int, Array] = {}
## The list of UCIDs corresponding to players who have disabled InSim buttons (by pressing
## [kbd]Shift + I[/kbd]); adding and updating buttons (including global buttons with UCID 255)
## should be disabled for those.
var disabled_ucids: Array[int] = []


func _init(insim_instance: InSim) -> void:
	insim = insim_instance


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
	var text_type := typeof(text)
	var new_id := -1
	var global_button := false
	if ucids.is_empty() or EVERYONE in ucids:
		global_button = true
		ucids = insim.connections.keys()
		new_id = get_free_global_id()
	for ucid in ucids:
		if ucid in disabled_ucids:
			continue
		if not has_ucid(ucid):
			buttons[ucid] = InSimButtonDictionary.new()
		if not global_button:
			new_id = get_free_id(ucid)
			if new_id == -1:
				push_warning("Cannot create button for UCID %d: no clickID available." % [ucid])
				continue
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
		register_buttons([button])
		if global_button:
			_register_global_button(button)
		var packet := button.get_btn_packet()
		packets.append(packet)
	return packets


## Adds a global button (shown to every player). See [method add_button] for more details.
func add_global_button(
	position: Vector2i, size: Vector2i, style: int, text: Variant,
	button_name := "", type_in := 0, caption := "", show_everywhere := false
) -> Array[InSimBTNPacket]:
	return add_button(
		[], position, size, style, text, button_name, type_in, caption, show_everywhere
	)


## Returns an array of [InSimBFNPacket]s requesting the deletion of the given button
## [param click_id] for all [param ucids]. If [param max_id] is non-zero, and greater than
## [param click_id], all buttons from [param click_id] to [param max_id] are deleted.
func delete_buttons_by_id(ucids: Array[int], click_id: int, max_id := 0) -> Array[InSimBFNPacket]:
	var packets: Array[InSimBFNPacket] = []
	for ucid in ucids:
		if not has_ucid(ucid):
			continue
		if buttons[ucid].has_id(click_id):
			var packet := InSimBFNPacket.create(
				InSim.ButtonFunction.BFN_DEL_BTN, ucid, click_id, max_id if max_id > click_id else 0
			)
			packets.append(packet)
			_delete_button(ucid, click_id)
	return packets


## Returns an array of [InSimBFNPacket]s requesting the deletion of the given button
## [param name] for all [param ucids].
func delete_buttons_by_name(ucids: Array[int], name: StringName) -> Array[InSimBFNPacket]:
	var packets: Array[InSimBFNPacket] = []
	for ucid in ucids:
		if not has_ucid(ucid):
			continue
		for button_id in buttons[ucid].buttons:
			var button := buttons[ucid].buttons[button_id]
			if button.name == name:
				packets.append_array(delete_buttons_by_id([ucid], button.click_id))
				_delete_button(ucid, button.click_id)
	return packets


## Returns an array of [InSimBFNPacket]s requesting the deletion of all buttons that have a
## [member InSimButton.name] starting with [param prefix] for all [param ucids].
func delete_buttons_by_prefix(ucids: Array[int], prefix: String) -> Array[InSimBFNPacket]:
	var packets: Array[InSimBFNPacket] = []
	for ucid in ucids:
		if not has_ucid(ucid):
			continue
		# For some reason, not adding .keys() only visits the first id...
		for button_id in buttons[ucid].buttons.keys() as Array[int]:
			var button := buttons[ucid].buttons[button_id]
			if button.name.begins_with(prefix):
				packets.append_array(delete_buttons_by_id([ucid], button.click_id))
				_delete_button(ucid, button.click_id)
	return _compact_bfn_packets(packets)


## Returns an array of [InSimBFNPacket]s requesting the deletion of all buttons that have a
## [member InSimButton.name] matching the given [param regex] for all [param ucids].
func delete_buttons_by_regex(ucids: Array[int], regex: RegEx) -> Array[InSimBFNPacket]:
	var packets: Array[InSimBFNPacket] = []
	for ucid in ucids:
		if not has_ucid(ucid):
			continue
		for button_id in buttons[ucid].buttons.keys() as Array[int]:
			var button := buttons[ucid].buttons[button_id]
			if regex.search(button.name):
				packets.append_array(delete_buttons_by_id([ucid], button.click_id))
				_delete_button(ucid, button.click_id)
	return _compact_bfn_packets(packets)


## Deletes a global button (shown to every player) selected by its click [param id]. See
## [method delete_buttons_by_id] for buttons specific to specific UCIDs.
func delete_global_buttons_by_id(id: int) -> Array[InSimBFNPacket]:
	var packets := delete_buttons_by_id(insim.connections.keys(), id)
	for packet in packets:
		var _existed := global_buttons.erase(packet.click_id)
	return packets


## Deletes a global button (shown to every player) selected by its [param name]. See
## [method delete_buttons_by_name] for buttons specific to specific UCIDs.
func delete_global_buttons_by_name(name: StringName) -> Array[InSimBFNPacket]:
	var packets := delete_buttons_by_name(insim.connections.keys(), name)
	for packet in packets:
		var _existed := global_buttons.erase(packet.click_id)
	return packets


## Deletes global buttons (shown to every player) selected by their [param prefix]. See
## [method delete_buttons_by_prefix] for buttons specific to specific UCIDs.
func delete_global_buttons_by_prefix(prefix: StringName) -> Array[InSimBFNPacket]:
	var packets := delete_buttons_by_prefix(insim.connections.keys(), prefix)
	for packet in packets:
		var _existed := global_buttons.erase(packet.click_id)
	return packets


## Deletes global buttons (shown to every player) matching [param regex]. See
## [method delete_buttons_by_regex] for buttons specific to specific UCIDs.
func delete_global_buttons_by_regex(regex: RegEx) -> Array[InSimBFNPacket]:
	var packets := delete_buttons_by_regex(insim.connections.keys(), regex)
	for packet in packets:
		var _existed := global_buttons.erase(packet.click_id)
	return packets


## Disables button updates by adding [param ucid] to [member disabled_ucids]. If
## [member forget_cleared_buttons] is [code]true[/code], all button mappings for [param ucid]
## are removed.
func disable_buttons_for_ucid(ucid: int) -> void:
	if forget_cleared_buttons:
		_forget_buttons_for_ucid(ucid)
	disabled_ucids.erase(ucid)
	disabled_ucids.append(ucid)


## Allows buttons to be sent to the given [param ucid] again, by removing it from
## [member disabled_ucids]. If button mappings were not removed, all remembered buttons are
## immediately sent again.
func enable_buttons_for_ucid(ucid: int) -> void:
	disabled_ucids.erase(ucid)
	if not id_map.has(ucid):
		return
	for click_id in id_map[ucid] as Array[int]:
		var button := get_button_by_id(click_id, ucid)
		if button:
			insim.send_packet(button.get_btn_packet())


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
func get_buttons_by_prefix(prefix: StringName, ucid: int) -> Array[InSimButton]:
	var matching_buttons: Array[InSimButton] = []
	if has_ucid(ucid):
		for click_id in buttons[ucid].buttons:
			var button := buttons[ucid].buttons[click_id]
			if button.name.begins_with(prefix):
				matching_buttons.append(button)
	return matching_buttons


## Returns a free [code]click_id[/code] value to create a new button for UCID [param for_ucid],
## or [code]-1[/code] if no ID is available in the [member id_range].
func get_free_id(for_ucid: int) -> int:
	if not id_map.has(for_ucid):
		return id_range.x
	for i in id_range.y - id_range.x + 1:
		var test_id := id_range.x + i
		if id_map[for_ucid].has(test_id):
			continue
		return test_id
	return -1


## Returns a free [code]click_id[/code] value to create a new button for all connected UCIDs,
## or [code]-1[/code] if no ID is available in the [member id_range].
func get_free_global_id() -> int:
	var ucids := insim.connections.keys() as Array[int]
	for i in id_range.y - id_range.x + 1:
		var test_id := id_range.x + i
		var valid_id := true
		for ucid in ucids:
			if not id_map.has(ucid):
				continue
			if id_map[ucid].has(test_id):
				valid_id = false
				break
		if valid_id:
			return test_id
	return -1


## Returns all global buttons as an array of [InSimBTNPacket]s, including the given
## [param for_ucid], to be sent to that UCID.
func get_global_buttons(for_ucid: int) -> Array[InSimBTNPacket]:
	var packets: Array[InSimBTNPacket] = []
	for click_id in global_buttons:
		var button := get_button_by_id(click_id, global_buttons[click_id][0] as int)
		var packet := button.get_btn_packet()
		packet.ucid = for_ucid
		packets.append(packet)
		_add_button_mapping(for_ucid, click_id)
	return packets


## Returns an array of [InSimButton] objects corresponding to the global button identified by
## the given [param click_id].
func get_global_button_by_id(click_id: int) -> Array[InSimButton]:
	var found_buttons: Array[InSimButton] = []
	for ucid in insim.connections:
		var button := get_button_by_id(click_id, ucid)
		if button:
			found_buttons.append(button)
	return found_buttons


## Returns an array of [InSimButton] objects corresponding to the global button identified by
## the given [param name].
func get_global_button_by_name(name: String) -> Array[InSimButton]:
	var found_buttons: Array[InSimButton] = []
	for ucid in insim.connections:
		var button := get_button_by_name(name, ucid)
		if button:
			found_buttons.append(button)
	return found_buttons


## Returns an array of [InSimButton] objects corresponding to all global buttons matchin the
## given [param prefix].
func get_global_buttons_by_prefix(prefix: String) -> Array[InSimButton]:
	var found_buttons: Array[InSimButton] = []
	for ucid in insim.connections:
		var button := get_buttons_by_prefix(prefix, ucid)
		if button:
			found_buttons.append(button)
	return found_buttons


## Returns the clickID of the first global button matching the given [param button_name].
## This can help get the clicKID without having to handle the array returned by
## [method get_global_button_by_name]. Returns [code]-1[/code] if no button can be found.
func get_global_button_id_from_name(button_name: String) -> int:
	var button_array := insim.get_global_button_by_name(button_name)
	if not button_array.is_empty():
		return button_array[0].click_id
	return -1


## Returns [code]true[/code] if the given [param ucid] has an entry in [member buttons].
func has_ucid(ucid: int) -> bool:
	return true if buttons.has(ucid) else false


## Adds the given [param new_buttons] to the [member id_map]. If [param register_global] is
## [code]true[/code], the clickIDs and UCIDs will also be added to [member global_buttons].
func register_buttons(new_buttons: Array[InSimButton], register_global := false) -> void:
	for button in new_buttons:
		var ucid := button.ucid
		var click_id := button.click_id
		_add_button_mapping(ucid, click_id)
		if register_global:
			_register_global_button(button)
		if not buttons.has(ucid):
			buttons[ucid] = InSimButtonDictionary.new()
		buttons[ucid].buttons[click_id] = button


## Sends all global buttons to UCID [param for_ucid], and registers them while doing so.
## [param for_ucid], to be sent to that UCID.
func restore_global_buttons(for_ucid: int) -> void:
	var new_buttons: Array[InSimButton] = []
	for click_id in global_buttons:
		if global_buttons[click_id].is_empty():
			var _existed := global_buttons.erase(click_id)
			continue
		var button := get_button_by_id(click_id, global_buttons[click_id][0] as int)
		if not button:
			continue
		var new_button := InSimButton.create(
			for_ucid, click_id, button.inst, button.style, button.position, button.size,
			button.text, button.name, button.type_in, button.caption,
		)
		new_buttons.append(new_button)
		insim.send_packet(new_button.get_btn_packet())
	register_buttons(new_buttons, true)


## Updates the given [param button]'s [param text], and returns an [InSimBTNPacket] to be sent.
func update_button_text(button: InSimButton, text: String, caption := "") -> InSimBTNPacket:
	if button.ucid in disabled_ucids:
		return null
	button.text = text
	button.caption = caption
	return button.get_btn_packet(true)


## Updates the text of the global button (show to every player) identified by its[param click_id],
## using the given [param text], which can be either a [String] or a [Callable] taking a single
## UCID parameter and returning a [String]. Returns an array of [InSimBTNPacket]s corresponding
## to the button's updated text.
func update_global_button_text(click_id: int, text: String, caption := "") -> Array[InSimBTNPacket]:
	var packets: Array[InSimBTNPacket]
	for button in get_global_button_by_id(click_id):
		if button.ucid in disabled_ucids:
			continue
		button.text = text
		button.caption = caption
		packets.append(button.get_btn_packet(true))
	return packets


func _add_button_mapping(for_ucid: int, click_id: int) -> void:
	if not id_map.has(for_ucid):
		id_map[for_ucid] = [click_id]
	elif not id_map[for_ucid].has(click_id):
		id_map[for_ucid].append(click_id)


func _compact_bfn_packets(packets: Array[InSimBFNPacket]) -> Array[InSimBFNPacket]:
	var compacted_packets: Array[InSimBFNPacket] = []
	packets.sort_custom(func(a: InSimBFNPacket, b: InSimBFNPacket) -> bool:
		if 1000 * a.ucid + a.click_id < 1000 * b.ucid + b.click_id:
			return true
		return false
	)
	var count := packets.size()
	var i := 0
	while i < count:
		var packet := packets[i]
		var new_packet := InSimBFNPacket.create(
			packet.subtype, packet.ucid, packet.click_id, packet.click_max
		)
		var j := i + 1
		while j < count:
			var next_packet := packets[j]
			if (
				next_packet.ucid == packet.ucid
				and (
					new_packet.click_max > new_packet.click_id
					and next_packet.click_id == new_packet.click_max + 1
					or next_packet.click_id == new_packet.click_id + 1
				)
			):
				if next_packet.click_max > next_packet.click_id:
					new_packet.click_max = next_packet.click_max
				else:
					new_packet.click_max = next_packet.click_id
				i += 1
				j += 1
			else:
				break
		compacted_packets.append(new_packet)
		i += 1
	return compacted_packets


func _delete_button(ucid: int, click_id: int) -> void:
	_remove_button_mapping(ucid, click_id)
	if not buttons.has(ucid):
		return
	var _discard := buttons[ucid].buttons.erase(click_id)
	if buttons[ucid].buttons.is_empty():
		_discard = buttons.erase(ucid)


func _forget_buttons_for_ucid(ucid: int) -> void:
	if id_map.has(ucid):
		for click_id in id_map[ucid] as Array[int]:
			if global_buttons.has(click_id):
				for global_ucid in global_buttons[click_id] as Array[int]:
					if global_ucid == ucid:
						global_buttons[click_id].erase(global_ucid)
						break
	var _existed := buttons.erase(ucid)
	_existed = id_map.erase(ucid)
	disabled_ucids.erase(ucid)


func _register_global_button(button: InSimButton) -> void:
	var click_id := button.click_id
	var ucid := button.ucid
	if click_id not in global_buttons:
		global_buttons[click_id] = []
	if not global_buttons[click_id].has(ucid):
		global_buttons[click_id].append(ucid)


func _remove_button_mapping(for_ucid: int, click_id: int) -> void:
	if id_map.has(for_ucid):
		id_map[for_ucid].erase(click_id)
