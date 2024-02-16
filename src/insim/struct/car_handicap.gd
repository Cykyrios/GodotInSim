class_name CarHandicap
extends RefCounted


const STRUCT_SIZE := 2

const H_MASS_MAX := 200
const H_TRES_MAX := 50
var h_mass := 0:  ## 0 to 200 - added mass (kg)
	set(new_mass):
		h_mass = clampi(new_mass, 0, H_MASS_MAX)
var h_tres := 0:  ## 0 to 50 - intake restriction
	set(new_tres):
		h_tres = clampi(new_tres, 0, H_TRES_MAX)

func _to_string() -> String:
	return "(%dkg, %d%%)" % [h_mass, h_tres]


func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	buffer.resize(STRUCT_SIZE)
	buffer.encode_u8(0, h_mass)
	buffer.encode_u8(1, h_tres)
	return buffer


func set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	h_mass = buffer.decode_u8(0)
	h_tres = buffer.decode_u8(1)
