extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/struct/car_switches.gd"

# mask, signals, lights, fog_rear, fog_front, extra
var params: Array[Array] = [
	[
		(
			InSim.LocalCarSwitches.LCS_SET_SIGNALS | InSim.LocalCarSwitches.LCS_SET_FLASH |
			InSim.LocalCarSwitches.LCS_SET_HEADLIGHTS | InSim.LocalCarSwitches.LCS_SET_HORN |
			InSim.LocalCarSwitches.LCS_SET_SIREN
		),
		2, 1, 1, 4, 2,
	],
	[
		0,
		2, 1, 1, 4, 2,
	],
	[
		0,
		3, 4, 5, 6, 0,
	],
]

@warning_ignore("unused_parameter")
func test_struct_with_mask(
	mask: int, signals: int, flash: int, headlights: int, horn: int, siren: int,
	test_parameters := params.slice(0, 2)
) -> void:
	var struct := CarSwitches.create(mask, signals, flash, headlights, horn, siren)
	var value := (
		(signals << CarSwitches.SIGNALS_BIT_SHIFT) + (flash << CarSwitches.FLASH_BIT_SHIFT)
		+ (headlights << CarSwitches.HEADLIGHTS_BIT_SHIFT) + (horn << CarSwitches.HORN_BIT_SHIFT)
		+ (siren << CarSwitches.SIREN_BIT_SHIFT)
	)
	var _test := assert_int(struct.get_value()).is_equal(mask + value)


@warning_ignore("unused_parameter")
func test_struct_without_mask(
	_mask: int, signals: int, flash: int, headlights: int, horn: int, siren: int,
	test_parameters := params.slice(0, 2)
) -> void:
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
	var _test := assert_int(struct.get_value()).is_equal(mask + value)


@warning_ignore("unused_parameter")
func test_invalid_values(
	_mask: int, signals: int, flash: int, headlights: int, horn: int, siren: int,
	test_parameters := [params[2]]
) -> void:
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
	var _test := assert_int(struct.get_value()).is_not_equal(mask + value)
