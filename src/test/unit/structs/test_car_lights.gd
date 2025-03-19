extends GutTest


# mask, signals, lights, fog_rear, fog_front, extra
var args: Array[Array] = [
	[
		(
			InSim.LocalCarLights.LCL_SET_SIGNALS | InSim.LocalCarLights.LCL_SET_LIGHTS |
			InSim.LocalCarLights.LCL_SET_FOG_REAR | InSim.LocalCarLights.LCL_SET_FOG_FRONT |
			InSim.LocalCarLights.LCL_SET_EXTRA
		),
		1, 2, 1, 1, 1
	],
	[
		0,
		1, 2, 1, 1, 1
	],
	[
		0,
		4, 4, 4, 4, 4
	],
]

var params_struct_with_mask := [
	args[0],
	args[1],
]
func test_struct_with_mask(params: Array = use_parameters(params_struct_with_mask)) -> void:
	var mask := params[0] as int
	var signals := params[1] as int
	var lights := params[2] as int
	var fog_rear := params[3] as int
	var fog_front := params[4] as int
	var extra := params[5] as int
	var struct := CarLights.create(mask, signals, lights, fog_rear, fog_front, extra)
	var value := (
		(signals << CarLights.SIGNALS_BIT_SHIFT) + (lights << CarLights.LIGHTS_BIT_SHIFT)
		+ (fog_rear << CarLights.FOG_REAR_BIT_SHIFT) + (fog_front << CarLights.FOG_FRONT_BIT_SHIFT)
		+ (extra << CarLights.EXTRA_BIT_SHIFT)
	)
	assert_eq(struct.get_value(), mask + value)


var params_struct_without_mask := [
	args[0],
	args[1],
]
func test_struct_without_mask(params: Array = use_parameters(params_struct_without_mask)) -> void:
	var signals := params[1] as int
	var lights := params[2] as int
	var fog_rear := params[3] as int
	var fog_front := params[4] as int
	var extra := params[5] as int
	var struct := CarLights.create_no_mask(signals, lights, fog_rear, fog_front, extra)
	var mask := (
		(InSim.LocalCarLights.LCL_SET_SIGNALS if signals != -1 else 0) |
		(InSim.LocalCarLights.LCL_SET_LIGHTS if lights != -1 else 0) |
		(InSim.LocalCarLights.LCL_SET_FOG_REAR if fog_rear != -1 else 0) |
		(InSim.LocalCarLights.LCL_SET_FOG_FRONT if fog_front != -1 else 0) |
		(InSim.LocalCarLights.LCL_SET_EXTRA if extra != -1 else 0)
	)
	var value := (
		(signals << CarLights.SIGNALS_BIT_SHIFT) + (lights << CarLights.LIGHTS_BIT_SHIFT)
		+ (fog_rear << CarLights.FOG_REAR_BIT_SHIFT) + (fog_front << CarLights.FOG_FRONT_BIT_SHIFT)
		+ (extra << CarLights.EXTRA_BIT_SHIFT)
	)
	assert_eq(struct.get_value(), mask + value)


var params_invalid_values := [
	args[2],
]
func test_invalid_values(params: Array = use_parameters(params_invalid_values)) -> void:
	var signals := params[1] as int
	var lights := params[2] as int
	var fog_rear := params[3] as int
	var fog_front := params[4] as int
	var extra := params[5] as int
	var struct := CarLights.create_no_mask(signals, lights, fog_rear, fog_front, extra)
	var mask := (
		(InSim.LocalCarLights.LCL_SET_SIGNALS if signals != -1 else 0) |
		(InSim.LocalCarLights.LCL_SET_LIGHTS if lights != -1 else 0) |
		(InSim.LocalCarLights.LCL_SET_FOG_REAR if fog_rear != -1 else 0) |
		(InSim.LocalCarLights.LCL_SET_FOG_FRONT if fog_front != -1 else 0) |
		(InSim.LocalCarLights.LCL_SET_EXTRA if extra != -1 else 0)
	)
	var value := (
		(signals << CarLights.SIGNALS_BIT_SHIFT) + (lights << CarLights.LIGHTS_BIT_SHIFT)
		+ (fog_rear << CarLights.FOG_REAR_BIT_SHIFT) + (fog_front << CarLights.FOG_FRONT_BIT_SHIFT)
		+ (extra << CarLights.EXTRA_BIT_SHIFT)
	)
	assert_ne(struct.get_value(), mask + value)
