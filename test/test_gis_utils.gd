extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/gis_utils.gd"


var epsilon := 1e-5


@warning_ignore("unused_parameter")
func test_convert_acceleration(
	value: float, unit_in: GISUtils.AccelerationUnit, unit_out: GISUtils.AccelerationUnit,
	expected: float, test_parameters := [
		[10.0, GISUtils.AccelerationUnit.METER_PER_SECOND_SQUARED,
				GISUtils.AccelerationUnit.G, 1.019_367_992],
		[1.0, GISUtils.AccelerationUnit.G,
				GISUtils.AccelerationUnit.METER_PER_SECOND_SQUARED, 9.81],
	]
) -> void:
	var _test := assert_float(GISUtils.convert_acceleration(value, unit_in, unit_out)) \
			.is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_angle_conversion(
	value: float, unit_in: GISUtils.AngleUnit, unit_out: GISUtils.AngleUnit,
	expected: float, test_parameters := [
		[10.0, GISUtils.AngleUnit.DEGREE, GISUtils.AngleUnit.RADIAN, 0.174_532_925_2],
		[10.0, GISUtils.AngleUnit.RADIAN, GISUtils.AngleUnit.DEGREE, 572.957_795_1],
	]
) -> void:
	var _test := assert_float(GISUtils.convert_angle(value, unit_in, unit_out)) \
			.is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_force_conversion(
	value: float, unit_in: GISUtils.ForceUnit, unit_out: GISUtils.ForceUnit,
	expected: float, test_parameters := [
		[10.0, GISUtils.ForceUnit.NEWTON, GISUtils.ForceUnit.NEWTON, 10.0],
	]
) -> void:
	var _test := assert_float(GISUtils.convert_force(value, unit_in, unit_out)) \
			.is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_length_conversion(
	value: float, unit_in: GISUtils.LengthUnit, unit_out: GISUtils.LengthUnit,
	expected: float, test_parameters := [
		[10.0, GISUtils.LengthUnit.CENTIMETER, GISUtils.LengthUnit.KILOMETER, 0.0001],
		[10.0, GISUtils.LengthUnit.KILOMETER, GISUtils.LengthUnit.MILE, 6.213_711_922],
	]
) -> void:
	var _test := assert_float(GISUtils.convert_length(value, unit_in, unit_out)) \
			.is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_mass_conversion(
	value: float, unit_in: GISUtils.MassUnit, unit_out: GISUtils.MassUnit,
	expected: float, test_parameters := [
		[10.0, GISUtils.MassUnit.KILOGRAM, GISUtils.MassUnit.POUND, 22.04622622],
		[10.0, GISUtils.MassUnit.POUND, GISUtils.MassUnit.TONNE, 0.004_535_923_7],
	]
) -> void:
	var _test := assert_float(GISUtils.convert_mass(value, unit_in, unit_out)) \
			.is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_power_conversion(
	value: float, unit_in: GISUtils.PowerUnit, unit_out: GISUtils.PowerUnit,
	expected: float, test_parameters := [
		[10.0, GISUtils.PowerUnit.WATT, GISUtils.PowerUnit.WATT, 10.0],
	]
) -> void:
	var _test := assert_float(GISUtils.convert_power(value, unit_in, unit_out)) \
			.is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_speed_conversion(
	value: float, unit_in: GISUtils.SpeedUnit, unit_out: GISUtils.SpeedUnit,
	expected: float, test_parameters := [
		[10.0, GISUtils.SpeedUnit.METER_PER_SECOND, GISUtils.SpeedUnit.KPH, 36.0],
		[10.0, GISUtils.SpeedUnit.KPH, GISUtils.SpeedUnit.MPH, 6.213_711_922],
		[100.0, GISUtils.SpeedUnit.MPH, GISUtils.SpeedUnit.KPH, 160.9344],
	]
) -> void:
	var _test := assert_float(GISUtils.convert_speed(value, unit_in, unit_out)) \
			.is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_time_conversion(
	value: float, unit_in: GISUtils.TimeUnit, unit_out: GISUtils.TimeUnit,
	expected: float, test_parameters := [
		[10.0, GISUtils.TimeUnit.SECOND, GISUtils.TimeUnit.MILLISECOND, 10_000.0],
		[10_000.0, GISUtils.TimeUnit.MILLISECOND, GISUtils.TimeUnit.MINUTE, 1 / 6.0],
		[2.5, GISUtils.TimeUnit.HOUR, GISUtils.TimeUnit.MINUTE, 150.0],
	]
) -> void:
	var _test := assert_float(GISUtils.convert_time(value, unit_in, unit_out)) \
			.is_equal_approx(expected, epsilon)


func test_get_time_string_from_seconds() -> void:
	var _test := assert_str(GISUtils.get_time_string_from_seconds(0)) \
			.is_equal("00.00")
	_test = assert_str(GISUtils.get_time_string_from_seconds(0, 2, true)) \
			.is_equal("0.00")
	_test = assert_str(GISUtils.get_time_string_from_seconds(0, 2, false, true)) \
			.is_equal("+00.00")
	_test = assert_str(GISUtils.get_time_string_from_seconds(0, 1, true, false, true)) \
			.is_equal("0:00.0")
	_test = assert_str(GISUtils.get_time_string_from_seconds(42.21)) \
			.is_equal("42.21")
	_test = assert_str(GISUtils.get_time_string_from_seconds(42.21, 2, true, false, true)) \
			.is_equal("0:42.21")
	_test = assert_str(GISUtils.get_time_string_from_seconds(42.21, 2, false, false, true)) \
			.is_equal("00:42.21")
	_test = assert_str(GISUtils.get_time_string_from_seconds(-10, 2, true)) \
			.is_equal("-10.00")
	_test = assert_str(GISUtils.get_time_string_from_seconds(3600)) \
			.is_equal("1:00:00.00")
	_test = assert_str(GISUtils.get_time_string_from_seconds(3599.99)) \
			.is_equal("59:59.99")
	_test = assert_str(GISUtils.get_time_string_from_seconds(-65.842, 1)) \
			.is_equal("-01:05.8")
	_test = assert_str(GISUtils.get_time_string_from_seconds(-65.842, 1, true, true)) \
			.is_equal("-1:05.8")
	_test = assert_str(GISUtils.get_time_string_from_seconds(5.678, 2, true)) \
			.is_equal("5.68")
	_test = assert_str(GISUtils.get_time_string_from_seconds(5.678, 1, false, true)) \
			.is_equal("+05.7")
	_test = assert_str(GISUtils.get_time_string_from_seconds(5.678, 3, true, true)) \
			.is_equal("+5.678")
	_test = assert_str(GISUtils.get_time_string_from_seconds(5.678, 2, true, true, true)) \
			.is_equal("+0:05.68")


func test_get_seconds_from_time_string() -> void:
	var _test := assert_float(GISUtils.get_seconds_from_time_string("00:00.00")) \
			.is_equal(0.0)
	_test = assert_float(GISUtils.get_seconds_from_time_string("12:34.56")) \
			.is_equal(754.56)
	_test = assert_float(GISUtils.get_seconds_from_time_string("12:0:34.56")) \
			.is_equal(43234.56)
	_test = assert_float(GISUtils.get_seconds_from_time_string("99:59:59.99")) \
			.is_equal(359_999.99)
	_test = assert_float(GISUtils.get_seconds_from_time_string("100:0:0.0")) \
			.is_equal(360_000.0)
	_test = assert_float(GISUtils.get_seconds_from_time_string("0:70:80.9990")) \
			.is_equal(4280.999)
	_test = assert_float(GISUtils.get_seconds_from_time_string("8.")) \
			.is_equal(8.0)
	_test = assert_float(GISUtils.get_seconds_from_time_string("0:1:0.")) \
			.is_equal(60.0)
