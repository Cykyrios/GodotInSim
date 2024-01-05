class_name CarLights
extends RefCounted


const SIGNALS_BIT_SHIFT := 16
const SIGNALS_BIT_MASK := 0b11
const LIGHTS_BIT_SHIFT := 18
const LIGHTS_BIT_MASK := 0b11
const FOG_REAR_BIT_SHIFT := 20
const FOG_REAR_BIT_MASK := 0b1
const FOG_FRONT_BIT_SHIFT := 21
const FOG_FRONT_BIT_MASK := 0b1
const EXTRA_BIT_SHIFT := 22
const EXTRA_BIT_MASK := 0b1

var set_signals := false
var set_lights := false
var set_fog_rear := false
var set_fog_front := false
var set_extra := false

var signals := 0:
	set(value):
		signals = clampi(value, 0, 3)
var lights := 0:
	set(value):
		lights = clampi(value, 0, 3)
var fog_rear := 0:
	set(value):
		fog_rear = clampi(value, 0, 1)
var fog_front := 0:
	set(value):
		fog_front = clampi(value, 0, 1)
var extra := 0:
	set(value):
		extra = clampi(value, 0, 1)


func _to_string() -> String:
	return "Signals:" + "%d" % [signals if set_signals else -1] \
			+ ", Lights:" + "%d" % [lights if set_lights else -1] \
			+ ", FogRear:" + "%d" % [fog_rear if set_fog_rear else -1] \
			+ ", FogFront:" + "%d" % [fog_front if set_fog_front else -1] \
			+ ", Extra:" + "%d" % [extra if set_extra else -1]


func get_value() -> int:
	var lcl := 0
	lcl |= InSim.LocalCarLights.LCL_SET_SIGNALS if set_signals else 0
	lcl |= InSim.LocalCarLights.LCL_SET_LIGHTS if set_lights else 0
	lcl |= InSim.LocalCarLights.LCL_SET_FOG_REAR if set_fog_rear else 0
	lcl |= InSim.LocalCarLights.LCL_SET_FOG_FRONT if set_fog_front else 0
	lcl |= InSim.LocalCarLights.LCL_SET_EXTRA if set_extra else 0
	lcl = (lcl & ~(0b11 << SIGNALS_BIT_SHIFT)) | signals << SIGNALS_BIT_SHIFT
	lcl = (lcl & ~(0b1 << LIGHTS_BIT_SHIFT)) | lights << LIGHTS_BIT_SHIFT
	lcl = (lcl & ~(0b1 << FOG_REAR_BIT_SHIFT)) | fog_rear << FOG_REAR_BIT_SHIFT
	lcl = (lcl & ~(0b111 << FOG_FRONT_BIT_SHIFT)) | fog_front << FOG_FRONT_BIT_SHIFT
	lcl = (lcl & ~(0b11 << EXTRA_BIT_SHIFT)) | extra << EXTRA_BIT_SHIFT
	return lcl
