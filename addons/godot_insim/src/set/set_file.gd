class_name SETFile
extends LFSPacket
## LFS Setup file
##
## This class can decode setup files from the game, as well as save new or modified setups.
## All values use metric units (Pa for pressures, m for lengths, etc.), and should be converted
## to the desired display units.

## The size of a setup's data.
const STRUCT_SIZE := 132

## File header, always equal to [code]SRSETT[/code].
var header := "SRSETT"
## Used to validate setup files.
var internal_version := 252
## Used to validate setup files.
var format_version := 2
## Setup flags, replaced with boolean values.
var flags := 0:
	set(value):
		flags = value
		symmetric_wheels = flags & InSim.Setup.SETF_SYMM_WHEELS
		abs_enabled = flags & InSim.Setup.SETF_ABS_ENABLE
		tc_enabled = flags & InSim.Setup.SETF_TC_ENABLE

## The vehicle configuration (e.g. DEFAULT or OPEN ROOF for the UF1) - integer value.
var configuration := 0
## Voluntary added mass.
var added_mass := 0
## Added mass position.
var added_mass_position := 50
## Voluntary intake restriction.
var intake_restriction := 0

## Maximum per-wheel brake torque.
var brake_max := 0
## Brake balance.
var brake_balance := 50
## Maximum per-wheel handbrake torque.
var handbrake := 0
## Engine brake reduction.
var engine_brake_reduction := 0
## ABS on/off.
var abs_enabled := false
## TC on/off.
var tc_enabled := false
## TC allowed slip.
var tc_slip := 5.0
## TC minimuim speed.
var tc_speed := 50

## Rear suspension ride height reduction.
var suspension_rear_height := 0.1
## Rear suspension stiffness.
var suspension_rear_stiffness := 30.0
## Rear suspension bump damping.
var suspension_rear_bump_damping := 5.0
## Rear suspension rebound damping.
var suspension_rear_rebound_damping := 5.0
## Rear suspension anti-roll stiffness.
var suspension_rear_arb := 0.0
## Front suspension ride height reduction.
var suspension_front_height := 0.1
## Front suspension stiffness.
var suspension_front_stiffness := 30.0
## Front suspension bump damping.
var suspension_front_bump_damping := 5.0
## Front suspension rebound damping.
var suspension_front_rebound_damping := 5.0
## Front suspension anti-roll stiffness.
var suspension_front_arb := 0.0

## Maximum steering lock.
var steer_lock := 36
## Parallel steer.
var steer_parallel := 50
## Front caster.
var caster_front := 0.0
## Rear caster (always zero?).
var caster_rear := 0.0
## Front toe in.
var toe_front := 0.0
## Rear toe in.
var toe_rear := 0.0

## Front differential type.
var front_diff_type := 0
## Front differential viscous torque.
var front_diff_viscous := 0
## Front differential lock (power).
var front_diff_lock_power := 10
## Front differential lock (coast).
var front_diff_lock_coast := 10
## Front differential preload.
var front_diff_preload := 0
## Rear differential type.
var rear_diff_type := 0
## Rear differential viscous torque.
var rear_diff_viscous := 0
## Rear differential lock (power).
var rear_diff_lock_power := 10
## Rear differential lock (coast).
var rear_diff_lock_coast := 10
## Rear differential preload.
var rear_diff_preload := 0
## Torque split.
var torque_split := 50
## Center differential type.
var center_diff_type := 0
## Center differential viscous torque.
var center_diff_viscous := 0
## Final drive.
var final_drive := 2.5
## First gear ratio.
var gear_1 := 6.0
## Second gear ratio.
var gear_2 := 4.2
## Third gear ratio.
var gear_3 := 3.0
## Fourth gear ratio.
var gear_4 := 2.2
## Fifth gear ratio.
var gear_5 := 1.6
## Sixth gear ratio.
var gear_6 := 1.2
## Seventh gear ratio.
var gear_7 := 1.0

## Tyre manufacturer.
var tyre_manufacturer := 0
## Symmetric wheels.
var symmetric_wheels := true
## Front tyre size (for GTR class alternate configuration).
var front_tyre_size := 0
## Front tyre compound.
var front_tyre_compound := InSim.Tyre.TYRE_R1
## Front left tyre pressure.
var front_tyre_pressure_left := 200
## Front right tyre pressure.
var front_tyre_pressure_right := 200
## Front left tyre camber.
var front_tyre_camber_left := 0.0
## Front right tyre camber.
var front_tyre_camber_right := 0.0
## Rear tyre size (for GTR class alternate configuration).
var rear_tyre_size := 0
## Rear tyre compound.
var rear_tyre_compound := InSim.Tyre.TYRE_R1
## Rear left tyre pressure.
var rear_tyre_pressure_left := 200
## Rear right tyre pressure.
var rear_tyre_pressure_right := 200
## Rear left tyre camber.
var rear_tyre_camber_left := 0.0
## Rear right tyre camber.
var rear_tyre_camber_right := 0.0

## Front wing angle.
var front_wing_angle := 0
## Rear wing angle.
var rear_wing_angle := 0

## Passengers (2 bits per passenger, converted to booleans).
var passengers := 0:
	set(value):
		passengers = value
		passenger_front = passengers & 0b0000_0011
		passenger_rear_left = passengers & 0b0000_1100
		passenger_rear_middle = passengers & 0b0011_0000
		passenger_rear_right = passengers & 0b1100_0000
## Front passenger.
var passenger_front := 0
## Rear left passenger.
var passenger_rear_left := 0
## Rear middle passenger.
var passenger_rear_middle := 0
## Rear right passenger.
var passenger_rear_right := 0


## Creates and returns a new [SETFile] from the file at [param path].
static func create_from_file(path: String) -> SETFile:
	var setup := SETFile.new()
	setup.load_from_file(path)
	return setup


#region conversions
## Converts an LFS-encoded camber value to the corresponding angle in degrees.
static func camber_from_LFS_value(value: int) -> float:
	return snappedf(-4.5 + 0.1 * value, 0.1)


## Converts camber from an angle in degrees to the corresponding LFS-encoded value.
static func camber_to_LFS_value(value: float) -> int:
	return roundi(10 * value + 45)


## Converts an LFS-encoded gear ratio to its actual value.
static func gear_ratio_from_LFS_value(value: int) -> float:
	return snappedf(value * 7.0 / 65_534 + 0.5, 0.001)


## Converts a gear ratio to its LFS-encoded value.
static func gear_ratio_to_LFS_value(value: float) -> int:
	return roundi((value - 0.5) * 65_534 / 7.0)


## Converts an LFS-encoded toe value to the corresponding angle in degrees.
static func toe_from_LFS_value(value: int) -> float:
	return snappedf(-0.9 + 0.1 * value, 0.1)


## Converts toe from an angle in degrees to the corresponding LFS-encoded value.
static func toe_to_LFS_value(value: float) -> int:
	return roundi(10 * value + 9)
#endregion


## Decodes a setup from the given [param data_buffer] and fills the [SETFile]'s properties.
func decode_setup_buffer(data_buffer: PackedByteArray) -> void:
	buffer = data_buffer.duplicate()
	header = read_string(6, false)
	var _discard := read_buffer(1)
	internal_version = read_byte()
	format_version = read_byte()
	_discard = read_buffer(3)
	flags = read_byte()
	_discard = read_buffer(1)
	added_mass_position = read_byte()
	tyre_manufacturer = read_byte()
	brake_max = int(read_float())
	rear_wing_angle = read_byte()
	front_wing_angle = read_byte()
	added_mass = read_byte()
	intake_restriction = read_byte()
	steer_lock = read_byte()
	steer_parallel = read_byte()
	brake_balance = read_byte()
	engine_brake_reduction = read_byte()
	center_diff_type = read_byte()
	center_diff_viscous = read_byte()
	_discard = read_buffer(1)
	torque_split = read_byte()
	gear_7 = gear_ratio_from_LFS_value(read_word())
	final_drive = gear_ratio_from_LFS_value(read_word())
	gear_1 = gear_ratio_from_LFS_value(read_word())
	gear_2 = gear_ratio_from_LFS_value(read_word())
	gear_3 = gear_ratio_from_LFS_value(read_word())
	gear_4 = gear_ratio_from_LFS_value(read_word())
	gear_5 = gear_ratio_from_LFS_value(read_word())
	gear_6 = gear_ratio_from_LFS_value(read_word())
	passengers = read_byte()
	configuration = read_byte()
	tc_slip = read_byte() / 10.0
	tc_speed = read_byte()
	suspension_rear_height = read_float()
	suspension_rear_stiffness = read_float() / 1000.0
	suspension_rear_bump_damping = read_float() / 1000.0
	suspension_rear_rebound_damping = read_float() / 1000.0
	suspension_rear_arb = read_float() / 1000.0
	handbrake = int(read_float())
	toe_rear = toe_from_LFS_value(read_byte())
	caster_rear = read_byte() / 10.0
	rear_tyre_compound = read_byte() as InSim.Tyre
	_discard = read_buffer(1)
	rear_tyre_camber_left = camber_from_LFS_value(read_byte())
	rear_tyre_camber_right = camber_from_LFS_value(read_byte())
	rear_tyre_size = read_byte()
	rear_diff_preload = read_byte() * 10
	rear_diff_type = read_byte()
	rear_diff_viscous = read_byte()
	rear_diff_lock_power = read_byte()
	rear_diff_lock_coast = read_byte()
	rear_tyre_pressure_left = read_word()
	rear_tyre_pressure_right = read_word()
	suspension_front_height = read_float()
	suspension_front_stiffness = read_float() / 1000.0
	suspension_front_bump_damping = read_float() / 1000.0
	suspension_front_rebound_damping = read_float() / 1000.0
	suspension_front_arb = read_float() / 1000.0
	_discard = read_buffer(4)
	toe_front = toe_from_LFS_value(read_byte())
	caster_front = read_byte() / 10.0
	front_tyre_compound = read_byte() as InSim.Tyre
	_discard = read_buffer(1)
	front_tyre_camber_left = camber_from_LFS_value(read_byte())
	front_tyre_camber_right = camber_from_LFS_value(read_byte())
	front_tyre_size = read_byte()
	front_diff_preload = read_byte() * 10
	front_diff_type = read_byte()
	front_diff_viscous = read_byte()
	front_diff_lock_power = read_byte()
	front_diff_lock_coast = read_byte()
	front_tyre_pressure_left = read_word()
	front_tyre_pressure_right = read_word()


## Encodes the current setup and returns the corresponding [PackedByteArray] buffer.
func encode_setup_buffer() -> PackedByteArray:
	buffer.clear()
	resize_buffer(STRUCT_SIZE)
	data_offset = 0
	var _discard := add_string(6, header, false)
	add_buffer([0])
	add_byte(internal_version)
	add_byte(format_version)
	add_buffer([0, 0, 0])
	_update_flags()
	add_byte(flags)
	add_buffer([0])
	add_byte(added_mass_position)
	add_byte(tyre_manufacturer)
	add_float(brake_max)
	add_byte(rear_wing_angle)
	add_byte(front_wing_angle)
	add_byte(added_mass)
	add_byte(intake_restriction)
	add_byte(steer_lock)
	add_byte(steer_parallel)
	add_byte(brake_balance)
	add_byte(engine_brake_reduction)
	add_byte(center_diff_type)
	add_byte(center_diff_viscous)
	add_buffer([0])
	add_byte(torque_split)
	add_word(gear_ratio_to_LFS_value(gear_7))
	add_word(gear_ratio_to_LFS_value(final_drive))
	add_word(gear_ratio_to_LFS_value(gear_1))
	add_word(gear_ratio_to_LFS_value(gear_2))
	add_word(gear_ratio_to_LFS_value(gear_3))
	add_word(gear_ratio_to_LFS_value(gear_4))
	add_word(gear_ratio_to_LFS_value(gear_5))
	add_word(gear_ratio_to_LFS_value(gear_6))
	add_byte(passengers)
	add_byte(configuration)
	add_byte(roundi(tc_slip * 10))
	add_byte(tc_speed)
	add_float(suspension_rear_height)
	add_float(suspension_rear_stiffness * 1000)
	add_float(suspension_rear_bump_damping * 1000)
	add_float(suspension_rear_rebound_damping * 1000)
	add_float(suspension_rear_arb * 1000)
	add_float(handbrake)
	add_byte(toe_to_LFS_value(toe_rear))
	add_byte(roundi(caster_rear * 10))
	add_byte(rear_tyre_compound)
	add_buffer([0])
	add_byte(camber_to_LFS_value(rear_tyre_camber_left))
	add_byte(camber_to_LFS_value(rear_tyre_camber_right))
	add_byte(rear_tyre_size)
	add_byte(roundi(rear_diff_preload / 10.0))
	add_byte(rear_diff_type)
	add_byte(rear_diff_viscous)
	add_byte(rear_diff_lock_power)
	add_byte(rear_diff_lock_coast)
	add_word(rear_tyre_pressure_left)
	add_word(rear_tyre_pressure_right)
	add_float(suspension_front_height)
	add_float(suspension_front_stiffness * 1000)
	add_float(suspension_front_bump_damping * 1000)
	add_float(suspension_front_rebound_damping * 1000)
	add_float(suspension_front_arb * 1000)
	add_buffer([0, 0, 0, 0])
	add_byte(toe_to_LFS_value(toe_front))
	add_byte(roundi(caster_front * 10))
	add_byte(front_tyre_compound)
	add_buffer([0])
	add_byte(camber_to_LFS_value(front_tyre_camber_left))
	add_byte(camber_to_LFS_value(front_tyre_camber_right))
	add_byte(front_tyre_size)
	add_byte(roundi(front_diff_preload / 10.0))
	add_byte(front_diff_type)
	add_byte(front_diff_viscous)
	add_byte(front_diff_lock_power)
	add_byte(front_diff_lock_coast)
	add_word(front_tyre_pressure_left)
	add_word(front_tyre_pressure_right)
	return buffer.duplicate()


## Decodes the setup file at [param path].
func load_from_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		var error := FileAccess.get_open_error()
		push_error("File open error %d" % [error])
		return
	decode_setup_buffer(file.get_buffer(file.get_length()))


## Saves the current setup to the given [param path].
func save_to_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if not file:
		var error := FileAccess.get_open_error()
		push_error("File open error %d" % [error])
		return
	if not file.store_buffer(encode_setup_buffer()):
		push_error("Failed to write setup to file")


func _update_flags() -> void:
	flags = (
		int(symmetric_wheels) * InSim.Setup.SETF_SYMM_WHEELS
		+ int(abs_enabled) * InSim.Setup.SETF_ABS_ENABLE
		+ int(tc_enabled) * InSim.Setup.SETF_TC_ENABLE
	)
