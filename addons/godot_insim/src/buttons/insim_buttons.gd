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
## Current known buttons. Any InSim app using buttons should listen to [InSimBTNPacket] and
## [InSimBFNPacket] to keep this array as up to date as possible, using the button's
## [code]req_i[/code] to distinguish buttons created by other apps.
var buttons: Dictionary[int, InSimButton] = {}


## Creates and returns an [InSimButton] from the given parameters. If successful, the button is
## added to the [member buttons] [Dictionary] and the corresponding [InsimBTNPacket] is sent
## for each UCID in [param ucids]; otherwise returns [code]null[/code]. This function
## fails if there is no clickID available for the button.
func add_button(
	ucids: Array[int], position: Vector2i, size: Vector2i, style: int, show_everywhere: bool, text: String,
	caption := "", type_in := 0
) -> Array[InSimBTNPacket]:
	var new_id := get_free_id()
	if new_id == -1:
		push_warning("Cannot create button: no clickID available.")
		return []
	var inst := 0 | (InSimButton.INST_ALWAYS_ON if show_everywhere else 0)
	var button := InSimButton.create(
		ucids, new_id, inst, style, type_in, position, size, text, caption
	)
	buttons[new_id] = button
	var packets: Array[InSimBTNPacket] = []
	for ucid in ucids:
		var packet := InSimBTNPacket.create(ucid, new_id, inst, style, type_in,
				position.x, position.y, size.x, size.y, text, caption)
		packets.append(packet)
	return packets


## Returns an [InSimBFNPacket] requesting the deletion of the given button, if the button is
## found in the [member buttons] [Dictionary]; otherwise, returns [code]null[/code].
func delete_button(button: InSimButton, ucids: Array[int]) -> Array[InSimBFNPacket]:
	var packets: Array[InSimBFNPacket] = []
	var button_id := button.click_id
	if has_id(button_id):
		for ucid in ucids:
			if button.ucids.find(ucid) != -1:
				var packet := InSimBFNPacket.create(
					InSim.ButtonFunction.BFN_DEL_BTN, ucid, button.click_id, 0
				)
				packets.append(packet)
				button.ucids.erase(ucid)
		buttons.erase(button_id)
	return packets


## Returns the [InSimButton] at the given [param id], or [code]null[/code] if it does not exist.
func get_button_from_id(id: int) -> InSimButton:
	if has_id(id):
		return buttons[id]
	return null


## Returns a free [code]click_id[/code] value to create a new button, or [code]-1[/code]
## if no ID is available in the [member id_range].
func get_free_id() -> int:
	for i in id_range.y - id_range.x + 1:
		var test_id := id_range.x + i
		if has_id(test_id):
			continue
		return test_id
	return -1


func has_id(id: int) -> bool:
	return true if buttons.has(id) else false
