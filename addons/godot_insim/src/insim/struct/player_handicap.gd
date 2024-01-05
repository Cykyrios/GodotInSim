class_name PlayerHandicap
extends RefCounted


const STRUCT_SIZE := 4

const H_MASS_MAX := 200
const H_TRES_MAX := 50

var player_id := 0
var flags := 0
var h_mass := 0:
	set(new_mass):
		h_mass = clampi(new_mass, 0, H_MASS_MAX)
var h_tres := 0:
	set(new_tres):
		h_tres = clampi(new_tres, 0, H_TRES_MAX)


func _to_string() -> String:
	return "(PLID %d, Flags %d, %dkg, %d%%)" % [player_id, flags, h_mass, h_tres]


func get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u8(0, player_id)
	buffer.encode_u8(1, flags)
	buffer.encode_u8(2, h_mass)
	buffer.encode_u8(3, h_tres)
	return buffer


func set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	player_id = buffer.decode_u8(0)
	flags = buffer.decode_u8(1)
	h_mass = buffer.decode_u8(2)
	h_tres = buffer.decode_u8(3)
