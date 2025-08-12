class_name InSimMultiButton
extends InSimButton
## InSim Button assigned to multiple UCIDs
##
## The [InSimMultiButton] represents a common button sent to multiple players, with text
## that can be customized for each player. It can be sent to a specific list of players,
## or to everyone as a global button.

## A dictionary of UCID mappings, i.e. all UCIDs for which to display the button,
## and the data to display for each of them. [constant InSim.UCID_ALL] cannot be
## a valid key.
var ucid_mappings: Dictionary[int, UCIDMapping] = {}


func _init(b_position: Vector2i, b_size: Vector2i, b_style := 0, b_name := "", b_inst := 0) -> void:
	position = b_position
	size = b_size
	style = b_style
	name = b_name
	inst = b_inst


func _get_btn_packet(for_ucid: int) -> InSimBTNPacket:
	var mapping := get_ucid_mapping(for_ucid)
	if not mapping:
		return null
	var packet := InSimBTNPacket.create(
		for_ucid,
		mapping.click_id,
		inst,
		style,
		mapping.type_in,
		position.x,
		position.y,
		size.x,
		size.y,
		mapping.text,
		mapping.caption,
	)
	return packet


func _get_caption(for_ucid: int) -> String:
	var mapping := get_ucid_mapping(for_ucid)
	if not mapping:
		return ""
	return mapping.caption


func _get_click_id(for_ucid: int) -> int:
	var mapping := get_ucid_mapping(for_ucid)
	if not mapping:
		return -1
	return mapping.click_id


func _get_text(for_ucid: int) -> String:
	var mapping := get_ucid_mapping(for_ucid)
	if not mapping:
		return ""
	return mapping.text


func _get_type_in(for_ucid: int) -> int:
	var mapping := get_ucid_mapping(for_ucid)
	if not mapping:
		return -1
	return mapping.type_in


## Add a [UCIDMapping] to [member ucid_mappings] with the given parameters.
func add_ucid_mapping(
	for_ucid: int, click_id: int, text: String, caption := "", type_in := 0
) -> void:
	ucid_mappings[for_ucid] = UCIDMapping.create(for_ucid, click_id, type_in, text, caption)


## Deletes all UCID mappings for this button.
func clear_ucid_mappings() -> void:
	ucid_mappings.clear()


## Returns the [UCIDMapping] associated with the given [param for_ucid].
func get_ucid_mapping(for_ucid: int) -> UCIDMapping:
	return ucid_mappings[for_ucid] if ucid_mappings.has(for_ucid) else null


## Removes the [UCIDMapping] associated with the given [param for_ucid], if it exists.
func remove_ucid_mapping(for_ucid: int) -> void:
	var _existed := ucid_mappings.erase(for_ucid)


## Updates the data contained in the [UCIDMapping] asociated with the given [param for_ucid].
## Fails if [param for_ucid] is not a valid UCID for this button.
func update_ucid_mapping(
	for_ucid: int, text: String, caption := "", type_in := 0, click_id := -1
) -> void:
	var mapping := get_ucid_mapping(for_ucid)
	if not mapping:
		push_error("Cannot update MultiButton mapping: UCID %d not found" % [for_ucid])
		return
	if (
		text != mapping.text
		or caption != mapping.caption
		or type_in != mapping.type_in
	):
		mapping.dirty_flag = true
	mapping.type_in = type_in
	mapping.text = text
	mapping.caption = caption
	if click_id != -1 and click_id != mapping.click_id:
		mapping.click_id = click_id
		mapping.dirty_flag = true
