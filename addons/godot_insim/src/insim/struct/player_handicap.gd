class_name PlayerHandicap
extends InSimStruct
## Player handicap
##
## This class contains data about a player's handicap

enum Flag {
	SET_MASS = 1,
	SET_RESTRICTION = 2,
	SILENT = 128,
}

const MASS_MULTIPLIER := 1.0  ## Conversion factor between standard units and LFS-encoded values.

const STRUCT_SIZE := 4  ## The size of this struct's data

const H_MASS_MAX := 200  ## Maximum added mass
const H_TRES_MAX := 50  ## Maximum intake restriction

var plid := 0  ## player's unique id
## bit 0: set [member h_mass] / bit 1: set [member h_tres] (e.g. flags = 3 to set both)
## / bit 7: silent
var flags := 0
var h_mass := 0:  ## 0 to 200 - added mass (kg)
	set(new_mass):
		h_mass = clampi(new_mass, 0, H_MASS_MAX)
var h_tres := 0:  ## 0 to 50 - intake restriction
	set(new_tres):
		h_tres = clampi(new_tres, 0, H_TRES_MAX)

var gis_mass := 0.0  ## Added mass in kg


## Creates and returns a new [PlayerHandicap] from the given parameters.
static func create(
	plh_plid: int, plh_flags: int, added_mass: int, intake_restriction: int
) -> PlayerHandicap:
	var handicap := PlayerHandicap.new()
	handicap.plid = plh_plid
	handicap.flags = plh_flags
	handicap.h_mass = added_mass
	handicap.h_tres = intake_restriction
	handicap.update_gis_values()
	return handicap


## Creates and returns a new [PlayerHandicap] from the given parameters, using standard units
## where applicable.
static func create_from_gis_values(
	plh_plid: int, plh_flags: int, added_mass: float, intake_restriction: int
) -> PlayerHandicap:
	var handicap := PlayerHandicap.new()
	handicap.plid = plh_plid
	handicap.flags = plh_flags
	handicap.gis_mass = added_mass
	handicap.h_tres = intake_restriction
	handicap.set_values_from_gis()
	return handicap


func _to_string() -> String:
	return "(PLID %d, Flags %d, %dkg, %d%%)" % [plid, flags, h_mass, h_tres]


func _get_buffer() -> PackedByteArray:
	var buffer := PackedByteArray()
	var _discard := buffer.resize(STRUCT_SIZE)
	buffer.encode_u8(0, plid)
	buffer.encode_u8(1, flags)
	buffer.encode_u8(2, h_mass)
	buffer.encode_u8(3, h_tres)
	return buffer


func _get_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"Flags": flags,
		"H_Mass": h_mass,
		"H_TRes": h_tres,
	}


func _set_from_buffer(buffer: PackedByteArray) -> void:
	if buffer.size() != STRUCT_SIZE:
		push_error("Wrong buffer size, expected %d, got %d" % [STRUCT_SIZE, buffer.size()])
	plid = buffer.decode_u8(0)
	flags = buffer.decode_u8(1)
	h_mass = buffer.decode_u8(2)
	h_tres = buffer.decode_u8(3)


func _set_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "Flags", "H_Mass", "H_TRes"]):
		return
	plid = dict["PLID"]
	flags = dict["Flags"]
	h_mass = dict["H_Mass"]
	h_tres = dict["H_TRes"]


func _set_values_from_gis() -> void:
	h_mass = roundi(gis_mass * MASS_MULTIPLIER)


func _update_gis_values() -> void:
	gis_mass = h_mass / MASS_MULTIPLIER
