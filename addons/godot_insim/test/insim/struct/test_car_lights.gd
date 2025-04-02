extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/struct/car_lights.gd"

# mask, signals, lights, fog_rear, fog_front, extra
var params: Array[Array] = [
	[
		(
			InSim.LocalCarLights.LCL_SET_SIGNALS | InSim.LocalCarLights.LCL_SET_LIGHTS |
			InSim.LocalCarLights.LCL_SET_FOG_REAR | InSim.LocalCarLights.LCL_SET_FOG_FRONT |
			InSim.LocalCarLights.LCL_SET_EXTRA
		),
		1, 2, 1, 1, 1,
	],
	[
		0,
		1, 2, 1, 1, 1,
	],
	[
		0,
		4, 4, 4, 4, 4,
	],
]


@warning_ignore("unused_parameter")
func test_struct_with_mask(
	mask: int, signals: int, lights: int, fog_rear: int, fog_front: int, extra: int,
	test_parameters := params.slice(0, 2)
) -> void:
	var struct := CarLights.create(mask, signals, lights, fog_rear, fog_front, extra)
	var value := (
		(signals << CarLights.SIGNALS_BIT_SHIFT) + (lights << CarLights.LIGHTS_BIT_SHIFT)
		+ (fog_rear << CarLights.FOG_REAR_BIT_SHIFT) + (fog_front << CarLights.FOG_FRONT_BIT_SHIFT)
		+ (extra << CarLights.EXTRA_BIT_SHIFT)
	)
	var _test := assert_int(struct.get_value()).is_equal(mask + value)


@warning_ignore("unused_parameter")
func test_struct_without_mask(
	_mask: int, signals: int, lights: int, fog_rear: int, fog_front: int, extra: int,
	test_parameters := params.slice(0, 2)
) -> void:
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
	var _test := assert_int(struct.get_value()).is_equal(mask + value)


@warning_ignore("unused_parameter")
func test_invalid_values(
	_mask: int, signals: int, lights: int, fog_rear: int, fog_front: int, extra: int,
	test_parameters := [params[2]]
) -> void:
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
	var _test := assert_int(struct.get_value()).is_not_equal(mask + value)
