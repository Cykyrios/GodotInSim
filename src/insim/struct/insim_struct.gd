class_name InSimStruct
extends RefCounted

## Base class for structs to be used with InSim packets

## If true, all variables starting with [code]gis_*[/code] will be converted to their LFS format
## counterpart when filling the packet's buffer.
var use_gis_values := true


## Override to define struct behavior.
func _get_buffer() -> PackedByteArray:
	return PackedByteArray()


## Override to define struct behavior.
func _set_from_buffer(buffer: PackedByteArray) -> void:
	pass


## Override to define struct behavior.
func _set_values_from_gis() -> void:
	pass


## Override to define struct behavior.
func _update_gis_values() -> void:
	pass


func get_buffer() -> PackedByteArray:
	if use_gis_values:
		_set_values_from_gis()
	return _get_buffer()


func set_from_buffer(buffer: PackedByteArray) -> void:
	_set_from_buffer(buffer)
	_update_gis_values()
