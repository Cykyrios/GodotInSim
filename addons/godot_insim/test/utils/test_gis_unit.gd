extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/utils/gis_unit.gd"

var epsilon := 1e-5


@warning_ignore("unused_parameter")
func test_convert_acceleration(
	value: float, unit_in: GISUnit.Acceleration, unit_out: GISUnit.Acceleration,
	expected: float, test_parameters := [
		[10.0, GISUnit.Acceleration.METER_PER_SECOND_SQUARED,
				GISUnit.Acceleration.G, 1.019_367_992],
		[1.0, GISUnit.Acceleration.G,
				GISUnit.Acceleration.METER_PER_SECOND_SQUARED, 9.81],
	]
) -> void:
	var _test := assert_float(
		GISUnit.convert_acceleration(value, unit_in, unit_out)
	).is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_convert_angle(
	value: float, unit_in: GISUnit.Angle, unit_out: GISUnit.Angle,
	expected: float, test_parameters := [
		[10.0, GISUnit.Angle.DEGREE, GISUnit.Angle.RADIAN, 0.174_532_925_2],
		[10.0, GISUnit.Angle.RADIAN, GISUnit.Angle.DEGREE, 572.957_795_1],
	]
) -> void:
	var _test := assert_float(
		GISUnit.convert_angle(value, unit_in, unit_out)
	).is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_convert_angular_speed(
	value: float, unit_in: GISUnit.AngularSpeed, unit_out: GISUnit.AngularSpeed,
	expected: float, test_parameters := [
		[100.0, GISUnit.AngularSpeed.RADIAN_PER_SECOND, GISUnit.AngularSpeed.RPM, 954.929_658_6],
		[1000.0, GISUnit.AngularSpeed.RPM, GISUnit.AngularSpeed.RADIAN_PER_SECOND, 104.719_755],
	]
) -> void:
	var _test := assert_float(
		GISUnit.convert_angular_speed(value, unit_in, unit_out)
	).is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_convert_force(
	value: float, unit_in: GISUnit.Force, unit_out: GISUnit.Force,
	expected: float, test_parameters := [
		[10.0, GISUnit.Force.NEWTON, GISUnit.Force.NEWTON, 10.0],
	]
) -> void:
	var _test := assert_float(
		GISUnit.convert_force(value, unit_in, unit_out)
	).is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_convert_length(
	value: float, unit_in: GISUnit.Length, unit_out: GISUnit.Length,
	expected: float, test_parameters := [
		[10.0, GISUnit.Length.CENTIMETER, GISUnit.Length.KILOMETER, 0.0001],
		[10.0, GISUnit.Length.KILOMETER, GISUnit.Length.MILE, 6.213_711_922],
		[1.0, GISUnit.Length.INCH, GISUnit.Length.MILLIMETER, 25.4],
	]
) -> void:
	var _test := assert_float(
		GISUnit.convert_length(value, unit_in, unit_out)
	).is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_convert_mass(
	value: float, unit_in: GISUnit.Mass, unit_out: GISUnit.Mass,
	expected: float, test_parameters := [
		[10.0, GISUnit.Mass.KILOGRAM, GISUnit.Mass.POUND, 22.04622622],
		[10.0, GISUnit.Mass.POUND, GISUnit.Mass.TONNE, 0.004_535_923_7],
	]
) -> void:
	var _test := assert_float(
		GISUnit.convert_mass(value, unit_in, unit_out)
	).is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_convert_power(
	value: float, unit_in: GISUnit.Power, unit_out: GISUnit.Power,
	expected: float, test_parameters := [
		[10.0, GISUnit.Power.WATT, GISUnit.Power.WATT, 10.0],
	]
) -> void:
	var _test := assert_float(
		GISUnit.convert_power(value, unit_in, unit_out)
	).is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_convert_speed(
	value: float, unit_in: GISUnit.Speed, unit_out: GISUnit.Speed,
	expected: float, test_parameters := [
		[10.0, GISUnit.Speed.METER_PER_SECOND, GISUnit.Speed.KPH, 36.0],
		[10.0, GISUnit.Speed.KPH, GISUnit.Speed.MPH, 6.213_711_922],
		[100.0, GISUnit.Speed.MPH, GISUnit.Speed.KPH, 160.9344],
	]
) -> void:
	var _test := assert_float(
		GISUnit.convert_speed(value, unit_in, unit_out)
	).is_equal_approx(expected, epsilon)


@warning_ignore("unused_parameter")
func test_convert_duration(
	value: float, unit_in: GISUnit.Duration, unit_out: GISUnit.Duration,
	expected: float, test_parameters := [
		[10.0, GISUnit.Duration.SECOND, GISUnit.Duration.MILLISECOND, 10_000.0],
		[10_000.0, GISUnit.Duration.MILLISECOND, GISUnit.Duration.MINUTE, 1 / 6.0],
		[2.5, GISUnit.Duration.HOUR, GISUnit.Duration.MINUTE, 150.0],
	]
) -> void:
	var _test := assert_float(
		GISUnit.convert_duration(value, unit_in, unit_out)
	).is_equal_approx(expected, epsilon)
