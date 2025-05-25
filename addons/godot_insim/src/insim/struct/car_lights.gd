class_name CarLights
extends RefCounted
## Helper struct for car lights
##
## This struct can be used to help set lights from the [enum InSim.LocalCarLights] enum.

const SIGNALS_BIT_SHIFT := 16  ## Signals bit shift
const SIGNALS_BIT_MASK := 0x3_0000  ## Signals bit mask
const LIGHTS_BIT_SHIFT := 18  ## Headlights bit shift
const LIGHTS_BIT_MASK := 0xc_0000  ## Headlights bit mask
const FOG_REAR_BIT_SHIFT := 20  ## Rear fog light bit shift
const FOG_REAR_BIT_MASK := 0x10_0000  ## Rear fog light bit mask
const FOG_FRONT_BIT_SHIFT := 21  ## Front fog light bit shift
const FOG_FRONT_BIT_MASK := 0x20_0000  ## Front fog light bit mask
const EXTRA_BIT_SHIFT := 22  ## Extra light bit shift
const EXTRA_BIT_MASK := 0x40_0000  ## Extra light bit mask

## See [enum InSim.LocalCarLights].
const MASK_ALL := (
	InSim.LocalCarLights.LCL_SET_SIGNALS |
	InSim.LocalCarLights.LCL_SET_LIGHTS |
	InSim.LocalCarLights.LCL_SET_FOG_REAR |
	InSim.LocalCarLights.LCL_SET_FOG_FRONT |
	InSim.LocalCarLights.LCL_SET_EXTRA
)

var set_signals := false  ## Whether the signals will be set.
var set_lights := false  ## Whether the lights will be set.
var set_fog_rear := false  ## Whether the rear fog light will be set.
var set_fog_front := false  ## Whether the front fog light will be set.
var set_extra := false  ## Whether the extra light will be set.

## The value to assign to the signals
var signals := 0:
	set(value):
		signals = clampi(value, 0, 3)
## The value to assign to the lights
var lights := 0:
	set(value):
		lights = clampi(value, 0, 3)
## The value to assign to the rear fog light
var fog_rear := 0:
	set(value):
		fog_rear = clampi(value, 0, 1)
## The value to assign to the front fog light
var fog_front := 0:
	set(value):
		fog_front = clampi(value, 0, 1)
## The value to assign to the extra light
var extra := 0:
	set(value):
		extra = clampi(value, 0, 1)


## Creates and returns a new [CarLights] object from the given parameters.
static func create(
	lcl_mask := MASK_ALL, lcl_signals := 0, lcl_lights := 0, lcl_fog_rear := 0, lcl_fog_front := 0,
	lcl_extra := 0
) -> CarLights:
	var car_lights := CarLights.new()
	car_lights.set_signals = lcl_mask & InSim.LocalCarLights.LCL_SET_SIGNALS
	car_lights.set_lights = lcl_mask & InSim.LocalCarLights.LCL_SET_LIGHTS
	car_lights.set_fog_rear = lcl_mask & InSim.LocalCarLights.LCL_SET_FOG_REAR
	car_lights.set_fog_front = lcl_mask & InSim.LocalCarLights.LCL_SET_FOG_FRONT
	car_lights.set_extra = lcl_mask & InSim.LocalCarLights.LCL_SET_EXTRA
	car_lights.signals = lcl_signals
	car_lights.lights = lcl_lights
	car_lights.fog_rear = lcl_fog_rear
	car_lights.fog_front = lcl_fog_front
	car_lights.extra = lcl_extra
	return car_lights


## Creates and returns a new [CarLights] object from the given parameters.
static func create_no_mask(
	lcl_signals := -1, lcl_lights := -1, lcl_fog_rear := -1, lcl_fog_front := -1, lcl_extra := -1
) -> CarLights:
	var car_lights := CarLights.new()
	if lcl_signals != -1:
		car_lights.set_signals = true
		car_lights.signals = lcl_signals
	if lcl_lights != -1:
		car_lights.set_lights = true
		car_lights.lights = lcl_lights
	if lcl_fog_rear != -1:
		car_lights.set_fog_rear = true
		car_lights.fog_rear = lcl_fog_rear
	if lcl_fog_front != -1:
		car_lights.set_fog_front = true
		car_lights.fog_front = lcl_fog_front
	if lcl_extra != -1:
		car_lights.set_extra = true
		car_lights.extra = lcl_extra
	return car_lights


func _to_string() -> String:
	return "Signals:" + "%d" % [signals if set_signals else -1] \
			+ ", Lights:" + "%d" % [lights if set_lights else -1] \
			+ ", FogRear:" + "%d" % [fog_rear if set_fog_rear else -1] \
			+ ", FogFront:" + "%d" % [fog_front if set_fog_front else -1] \
			+ ", Extra:" + "%d" % [extra if set_extra else -1]


## Returns the integer value corresponding to the values set.
func get_value() -> int:
	var lcl := 0
	lcl |= InSim.LocalCarLights.LCL_SET_SIGNALS if set_signals else 0
	lcl |= InSim.LocalCarLights.LCL_SET_LIGHTS if set_lights else 0
	lcl |= InSim.LocalCarLights.LCL_SET_FOG_REAR if set_fog_rear else 0
	lcl |= InSim.LocalCarLights.LCL_SET_FOG_FRONT if set_fog_front else 0
	lcl |= InSim.LocalCarLights.LCL_SET_EXTRA if set_extra else 0
	lcl = (lcl & ~SIGNALS_BIT_MASK) | signals << SIGNALS_BIT_SHIFT
	lcl = (lcl & ~LIGHTS_BIT_MASK) | lights << LIGHTS_BIT_SHIFT
	lcl = (lcl & ~FOG_REAR_BIT_MASK) | fog_rear << FOG_REAR_BIT_SHIFT
	lcl = (lcl & ~FOG_FRONT_BIT_MASK) | fog_front << FOG_FRONT_BIT_SHIFT
	lcl = (lcl & ~EXTRA_BIT_MASK) | extra << EXTRA_BIT_SHIFT
	return lcl
