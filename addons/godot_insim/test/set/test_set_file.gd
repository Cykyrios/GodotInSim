extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/set/set_file.gd"

var epsilon := 1e-5


@warning_ignore("unused_parameter")
func test_camber_from_LFS_value(input: int, expected: float, test_parameters := [
	[0, -4.5],
	[45, 0.0],
	[90, 4.5],
]) -> void:
	var _test := assert_float(SETFile.camber_from_LFS_value(input)) \
			.is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_camber_to_LFS_value(input: float, expected: int, test_parameters := [
	[-4.5, 0],
	[0.0, 45],
	[4.5, 90],
]) -> void:
	var _test := assert_int(SETFile.camber_to_LFS_value(input)).is_equal(expected)


@warning_ignore("unused_parameter")
func test_gear_ratio_from_LFS_value(input: int, expected: float, test_parameters := [
	[0, 0.5],
	[65534, 7.5],
]) -> void:
	var _test := assert_float(SETFile.gear_ratio_from_LFS_value(input)) \
			.is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_gear_ratio_to_LFS_value(input: float, expected: int, test_parameters := [
	[0.5, 0],
	[7.5, 65534],
]) -> void:
	var _test := assert_int(SETFile.gear_ratio_to_LFS_value(input)).is_equal(expected)


@warning_ignore("unused_parameter")
func test_toe_from_LFS_value(input: int, expected: float, test_parameters := [
	[0, -0.9],
	[9, 0.0],
	[18, 0.9],
]) -> void:
	var _test := assert_float(SETFile.toe_from_LFS_value(input)) \
			.is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_toe_to_LFS_value(input: float, expected: int, test_parameters := [
	[-0.9, 0],
	[0.0, 9],
	[0.9, 18],
]) -> void:
	var _test := assert_int(SETFile.toe_to_LFS_value(input)).is_equal(expected)
