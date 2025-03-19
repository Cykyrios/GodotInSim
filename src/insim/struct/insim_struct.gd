class_name InSimStruct
extends RefCounted

## Base class for structs to be used with InSim packets


## Override to define struct behavior.
func _get_buffer() -> PackedByteArray:
	return PackedByteArray()


## Override to define struct behavior.
@warning_ignore("unused_parameter")
func _set_from_buffer(buffer: PackedByteArray) -> void:
	pass


## Override to define struct behavior.
func _set_values_from_gis() -> void:
	pass


## Override to define struct behavior.
func _update_gis_values() -> void:
	pass


## Returns the raw byte data for this struct. If [param use_gis_values] is [code]true[/code],
## all [code]gis_*[/code] variables are used instead of their LFS-style couterparts.
func get_buffer(use_gis_values := false) -> PackedByteArray:
	if use_gis_values:
		_set_values_from_gis()
	return _get_buffer()


func set_from_buffer(buffer: PackedByteArray) -> void:
	_set_from_buffer(buffer)
	_update_gis_values()
