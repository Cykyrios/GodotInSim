class_name UnitConversionTests
extends RefCounted


func test_unit_conversions() -> void:
	test_acceleration_conversions()
	test_angle_conversions()
	test_force_conversions()
	test_length_conversions()
	test_mass_conversions()
	test_power_conversions()
	test_speed_conversions()
	test_time_conversions()


func test_acceleration_conversions() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("Acceleration conversion")
	superviser.add_result(test_acceleration_conversion(10, GISUtils.AccelerationUnit.METER_PER_SECOND_SQUARED,
			GISUtils.AccelerationUnit.G, 1.019_367_992))
	superviser.add_result(test_acceleration_conversion(1, GISUtils.AccelerationUnit.G,
			GISUtils.AccelerationUnit.METER_PER_SECOND_SQUARED, 9.81))
	superviser.end_test_suite()


func test_acceleration_conversion(
	value: float, from: GISUtils.AccelerationUnit, to: GISUtils.AccelerationUnit, expected: float
) -> bool:
	var tester := UnitConversionTester.new()
	tester.test_acceleration_conversion(value, from, to, expected)
	if not tester.passed:
		print_rich("[color=red]NOK: %f %s -> %f %s[/color]" % [tester.input,
				GISUtils.AccelerationUnit.keys()[from], tester.output, GISUtils.AccelerationUnit.keys()[to]])
	return tester.passed


func test_angle_conversions() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("Angle conversion")
	superviser.add_result(test_angle_conversion(10, GISUtils.AngleUnit.DEGREE,
			GISUtils.AngleUnit.RADIAN, 0.174_532_925_2))
	superviser.add_result(test_angle_conversion(10, GISUtils.AngleUnit.RADIAN,
			GISUtils.AngleUnit.DEGREE, 572.957_795_1))
	superviser.end_test_suite()


func test_angle_conversion(
	value: float, from: GISUtils.AngleUnit, to: GISUtils.AngleUnit, expected: float
) -> bool:
	var tester := UnitConversionTester.new()
	tester.test_angle_conversion(value, from, to, expected)
	if not tester.passed:
		print_rich("[color=red]NOK: %f %s -> %f %s[/color]" % [tester.input,
				GISUtils.AngleUnit.keys()[from], tester.output, GISUtils.AngleUnit.keys()[to]])
	return tester.passed


func test_force_conversions() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("Force conversion")
	superviser.add_result(test_force_conversion(10, GISUtils.ForceUnit.NEWTON,
			GISUtils.ForceUnit.NEWTON, 10))
	superviser.end_test_suite()


func test_force_conversion(
	value: float, from: GISUtils.ForceUnit, to: GISUtils.ForceUnit, expected: float
) -> bool:
	var tester := UnitConversionTester.new()
	tester.test_force_conversion(value, from, to, expected)
	if not tester.passed:
		print_rich("[color=red]NOK: %f %s -> %f %s[/color]" % [tester.input,
				GISUtils.ForceUnit.keys()[from], tester.output, GISUtils.ForceUnit.keys()[to]])
	return tester.passed


func test_length_conversions() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("Length conversion")
	superviser.add_result(test_length_conversion(10, GISUtils.LengthUnit.CENTIMETER,
			GISUtils.LengthUnit.KILOMETER, 0.0001))
	superviser.add_result(test_length_conversion(10, GISUtils.LengthUnit.KILOMETER,
			GISUtils.LengthUnit.MILE, 6.213_711_922))
	superviser.end_test_suite()


func test_length_conversion(
	value: float, from: GISUtils.LengthUnit, to: GISUtils.LengthUnit, expected: float
) -> bool:
	var tester := UnitConversionTester.new()
	tester.test_length_conversion(value, from, to, expected)
	if not tester.passed:
		print_rich("[color=red]NOK: %f %s -> %f %s[/color]" % [tester.input,
				GISUtils.LengthUnit.keys()[from], tester.output, GISUtils.LengthUnit.keys()[to]])
	return tester.passed


func test_mass_conversions() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("Mass conversion")
	superviser.add_result(test_mass_conversion(10, GISUtils.MassUnit.KILOGRAM,
			GISUtils.MassUnit.POUND, 22.04622622))
	superviser.add_result(test_mass_conversion(10, GISUtils.MassUnit.POUND,
			GISUtils.MassUnit.TONNE, 0.004_535_923_7))
	superviser.end_test_suite()


func test_mass_conversion(
	value: float, from: GISUtils.MassUnit, to: GISUtils.MassUnit, expected: float
) -> bool:
	var tester := UnitConversionTester.new()
	tester.test_mass_conversion(value, from, to, expected)
	if not tester.passed:
		print_rich("[color=red]NOK: %f %s -> %f %s[/color]" % [tester.input,
				GISUtils.MassUnit.keys()[from], tester.output, GISUtils.MassUnit.keys()[to]])
	return tester.passed


func test_power_conversions() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("Power conversion")
	superviser.add_result(test_power_conversion(10, GISUtils.PowerUnit.WATT,
			GISUtils.PowerUnit.WATT, 10))
	superviser.end_test_suite()


func test_power_conversion(
	value: float, from: GISUtils.PowerUnit, to: GISUtils.PowerUnit, expected: float
) -> bool:
	var tester := UnitConversionTester.new()
	tester.test_power_conversion(value, from, to, expected)
	if not tester.passed:
		print_rich("[color=red]NOK: %f %s -> %f %s[/color]" % [tester.input,
				GISUtils.PowerUnit.keys()[from], tester.output, GISUtils.PowerUnit.keys()[to]])
	return tester.passed


func test_speed_conversions() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("Speed conversion")
	superviser.add_result(test_speed_conversion(10, GISUtils.SpeedUnit.METER_PER_SECOND,
			GISUtils.SpeedUnit.KPH, 36))
	superviser.add_result(test_speed_conversion(10, GISUtils.SpeedUnit.KPH,
			GISUtils.SpeedUnit.MPH, 6.213_711_922))
	superviser.add_result(test_speed_conversion(100, GISUtils.SpeedUnit.MPH,
			GISUtils.SpeedUnit.KPH, 160.9344))
	superviser.end_test_suite()


func test_speed_conversion(
	value: float, from: GISUtils.SpeedUnit, to: GISUtils.SpeedUnit, expected: float
) -> bool:
	var tester := UnitConversionTester.new()
	tester.test_speed_conversion(value, from, to, expected)
	if not tester.passed:
		print_rich("[color=red]NOK: %f %s -> %f %s[/color]" % [tester.input,
				GISUtils.SpeedUnit.keys()[from], tester.output, GISUtils.SpeedUnit.keys()[to]])
	return tester.passed


func test_time_conversions() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("Time conversion")
	superviser.add_result(test_time_conversion(10, GISUtils.TimeUnit.SECOND,
			GISUtils.TimeUnit.MILLISECOND, 10_000))
	superviser.add_result(test_time_conversion(10_000, GISUtils.TimeUnit.MILLISECOND,
			GISUtils.TimeUnit.MINUTE, 1 / 6.0))
	superviser.add_result(test_time_conversion(2.5, GISUtils.TimeUnit.HOUR,
			GISUtils.TimeUnit.MINUTE, 150))
	superviser.end_test_suite()


func test_time_conversion(
	value: float, from: GISUtils.TimeUnit, to: GISUtils.TimeUnit, expected: float
) -> bool:
	var tester := UnitConversionTester.new()
	tester.test_time_conversion(value, from, to, expected)
	if not tester.passed:
		print_rich("[color=red]NOK: %f %s -> %f %s[/color]" % [tester.input,
				GISUtils.TimeUnit.keys()[from], tester.output, GISUtils.TimeUnit.keys()[to]])
	return tester.passed


class UnitConversionTester extends RefCounted:
	var input := 0.0
	var output := 0.0
	var expected := 0.0
	var from_unit := 0
	var to_unit := 0
	var passed := false

	func test_acceleration_conversion(
		value: float, from: GISUtils.AccelerationUnit, to: GISUtils.AccelerationUnit, expected_result: float
	) -> void:
		input = value
		expected = expected_result
		output = value / GISUtils.ACCELERATIONS[from] * GISUtils.ACCELERATIONS[to]
		passed = true if is_equal_approx(output, expected) else false

	func test_angle_conversion(
		value: float, from: GISUtils.AngleUnit, to: GISUtils.AngleUnit, expected_result: float
	) -> void:
		input = value
		expected = expected_result
		output = value / GISUtils.ANGLES[from] * GISUtils.ANGLES[to]
		passed = true if is_equal_approx(output, expected) else false

	func test_force_conversion(
		value: float, from: GISUtils.ForceUnit, to: GISUtils.ForceUnit, expected_result: float
	) -> void:
		input = value
		expected = expected_result
		output = value / GISUtils.FORCES[from] * GISUtils.FORCES[to]
		passed = true if is_equal_approx(output, expected) else false

	func test_length_conversion(
		value: float, from: GISUtils.LengthUnit, to: GISUtils.LengthUnit, expected_result: float
	) -> void:
		input = value
		expected = expected_result
		output = value / GISUtils.LENGTHS[from] * GISUtils.LENGTHS[to]
		passed = true if is_equal_approx(output, expected) else false

	func test_mass_conversion(
		value: float, from: GISUtils.MassUnit, to: GISUtils.MassUnit, expected_result: float
	) -> void:
		input = value
		expected = expected_result
		output = value / GISUtils.MASSES[from] * GISUtils.MASSES[to]
		passed = true if is_equal_approx(output, expected) else false

	func test_power_conversion(
		value: float, from: GISUtils.PowerUnit, to: GISUtils.PowerUnit, expected_result: float
	) -> void:
		input = value
		expected = expected_result
		output = value / GISUtils.POWERS[from] * GISUtils.POWERS[to]
		passed = true if is_equal_approx(output, expected) else false

	func test_speed_conversion(
		value: float, from: GISUtils.SpeedUnit, to: GISUtils.SpeedUnit, expected_result: float
	) -> void:
		input = value
		expected = expected_result
		output = value / GISUtils.SPEEDS[from] * GISUtils.SPEEDS[to]
		passed = true if is_equal_approx(output, expected) else false

	func test_time_conversion(
		value: float, from: GISUtils.TimeUnit, to: GISUtils.TimeUnit, expected_result: float
	) -> void:
		input = value
		expected = expected_result
		output = value / GISUtils.TIMES[from] * GISUtils.TIMES[to]
		passed = true if is_equal_approx(output, expected) else false
