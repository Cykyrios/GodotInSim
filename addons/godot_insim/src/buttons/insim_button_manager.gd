class_name InSimButtonManager
extends RefCounted
## InSimButton manager
##
## This class keeps track of existing [InSimButton]s and allows manipulating buttons.
## An instance is included in the [InSim] object.

## The maximum number of buttons across all InSim apps.
const MAX_BUTTONS := 240

## A reference to the parent [InSim] instance, used to fetch [member InSim.connections]
## for per-player button management.
var insim: InSim = null

## The range of clickIDs this instance can use. This range should remain as small
## as possible to allow other instances or InSim apps to manage their own range of
## buttons, while still allowing all modules to allocate clickIDs freely.
var id_range := Vector2i(0, MAX_BUTTONS - 1):
	set(value):
		id_range = Vector2i(
			clampi(value.x, 0, MAX_BUTTONS - 1),
			clampi(value.y, value.x, MAX_BUTTONS - 1)
		)
## A dictionary mapping all button clickIDs for every UCID, updating every time a button
## is added, updated, or deleted through the provided methods.[br]
## [b]Warning:[/b] While you can read the current mappings by reading this property,
## you should never modify values, or you may break the button tracking.
var id_map: Dictionary[int, Array] = {}
## The list of all buttons that were created using [method add_solo_button] and
## [method add_multi_button]; calling [method delete_button] and [method delete_buttons]
## removes buttons accordingly.[br]
## [b]Warning:[/b] While you can get all buttons by reading this property, you should
## never modify values, or you may break the button tracking.
var buttons: Array[InSimButton] = []
## The list of UCIDs corresponding to players who have disabled InSim buttons (by
## pressing [kbd]Shift + I[/kbd]); adding and updating buttons should be disabled
## for those, with the exception of [member _broadcast_buttons], which by nature
## are sent to everyone.
var disabled_ucids: Array[int] = []

## The list of current broadcast buttons, i.e. [InSimSoloButton] buttons that were
## created with a UCID of [constant InSim.UCID_ALL]; all buttons in this list are
## sent again when a player connects to the server.
var _broadcast_buttons: Array[InSimSoloButton] = []
## The list of current global buttons, i.e. [InSimMultiButton] buttons that were
## created with an empty UCID array, or were declared global by calling
## [method set_global_multi_button]; those are sent to all connected UCIDs as individual
## packets. When a player connects, they receive all currently existing global buttons,
## and their UCID is added to the buttons' mappings; conversely, when a player
## disconnects, their UCID is removed from all buttons.
var _global_buttons: Array[InSimMultiButton] = []


func _init(insim_instance: InSim) -> void:
	insim = insim_instance


## Creates an [InSimMultiButton] from the given parameters, and returns an array of
## [InSimBTNPacket]s corresponding to the created buttons. See [method add_solo_button]
## for more details on general use and parameters. You need to pass an array of
## [param ucids], all of which will have a mapping to their own clickID, text,
## caption, and type_in values. For this reason, instead of the usual [String] and
## [int], you can pass a [Callable] to [param text], [param caption], and [param type_in];
## those should take a single UCID [int] as parameter, and return a [String] ([param text]
## and [param caption]) or an [int] ([param type_in]). This will allow the [InSimMultiButton]
## to generate packets with values tailored to each UCID, while using a single [InSimButton]
## internally, for easier button management. See the example code in
## [method InSim.add_multi_button].
func add_multi_button(
	ucids: Array[int], position: Vector2i, size: Vector2i, style: int, text: Variant,
	button_name := "", type_in: Variant = 0, caption: Variant = "", show_everywhere := false,
) -> Array[InSimBTNPacket]:
	var inst := InSimButton.INST_ALWAYS_ON if show_everywhere else 0
	var button := InSimMultiButton.new(position, size, style, button_name, inst)
	buttons.append(button)
	ucids.erase(InSim.UCID_ALL)
	if ucids.is_empty():
		set_global_multi_button(button, true)
		ucids = insim.connections.keys()
	var packets: Array[InSimBTNPacket] = []
	for ucid in ucids:
		var click_id := _get_free_click_id(ucid)
		if click_id < 0:
			push_error("Cannot add clickID to UCID %d: no clickID available." % [ucid])
			continue
		_apply_multi_button_input(button, ucid, click_id, text, caption, type_in)
		if ucid in disabled_ucids:
			continue
		_add_id_mapping(ucid, click_id)
		if button.get_ucid_mapping(ucid).dirty_flag:
			packets.append(button.get_btn_packet(ucid))
	return packets


## Creates an [InSimSoloButton] from the given parameters, which is added to the
## [member buttons] [Array]. Button creation can fail if there is no clickID available
## in the [member id_range] for the given UCID (when assigning [constant InSim.UCID_ALL],
## there must be a clickID globally available, taking all UCIDs into account).
## Returns an [InSimBTNPacket] corresponding to the created button if successful,
## or returns [code]null[/code] otherwise.[br]
## [param position] and [param size] expect coordinates on the 200x200 canvas LFS
## uses to render buttons on. If [param show_everywhere] is [code]true[/code], the
## button will not be hidden as it usually would in some situations, like pressing
## [code]T[/code] to open the chat input box, or in the garage view; this also means
## you should use it sparingly.[br]
## [b]Tip:[/b] Use the [param button_name] parameter to organize your buttons! You can
## easily create and manage complex button hierarchies by including categories in your
## button names, like [code]menu/sub_menu/title[/code]; when you need to delete an
## entire category, you can call [method delete_buttons] and pass the list returned
## by [method get_buttons_by_prefix].
func add_solo_button(
	ucid: int, position: Vector2i, size: Vector2i, style: int, text: String,
	button_name := "", type_in := 0, caption := "", show_everywhere := false,
) -> InSimBTNPacket:
	var inst := InSimButton.INST_ALWAYS_ON if show_everywhere else 0
	var click_id := _get_free_click_id(ucid)
	if click_id < 0:
		return null
	var button := InSimSoloButton.new(
		ucid, click_id, inst, style, position, size, text, button_name, type_in, caption
	)
	buttons.append(button)
	_add_id_mapping(ucid, click_id)
	if ucid == InSim.UCID_ALL:
		_broadcast_buttons.append(button)
	return button.get_btn_packet(ucid)


## Deletes the given [param button] and returns an array of [InSimBFNPacket]s to be sent
## by [InSim]. You can get a reference to the [param button] by calling one of
## [method get_button_by_id] or [method get_button_by_name], or by getting a button from
## [method get_buttons_by_id_range], [method get_buttons_by_prefix], or
## [method get_buttons_by_regex]. You can also pass specific [param ucids] that should
## have their buttons deleted; this will only affect the [param button] if it is an
## [InSimMultiButton], in which case only the selected UCID mappings will be removed,
## and the button itself will only be deleted when all mappings are removed.
func delete_button(button: InSimButton, ucids: Array[int] = []) -> Array[InSimBFNPacket]:
	if not button:
		push_error("Cannot delete null button.")
		return []
	var packets: Array[InSimBFNPacket] = []
	if button is InSimSoloButton:
		var solo_button := button as InSimSoloButton
		packets.append(InSimBFNPacket.create(
			InSim.ButtonFunction.BFN_DEL_BTN,
			solo_button.ucid,
			solo_button.click_id,
			0,
		))
		_remove_id_mapping(solo_button.ucid, solo_button.click_id)
		if _broadcast_buttons.has(solo_button):
			_broadcast_buttons.erase(solo_button)
		buttons.erase(button)
		button = null
	elif button is InSimMultiButton:
		var multi_button := button as InSimMultiButton
		var ucids_to_remove: Array[int] = ucids.duplicate()
		if ucids_to_remove.is_empty():
			ucids_to_remove = multi_button.ucid_mappings.keys().duplicate()
		for ucid in ucids_to_remove:
			var mapping := multi_button.get_ucid_mapping(ucid)
			packets.append(InSimBFNPacket.create(
				InSim.ButtonFunction.BFN_DEL_BTN,
				ucid,
				mapping.click_id,
				0,
			))
			multi_button.remove_ucid_mapping(ucid)
			_remove_id_mapping(ucid, mapping.click_id)
		if multi_button.ucid_mappings.is_empty():
			if _global_buttons.has(multi_button):
				_global_buttons.erase(multi_button)
			buttons.erase(button)
			button = null
		packets = _compact_bfn_packets(packets)
	return packets


## Deletes an array of buttons [param to_delete], with optional filtering using [param ucids],
## and returns an array of [InSimBFNPacket]s to be sent by [InSim]. All considerations from
## [method delete_button] apply here as well to each button [param to_delete].
func delete_buttons(to_delete: Array[InSimButton], ucids: Array[int] = []) -> Array[InSimBFNPacket]:
	var packets: Array[InSimBFNPacket] = []
	for button in to_delete:
		if not button:
			push_error("Cannot delete null button.")
			continue
		packets.append_array(delete_button(button, ucids))
	packets = _compact_bfn_packets(packets)
	return packets


## Disables button updates by adding [param ucid] to [member disabled_ucids]. Packets
## targetting [param ucid] will not be sent anymore until [method enable_buttons_for_ucid]
## is called.[br]
## [b]Note:[/b] This doesn't prevent broadcast packets ([constant InSim.UCID_ALL])
## from being sent.
func disable_buttons_for_ucid(ucid: int) -> void:
	disabled_ucids.erase(ucid)
	disabled_ucids.append(ucid)


## Allows buttons to be sent to the given [param ucid] again, by removing it from
## [member disabled_ucids]. If button mappings were not removed, all remembered buttons
## are immediately sent again. See [method disable_buttons_for_ucid] for the opposite effect.
func enable_buttons_for_ucid(ucid: int) -> void:
	disabled_ucids.erase(ucid)
	for button in get_broadcast_buttons():
		insim.send_packet(button.get_btn_packet(InSim.UCID_ALL))
	if not id_map.has(ucid):
		# This situation should only occur if all remembered buttons were multi-buttons
		# that got deleted in the meantime.
		return
	for click_id in id_map[ucid] as Array[int]:
		var button := get_button_by_id(ucid, click_id)
		if button:
			insim.send_packet(button.get_btn_packet(ucid))


## Removes all buttons mappings for the given [param ucid]. Mainly intended for [InSim]
## to "forget" players leaving the server.[br]
## [b]Note:[/b] This doesn't clear buttons for the player with the given [param ucid],
## it simply removes internal mapppings.
func forget_buttons_for_ucid(ucid: int) -> void:
	var button_count := buttons.size()
	for i in button_count:
		var idx := button_count - 1 - i
		var button := buttons[idx]
		if button is InSimSoloButton:
			button = null
			buttons.remove_at(idx)
		elif button is InSimMultiButton:
			(button as InSimMultiButton).remove_ucid_mapping(ucid)
	var _existed := id_map.erase(ucid)


## Returns an array of [InSimSoloButton] created with [constant InSim.UCID_ALL].
func get_broadcast_buttons() -> Array[InSimSoloButton]:
	return _broadcast_buttons


## Returns the [InSimButton] matching the given [param click_id] for the given [param ucid],
## or [code]null[/code] if no matching button is found.[br]
## [b]Important:[/b] If a single UCID mapping from an [InSimMultiButton] matches,
## the complete button is returned; if you are using this method to delete buttons,
## make sure not to delete more buttons than intended.
func get_button_by_id(ucid: int, click_id: int) -> InSimButton:
	if not id_map.has(ucid) or not id_map[ucid].has(click_id):
		return null
	for button in buttons:
		if button is InSimSoloButton:
			var solo_button := button as InSimSoloButton
			if solo_button.ucid == ucid and solo_button.click_id == click_id:
				return button
		elif button is InSimMultiButton:
			var multi_button := button as InSimMultiButton
			if multi_button.ucid_mappings.has(ucid):
				if multi_button.ucid_mappings[ucid].click_id == click_id:
					return button
	return null


## Returns all [InSimButton] buttons in the given range of [param click_id] to
## [param click_max] (both ends inclusive) for the given [param ucid], or an empty
## array if no matching button is found.[br]
## [b]Important:[/b] If a single UCID mapping from an [InSimMultiButton] matches,
## the complete button is included in the array; if you are using this method to delete
## buttons, make sure not to delete more buttons than intended.
func get_buttons_by_id_range(ucid: int, click_id: int, click_max := 0) -> Array[InSimButton]:
	if not id_map.has(ucid) or not id_map[ucid].has(click_id):
		return []
	var matching_buttons: Array[InSimButton] = []
	for button in buttons:
		if button is InSimSoloButton:
			var solo_button := button as InSimSoloButton
			if (
				solo_button.ucid == ucid
				and solo_button.click_id >= click_id
				and solo_button.click_id <= click_max
			):
				matching_buttons.append(solo_button)
		elif button is InSimMultiButton:
			var multi_button := button as InSimMultiButton
			if (
				multi_button.ucid_mappings.has(ucid)
				and multi_button.ucid_mappings[ucid].click_id >= click_id
				and multi_button.ucid_mappings[ucid].click_id <= click_max
				and multi_button not in matching_buttons
			):
				matching_buttons.append(multi_button)
	return matching_buttons


## Returns the first [InSimButton] matching the given [param name] for the given [param ucid],
## or [code]null[/code] if no matching button is found.[br]
## [b]Note:[/b] If multiple buttons have the same name, the returned button may not be
## the expected one; you should always make sure to give unique names to your buttons.
func get_button_by_name(ucid: int, name: StringName) -> InSimButton:
	if not id_map.has(ucid):
		return null
	for button in buttons:
		if button.name == name:
			return button
	return null


## Returns all [InSimButton]s whose name starts with the given [param prefix] for
## the given [param ucid], or an empty array if no matching button is found.
func get_buttons_by_prefix(ucid: int, prefix: StringName) -> Array[InSimButton]:
	if not id_map.has(ucid):
		return []
	var matching_buttons: Array[InSimButton] = []
	for button in buttons:
		if button.name.begins_with(prefix):
			matching_buttons.append(button)
	return matching_buttons


## Returns all [InSimButton]s whose name matches the given [param regex] for the
## given [param ucid], or an empty array if no matching button is found.
func get_buttons_by_regex(ucid: int, regex: RegEx) -> Array[InSimButton]:
	if not id_map.has(ucid):
		return []
	var matching_buttons: Array[InSimButton] = []
	for button in buttons:
		if regex.search(button.name):
			matching_buttons.append(button)
	return matching_buttons


## Returns all global buttons as an array of [InSimBTNPacket]s targetting the given
## [param for_ucid], to be sent to the corresponding player.
func get_global_button_packets(for_ucid: int) -> Array[InSimBTNPacket]:
	var packets: Array[InSimBTNPacket] = []
	for button in _global_buttons:
		var packet := button.get_btn_packet(for_ucid)
		packets.append(packet)
		_add_id_mapping(for_ucid, button.ucid_mappings[for_ucid].click_id)
	return packets


## Returns all [InSimMultiButton]s that were either created with an empty UCID array,
## or later marked as global with [method set_global_multi_button].
func get_global_buttons() -> Array[InSimMultiButton]:
	return _global_buttons


## Sets the allowed clickID range for created buttons from [param min_id] to [param max_id]
## (both ends inclusive). Existing buttons with clickIDs outside of the new range are
## not deleted.
func set_click_id_range(min_id: int, max_id: int) -> void:
	id_range = Vector2i(min_id, max_id)


## Sets the given [param button] as a global button, or unsets it.
## See [member _global_buttons] for more info.
func set_global_multi_button(button: InSimMultiButton, global: bool) -> void:
	if global and button not in _global_buttons:
		_global_buttons.append(button)
		for ucid in insim.connections.keys() as Array[int]:
			if not button.ucid_mappings.has(ucid):
				button.add_ucid_mapping(ucid, _get_free_click_id(ucid), "")
	elif not global:
		_global_buttons.erase(button)


## Updates the given [param button]'s [param text] and [param caption], and optionally its
## [param type_in], and returns an [InSimBTNPacket] to be sent. A value of [code]-1[/code]
## for [param type_in] will leave it unchanged. To avoid changing the [param caption],
## this function should pass [code]button.caption[/code] to [param caption].
func update_solo_button(
	button: InSimSoloButton, text: String, caption := "", type_in := -1
) -> InSimBTNPacket:
	if button.ucid in disabled_ucids:
		return null
	button.text = text
	button.caption = caption
	if type_in > -1:
		button.type_in = type_in
	return button.get_btn_packet(true)


## Updates the [param text] of the given [param button], its [param caption], and optionally
## its [param type_in] (see [method update_solo_button] for more details), and returns
## an array of [InSimBTNPacket]s to be sent by [InSim]. As for [method add_multi_button],
## you can pass a [Callable] to [param text], [param caption], and [param type_in] for
## values tailored to each UCID.[br]
## [b]Note:[/b] The returned array only contains packets corresponding to buttons that
## were actually updated, to avoid sending unnecessary packets.
func update_multi_button(
	button: InSimMultiButton, text: Variant, caption: Variant = "", type_in: Variant = -1
) -> Array[InSimBTNPacket]:
	var packets: Array[InSimBTNPacket]
	for ucid in button.ucid_mappings:
		_apply_multi_button_input(
			button, ucid, button.ucid_mappings[ucid].click_id, text, caption, type_in
		)
		if button.get_ucid_mapping(ucid).dirty_flag:
			packets.append(button.get_btn_packet(ucid, true))
	return packets


# Intended for use by [InSim] only, when a new player joins the server.
func _add_global_button_mapping(ucid: int) -> void:
	for button in _global_buttons:
		button.add_ucid_mapping(ucid, _get_free_click_id(ucid), "")


func _add_id_mapping(ucid: int, click_id: int) -> void:
	if not id_map.has(ucid):
		id_map[ucid] = []
	id_map[ucid].erase(click_id)
	id_map[ucid].append(click_id)


func _apply_multi_button_input(
	button: InSimMultiButton, ucid: int, click_id: int, text: Variant,
	caption: Variant, type_in: Variant,
) -> void:
	var mapping := button.get_ucid_mapping(ucid)
	if not mapping:
		button.add_ucid_mapping(ucid, click_id, "")
	var button_text := "^1INVALID"  # Error message if no String or valid Callable
	var text_type := typeof(text)
	if text_type in [TYPE_STRING, TYPE_STRING_NAME]:
		button_text = str(text)
	elif text_type == TYPE_CALLABLE:
		var text_function := text as Callable
		if text_function.is_valid():
			button_text = text_function.call(ucid)
	var button_caption := "^1INVALID"  # Error message if no String or valid Callable
	var caption_type := typeof(caption)
	if caption_type in [TYPE_STRING, TYPE_STRING_NAME]:
		button_caption = str(caption)
	elif caption_type == TYPE_CALLABLE:
		var caption_function := caption as Callable
		if caption_function.is_valid():
			button_caption = caption_function.call(ucid)
	var button_type_in := 0
	var type_in_type := typeof(type_in)
	if type_in_type == TYPE_INT:
		if type_in > -1:
			button_type_in = type_in
	elif type_in_type == TYPE_CALLABLE:
		var type_in_function := type_in as Callable
		if type_in_function.is_valid():
			button_type_in = type_in_function.call(ucid)
	button.update_ucid_mapping(ucid, button_text, button_caption, button_type_in)


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


# Returns -1 if no ID is available in id_range.
func _get_free_click_id(for_ucid: int) -> int:
	if (
		for_ucid != InSim.UCID_ALL
		and not id_map.has(for_ucid)
		and not id_map.has(InSim.UCID_ALL)
	):
		return id_range.x
	if for_ucid == InSim.UCID_ALL:
		for i in id_range.y - id_range.x + 1:
			var test_id := id_range.x + i
			if id_map.has(InSim.UCID_ALL) and id_map[InSim.UCID_ALL].has(test_id):
				continue
			var invalid_id := false
			for ucid in id_map:
				if id_map[ucid].has(test_id):
					invalid_id = true
					break
			if invalid_id:
				continue
			return test_id
	else:
		for i in id_range.y - id_range.x + 1:
			var test_id := id_range.x + i
			if (
				id_map.has(for_ucid) and id_map[for_ucid].has(test_id)
				or id_map.has(InSim.UCID_ALL) and id_map[InSim.UCID_ALL].has(test_id)
			):
				continue
			return test_id
	return -1


func _remove_button_mapping(for_ucid: int, click_id: int) -> void:
	if id_map.has(for_ucid):
		id_map[for_ucid].erase(click_id)


func _remove_id_mapping(ucid: int, click_id: int) -> void:
	if not id_map.has(ucid):
		return
	id_map[ucid].erase(click_id)
	if id_map[ucid].is_empty():
		var _existed := id_map.erase(ucid)
