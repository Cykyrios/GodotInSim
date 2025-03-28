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

enum Drive {NONE, RWD, FWD, AWD}

const STRUCT_SIZE := 384

var header := "LFS_CI"
var version := 1
var car_name := ""
var passengers := 0:
	set(value):
		passengers = value
		passenger_front = passengers & 0b0000_0011
		passenger_rear_left = passengers & 0b0000_1100
		passenger_rear_middle = passengers & 0b0011_0000
		passenger_rear_right = passengers & 0b1100_0000
var passenger_front := 0
var passenger_rear_left := 0
var passenger_rear_middle := 0
var passenger_rear_right := 0

var body_right := Vector3.ZERO
var body_forward := Vector3.ZERO
var body_up := Vector3.ZERO

var reference_point_world := Vector3i.ZERO
var cog_world := Vector3i.ZERO
var cog_local := Vector3.ZERO
var fuel_tank_local := Vector3.ZERO

var rear_wing := AeroInfo.new()
var front_wing := AeroInfo.new()
var undertray := AeroInfo.new()
var body_aero := AeroInfo.new()

var moment_of_inertia := PackedByteArray()

var max_torque := 0.0
var torque_rpm := 0.0
var max_power := 0.0
var power_rpm := 0.0

var fuel := 0.0
var total_mass := 0.0
var wheel_base := 0.0
var weight_distribution := 0.0

var gear_count := 0
var drive := Drive.NONE
var torque_split := 0.0
var drivetrain_efficiency := 0.0
var gear_reverse := 0.0
var gear_1 := 0.0
var gear_2 := 0.0
var gear_3 := 0.0
var gear_4 := 0.0
var gear_5 := 0.0
var gear_6 := 0.0
var gear_7 := 0.0
var final_drive := 0.0

var parallel_steer := 0.0
var brake_strength := 0.0
var brake_balance := 0.0

## 4 [WheelInfo] objects, in standard LFS order: rear left, rear right, front left, front right.
var wheels: Array[WheelInfo] = []


static func create_generic_car_info() -> CarInfo:
	var car_info := CarInfo.new()
	car_info.gear_count = 7
	car_info.drive = Drive.AWD
	return car_info


static func load_car_info(path: String) -> CarInfo:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		var error := FileAccess.get_open_error()
		print("File open error %d" % error)
		return null
	var car_info := CarInfo.new()
	car_info.decode_car_info(file.get_buffer(file.get_length()))
	return car_info


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
