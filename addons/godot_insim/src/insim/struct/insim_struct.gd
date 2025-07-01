class_name InSimStruct
extends RefCounted
## InSim struct base class
##
## Base class for structs to be used with InSim packets.


## Override to define struct behavior. [method get_buffer] calls [method _set_values_from_gis]
## before calling this method, if relevant.
func _get_buffer() -> PackedByteArray:
	return PackedByteArray()


## Override to define struct behavior.
func _get_dictionary() -> Dictionary:
	return {}


## Override to define struct behavior. [method set_from_buffer] calls [method update_gis_values],
## it is there for unnecessary to add a call to it.
@warning_ignore("unused_parameter")
func _set_from_buffer(buffer: PackedByteArray) -> void:
	pass


## Override to define struct behavior.
@warning_ignore("unused_parameter")
func _set_from_dictionary(dict: Dictionary) -> void:
	pass


## Override to define struct behavior.
func _set_values_from_gis() -> void:
	pass


## Override to define struct behavior.
func _update_gis_values() -> void:
	pass


## Returns the raw byte data for this struct. If [param use_gis_values] is [code]true[/code],
## all [code]gis_*[/code] variables are used instead of their LFS-style counterparts.
func get_buffer(use_gis_values := false) -> PackedByteArray:
	if use_gis_values:
		_set_values_from_gis()
	return _get_buffer()


## Returns a dictionary representing the struct's data. See [method _get_dictionary]
## for implementation.
func get_dictionary() -> Dictionary:
	return _get_dictionary()


## Updates the struct's variables from the provided [param buffer]. Also calls
## [method update_gis_values], for structs that use [code]gis_*[/code] values.
func set_from_buffer(buffer: PackedByteArray) -> void:
	_set_from_buffer(buffer)
	update_gis_values()


## Updates the struct's variables from the provided [param dict]. Care should be taken
## to verify dictionary keys.
func set_from_dictionary(dict: Dictionary) -> void:
	_set_from_dictionary(dict)
	update_gis_values()


## Updates LFS-encoded variables from [code]gis_*[/code] variables. This behavior must be
## defined in [method _set_values_from_gis].
func set_values_from_gis() -> void:
	_set_values_from_gis()


## Updates [code]gis_*[/code] variables from LFS-encoded variables. This behavior must be
## defined in [method _update_gis_values].
func update_gis_values() -> void:
	_update_gis_values()


# For use in _set_from_dictionary()
func _check_dictionary_keys(dict: Dictionary, keys: Array[String]) -> bool:
	if not dict.has_all(keys):
		push_error("Cannot set data from dictionary: missing keys")
		return false
	return true
