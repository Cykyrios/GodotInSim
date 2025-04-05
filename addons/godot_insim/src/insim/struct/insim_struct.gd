class_name InSimStruct
extends RefCounted

## Base class for structs to be used with InSim packets


## Override to define struct behavior.
func _get_buffer() -> PackedByteArray:
	return PackedByteArray()


## Override to define struct behavior. This should also call [method update_gis_values] if relevant.
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


## Updates the struct's variables from the provided [param buffer].
func set_from_buffer(buffer: PackedByteArray) -> void:
	_set_from_buffer(buffer)


## Updates variables from [code]gis_*[/code] variables. This behavior must be defined in
## [method _set_values_from_gis].
func set_values_from_gis() -> void:
	_set_values_from_gis()


## Updates [code]gis_* variables[/code]; this behavior is defined in [method _update_gis_values].
func update_gis_values() -> void:
	_update_gis_values()
