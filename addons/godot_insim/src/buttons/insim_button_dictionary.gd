class_name InSimButtonDictionary
extends RefCounted
## InSimButton dictionary
##
## A [Dictionary] of [InSimButton] objects.

## A [Dictionary] of [InSimButton] objects, with keys corresponding to the buttons' click IDs.
var buttons: Dictionary[int, InSimButton] = {}


## Returns [code]true[/code] if [member buttons] has the [param id] key, otherwise
## returns [code]false[/code].
func has_id(id: int) -> bool:
	return true if buttons.has(id) else false
