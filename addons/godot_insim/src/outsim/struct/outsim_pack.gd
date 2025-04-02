class_name OutSimPack
extends RefCounted


enum WheelIndex {
	REAR_LEFT,
	REAR_RIGHT,
	FRONT_LEFT,
	FRONT_RIGHT,
}

const TIME_MULTIPLIER := 1000.0

const OUTSIM_PACK1_SIZE := 64
const OUTSIM_PACK1_ID_SIZE := 4

const WHEEL_COUNT := 4

var outsim_options := 0

var header := ""

var id := 0

var time := 0

var os_main := OutSimMain.new()
var os_inputs := OutSimInputs.new()

var gear := 0
var sp1 := 0
var sp2 := 0
var sp3 := 0
var engine_ang_vel := 0.0
var max_torque_at_vel := 0.0

var current_lap_distance := 0.0
var indexed_distance := 0.0

var os_wheels: Array[OutSimWheel] = []

var steer_torque := 0.0
var spare := 0.0

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
