extends GutTest


# mask, signals, lights, fog_rear, fog_front, extra
var args: Array[Array] = [
	[
		(
			InSim.LocalCarSwitches.LCS_SET_SIGNALS | InSim.LocalCarSwitches.LCS_SET_FLASH |
			InSim.LocalCarSwitches.LCS_SET_HEADLIGHTS | InSim.LocalCarSwitches.LCS_SET_HORN |
			InSim.LocalCarSwitches.LCS_SET_SIREN
		),
		2, 1, 1, 4, 2
	],
	[
		0,
		2, 1, 1, 4, 2
	],
	[
		0,
		3, 4, 5, 6, 0
	],
]

var params_struct_with_mask := [
	args[0],
	args[1],
]
func test_struct_with_mask(params: Array = use_parameters(params_struct_with_mask)) -> void:
	var mask := params[0] as int
	var signals := params[1] as int
	var flash := params[2] as int
	var headlights := params[3] as int
	var horn := params[4] as int
	var siren := params[5] as int
	var struct := CarSwitches.create(mask, signals, flash, headlights, horn, siren)
	var value := (
		(signals << CarSwitches.SIGNALS_BIT_SHIFT) + (flash << CarSwitches.FLASH_BIT_SHIFT)
		+ (headlights << CarSwitches.HEADLIGHTS_BIT_SHIFT) + (horn << CarSwitches.HORN_BIT_SHIFT)
		+ (siren << CarSwitches.SIREN_BIT_SHIFT)
	)
	assert_eq(struct.get_value(), mask + value)


var params_struct_without_mask := [
	args[0],
	args[1],
]
func test_struct_without_mask(params: Array = use_parameters(params_struct_without_mask)) -> void:
	var signals := params[1] as int
	var flash := params[2] as int
	var headlights := params[3] as int
	var horn := params[4] as int
	var siren := params[5] as int
	var struct := CarSwitches.create_no_mask(signals, flash, headlights, horn, siren)
	var mask := (
		(InSim.LocalCarSwitches.LCS_SET_SIGNALS if signals != -1 else 0) |
		(InSim.LocalCarSwitches.LCS_SET_FLASH if flash != -1 else 0) |
		(InSim.LocalCarSwitches.LCS_SET_HEADLIGHTS if headlights != -1 else 0) |
		(InSim.LocalCarSwitches.LCS_SET_HORN if horn != -1 else 0) |
		(InSim.LocalCarSwitches.LCS_SET_SIREN if siren != -1 else 0)
	)
	var value := (
		(signals << CarSwitches.SIGNALS_BIT_SHIFT) + (flash << CarSwitches.FLASH_BIT_SHIFT)
		+ (headlights << CarSwitches.HEADLIGHTS_BIT_SHIFT) + (horn << CarSwitches.HORN_BIT_SHIFT)
		+ (siren << CarSwitches.SIREN_BIT_SHIFT)
	)
	assert_eq(struct.get_value(), mask + value)


var params_invalid_values := [
	args[2],
]
func test_invalid_values(params: Array = use_parameters(params_invalid_values)) -> void:
	var signals := params[1] as int
	var flash := params[2] as int
	var headlights := params[3] as int
	var horn := params[4] as int
	var siren := params[5] as int
	var struct := CarSwitches.create_no_mask(signals, flash, headlights, horn, siren)
	var mask := (
		(InSim.LocalCarSwitches.LCS_SET_SIGNALS if signals != -1 else 0) |
		(InSim.LocalCarSwitches.LCS_SET_FLASH if flash != -1 else 0) |
		(InSim.LocalCarSwitches.LCS_SET_HEADLIGHTS if headlights != -1 else 0) |
		(InSim.LocalCarSwitches.LCS_SET_HORN if horn != -1 else 0) |
		(InSim.LocalCarSwitches.LCS_SET_SIREN if siren != -1 else 0)
	)
	var value := (
		(signals << CarSwitches.SIGNALS_BIT_SHIFT) + (flash << CarSwitches.FLASH_BIT_SHIFT)
		+ (headlights << CarSwitches.HEADLIGHTS_BIT_SHIFT) + (horn << CarSwitches.HORN_BIT_SHIFT)
		+ (siren << CarSwitches.SIREN_BIT_SHIFT)
	)
	assert_ne(struct.get_value(), mask + value)
