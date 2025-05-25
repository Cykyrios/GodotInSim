class_name OutSimPack
extends RefCounted
## OutSim packed data struct
##
## This struct-like class contains [OutSim] data and is typically contained in an [OutSimPacket].
## LFS can send either a simplified OutSimPack object or a more advanced and customizable
## OutSimPack2, depending on the [member outsim_options]; the [OutSimPack] in this implementation
## corresponds to an LFS OutSimPack2, but also supports data from LFS OutSimPack.

## Helper enum for wheel array indices. Vehicles always have at least 2 wheels, but depending on
## their configuration, may have a single front wheel and/or rear wheel.
enum WheelIndex {
	REAR_LEFT,  ## The vehicle's rear left wheel.
	REAR_RIGHT,  ## The vehicle's rear right wheel, if it exists.
	FRONT_LEFT,  ## The vehicle's front left wheel.
	FRONT_RIGHT,  ## The vehicle's front left wheel, if it exists.
}

const TIME_MULTIPLIER := 1000.0  ## Conversion factor between SI units and LFS-encoded values.

const OUTSIM_PACK1_SIZE := 64  ## Size of the LFS OutSimPack's data.
const OUTSIM_PACK1_ID_SIZE := 4  ## Size of the optional ID.

const WHEEL_COUNT := 4  ## Number of wheels, always equal to 4, even for vehicles that have less.

var outsim_options := 0  ## OutSim options passed from the [OutSim] instance.

var header := ""  ## If sent, will contain [code]LFST[/code].
var id := 0  ## The configured ID in [code]cfg.txt[/code].
var time := 0  ## OutSim timestamp

var os_main := OutSimMain.new()  ## OutSim main data struct
var os_inputs := OutSimInputs.new()  ## OutSim inputs data struct

var gear := 0  ## Current gear
var sp1 := 0  ## Spare byte 1
var sp2 := 0  ## Spare byte 2
var sp3 := 0  ## Spare byte 3
## Engine speed in radians/s; use [method GISUnit.convert_angular_speed] to get the RPM value.
var engine_ang_vel := 0.0
## Maximum torque at the current engine speed, in N.m.
var max_torque_at_vel := 0.0

## Distance travelled since the start of the current lap, in meters.
var current_lap_distance := 0.0
## Indexed distance along the track's PTH path definition, in meters; only available on official
## layouts, custom layouts will return [code]0[/code].
var indexed_distance := 0.0

var os_wheels: Array[OutSimWheel] = []  ## An array containing each wheel's data.

## The torque currently applied at the steering rack (there is no power steering in LFS).
var steer_torque := 0.0
var spare := 0.0  ## Spare float

## The time, in seconds, corresponding to the [member time] timestamp.
var gis_time := 0.0


func _init() -> void:
	for wheel in OutSimPack.WHEEL_COUNT:
		os_wheels.append(OutSimWheel.new())


func _to_string() -> String:
	return "ID:%d, Time:%d, OSMain:%s, OSInputs:%s, Gear:%d, Sp1:%d, Sp2:%d, Sp3:%d" % \
			[id, time, os_main, os_inputs, gear, sp1, sp2, sp3] \
			+ ", EngineAngVel:%f, MaxTorqueAtVel:%f, CurrentLapDist:%f, IndexedDistance:%f" % \
			[engine_ang_vel, max_torque_at_vel, current_lap_distance, indexed_distance] \
			+ ", OSWheels:%s, SteerTorque:%f, Spare:%f" % \
			[os_wheels, steer_torque, spare]


## Sets the properties from the given [param buffer], taking [member outsim_options] into account.
func set_from_buffer(buffer: PackedByteArray) -> void:
	var data_offset := 0
	if outsim_options == 0:
		var buffer_size := buffer.size()
		if buffer_size in [OUTSIM_PACK1_SIZE, OUTSIM_PACK1_SIZE + OUTSIM_PACK1_ID_SIZE]:
			outsim_options |= OutSim.OutSimOpts.OSO_TIME | OutSim.OutSimOpts.OSO_MAIN
			if buffer_size > OUTSIM_PACK1_SIZE:
				outsim_options |= OutSim.OutSimOpts.OSO_ID
				var temp_buffer := buffer.duplicate()
				buffer.clear()
				buffer.append_array(temp_buffer.slice(-4))
				buffer.append_array(temp_buffer.slice(0, -4))
		else:
			push_error("Wrong buffer size, expected %d or %d, got %d" % \
					[OUTSIM_PACK1_SIZE, OUTSIM_PACK1_SIZE + OUTSIM_PACK1_ID_SIZE, buffer_size])
			return
	if outsim_options & OutSim.OutSimOpts.OSO_HEADER:
		header = buffer.slice(data_offset, data_offset + 4).get_string_from_utf8()
		data_offset += 4
	if outsim_options & OutSim.OutSimOpts.OSO_ID:
		id = buffer.decode_u32(data_offset)
		data_offset += 4
	if outsim_options & OutSim.OutSimOpts.OSO_TIME:
		time = buffer.decode_u32(data_offset)
		gis_time = time / TIME_MULTIPLIER
		data_offset += 4
	if outsim_options & OutSim.OutSimOpts.OSO_MAIN:
		os_main.set_from_buffer(buffer.slice(data_offset, data_offset + OutSimMain.STRUCT_SIZE))
		data_offset += OutSimMain.STRUCT_SIZE
	if outsim_options & OutSim.OutSimOpts.OSO_INPUTS:
		os_inputs.set_from_buffer(buffer.slice(data_offset, data_offset + OutSimInputs.STRUCT_SIZE))
		data_offset += OutSimInputs.STRUCT_SIZE
	if outsim_options & OutSim.OutSimOpts.OSO_DRIVE:
		gear = buffer.decode_u8(data_offset)
		sp1 = buffer.decode_u8(data_offset + 1)
		sp2 = buffer.decode_u8(data_offset + 2)
		sp3 = buffer.decode_u8(data_offset + 3)
		data_offset += 4
		engine_ang_vel = buffer.decode_float(data_offset)
		max_torque_at_vel = buffer.decode_float(data_offset + 4)
		data_offset += 8
	if outsim_options & OutSim.OutSimOpts.OSO_DISTANCE:
		current_lap_distance = buffer.decode_float(data_offset)
		indexed_distance = buffer.decode_float(data_offset + 4)
		data_offset += 8
	if outsim_options & OutSim.OutSimOpts.OSO_WHEELS:
		os_wheels.clear()
		for i in WHEEL_COUNT:
			var wheel := OutSimWheel.new()
			wheel.set_from_buffer(buffer.slice(data_offset, data_offset + OutSimWheel.STRUCT_SIZE))
			os_wheels.append(wheel)
			data_offset += OutSimWheel.STRUCT_SIZE
	if outsim_options & OutSim.OutSimOpts.OSO_EXTRA_1:
		steer_torque = buffer.decode_float(data_offset)
		spare = buffer.decode_float(data_offset + 4)
		data_offset += 8
