class_name CarInfo
extends LFSPacket
## Car info
##
## Reads car info as exported from the game's garage view, which you can generate by pressing O
## in the garage view. This will generate a [code]car_info.bin[/code] file, where [code]car[/code]
## is the car's 3-letter (or the mod's 6-character) identifier. This file is created in the
## [code]data/raf[/code] folder. The data contained in this file depends on the current setup,
## including fuel and passengers status (in/out).[br]
## [br]
## Beside specific setup-related physics data, this file can be used to get some info on the car,
## such as maximum suspension deflection and full tyre/rim data, as well as power/torque values
## corresponding to the current intake restriction.

## Drive types
enum Drive {NONE, RWD, FWD, AWD}

const STRUCT_SIZE := 384  ## The size of the contained data

var header := "LFS_CI"  ## Header, always equal to [code]LFS_CI[/code].
var version := 1  ## File format version
var car_name := ""  ## Vehicle ID (3 letters for official cars, skin ID for mods)
## Passenger flags containing data about all four possible passengers.
var passengers := 0:
	set(value):
		passengers = value
		passenger_front = passengers & 0b0000_0011
		passenger_rear_left = passengers & 0b0000_1100
		passenger_rear_middle = passengers & 0b0011_0000
		passenger_rear_right = passengers & 0b1100_0000
var passenger_front := 0  ## Front passenger.
var passenger_rear_left := 0  ## Rear left passenger.
var passenger_rear_middle := 0  ## Rear middle passenger.
var passenger_rear_right := 0  ## Rear right passenger.

var body_right := Vector3.ZERO  ## Vehicle body's right vector.
var body_forward := Vector3.ZERO  ## Vehicle body's forward vector.
var body_up := Vector3.ZERO  ## Vehicle body's up vector.

var reference_point_world := Vector3i.ZERO  ## World reference point in LFS-encoded values
var cog_world := Vector3i.ZERO  ## World CoG position in LFS-encoded values
var cog_local := Vector3.ZERO  ## Local CoG position
var fuel_tank_local := Vector3.ZERO  ## Local fuel tank position

var rear_wing := AeroInfo.new()  ## Rear wing aero center
var front_wing := AeroInfo.new()  ## Front wing aero center
var undertray := AeroInfo.new()  ## Undertray aero center
var body_aero := AeroInfo.new()  ## Body aero center

var moment_of_inertia := PackedByteArray()  ## Moment of inertia matrix

var max_torque := 0.0  ## Maximum torque in N.m
var torque_rpm := 0.0  ## Maximum torque RPM
var max_power := 0.0  ## Maximum power in kW
var power_rpm := 0.0  ## Maximum power RPM

var fuel := 0.0  ## Fuel in liters
var total_mass := 0.0  ## Vehicle mass, including fuel and driver
var wheel_base := 0.0  ## Approximate wheel base (at zero suspension compression)
var weight_distribution := 0.0  ## Approximate weight distribution (at zero suspension compression)

var gear_count := 0  ## Number of forward gears
var drive := Drive.NONE  ## Drive type
var torque_split := 0.0  ## Torque split
var drivetrain_efficiency := 0.0  ## Drivetrain efficiency
var gear_reverse := 0.0  ## Reverse gear ratio
var gear_1 := 0.0  ## First gear ratio
var gear_2 := 0.0  ## Second gear ratio
var gear_3 := 0.0  ## Third gear ratio
var gear_4 := 0.0  ## Fourth gear ratio
var gear_5 := 0.0  ## Fifth gear ratio
var gear_6 := 0.0  ## Sixth gear ratio
var gear_7 := 0.0  ## Seventh gear ratio
var final_drive := 0.0  ## Final drive ratio

var parallel_steer := 0.0  ## Parallel steer (0 to 1)
var brake_strength := 0.0  ## Maximum brake torque
var brake_balance := 0.0  ## Brake balance

## 4 [WheelInfo] objects, in standard LFS order: rear left, rear right, front left, front right.
var wheels: Array[WheelInfo] = []


## Creates and returns a generic new [CarInfo] object.
static func create_generic_car_info() -> CarInfo:
	var car_info := CarInfo.new()
	car_info.gear_count = 7
	car_info.drive = Drive.AWD
	return car_info


## Loads and returns a [CarInfo] object from the given [param path]. Returns [code]null[/code] if
## the file cannot be read.
static func load_car_info(path: String) -> CarInfo:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		var error := FileAccess.get_open_error()
		push_error("File open error %d" % [error])
		return null
	var car_info := CarInfo.new()
	car_info.decode_car_info(file.get_buffer(file.get_length()))
	return car_info


## Decodes data in the given [param data_buffer] and updates the corresponding properties.
func decode_car_info(data_buffer: PackedByteArray) -> void:
	buffer = data_buffer
	header = read_string(6, false)
	var _discard := read_buffer(1)
	version = read_byte()
	car_name = LFSText.car_name_from_lfs_bytes(read_buffer(4))
	passengers = read_byte()
	_discard = read_buffer(3)
	body_right = Vector3(read_float(), read_float(), read_float())
	body_forward = Vector3(read_float(), read_float(), read_float())
	body_up = Vector3(read_float(), read_float(), read_float())
	reference_point_world = Vector3i(read_int(), read_int(), read_int())
	cog_world = Vector3i(read_int(), read_int(), read_int())
	cog_local = Vector3(read_float(), read_float(), read_float())
	fuel_tank_local = Vector3(read_float(), read_float(), read_float())
	_discard = read_buffer(28)
	rear_wing = AeroInfo.create_from_buffer(read_buffer(AeroInfo.STRUCT_SIZE))
	front_wing = AeroInfo.create_from_buffer(read_buffer(AeroInfo.STRUCT_SIZE))
	undertray = AeroInfo.create_from_buffer(read_buffer(AeroInfo.STRUCT_SIZE))
	body_aero = AeroInfo.create_from_buffer(read_buffer(AeroInfo.STRUCT_SIZE))
	moment_of_inertia = read_buffer(36)
	_discard = read_buffer(12)
	max_torque = read_float()
	torque_rpm = read_float()
	max_power = read_float()
	power_rpm = read_float()
	fuel = read_float()
	total_mass = read_float()
	wheel_base = read_float()
	weight_distribution = read_float()
	gear_count = read_byte()
	drive = read_byte() as Drive
	_discard = read_buffer(2)
	torque_split = read_float()
	drivetrain_efficiency = read_float()
	_discard = read_buffer(4)
	gear_reverse = read_float()
	gear_1 = read_float()
	gear_2 = read_float()
	gear_3 = read_float()
	gear_4 = read_float()
	gear_5 = read_float()
	gear_6 = read_float()
	gear_7 = read_float()
	final_drive = read_float()
	_discard = read_buffer(12)
	parallel_steer = read_float()
	brake_strength = read_float()
	brake_balance = read_float()
	_discard = read_buffer(20)
	for i in 4:
		wheels.append(WheelInfo.create_from_buffer(read_buffer(WheelInfo.STRUCT_SIZE)))
