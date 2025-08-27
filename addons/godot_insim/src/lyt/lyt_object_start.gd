class_name LYTObjectStart
extends LYTObject
## LYT start position object
##
## Specific layout object representing a starting position (grid box).

const MIN_POSITION := 0  ## Minimum position index ([code]start_position - 1[/code])
const MAX_POSITION := 47  ## Maximum position index ([code]start_position - 1[/code])

var start_position := 0  ## Start position (0 is not a valid number)


func _apply_flags() -> void:
	start_position = flags & 0x3f + 1


func _update_flags() -> void:
	flags = (flags & ~0x3f) | clampi(start_position - 1, MIN_POSITION, MAX_POSITION)
