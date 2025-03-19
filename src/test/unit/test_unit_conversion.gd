extends GutTest


var epsilon := 1e-5


var acceleration_params := [
	[10.0, GISUtils.AccelerationUnit.METER_PER_SECOND_SQUARED,
			GISUtils.AccelerationUnit.G, 1.019_367_992],
	[1.0, GISUtils.AccelerationUnit.G, GISUtils.AccelerationUnit.METER_PER_SECOND_SQUARED, 9.81],
	]
func test_acceleration_conversion(params: Array = use_parameters(acceleration_params)) -> void:
	assert_almost_eq(GISUtils.convert_acceleration(
		params[0] as float,
		params[1] as GISUtils.AccelerationUnit,
		params[2] as GISUtils.AccelerationUnit
	), params[3] as float, epsilon)


var angle_params := [
	[10.0, GISUtils.AngleUnit.DEGREE, GISUtils.AngleUnit.RADIAN, 0.174_532_925_2],
	[10.0, GISUtils.AngleUnit.RADIAN, GISUtils.AngleUnit.DEGREE, 572.957_795_1],
	]
func test_angle_conversion(params: Array = use_parameters(angle_params)) -> void:
	assert_almost_eq(GISUtils.convert_angle(
		params[0] as float,
		params[1] as GISUtils.AngleUnit,
		params[2] as GISUtils.AngleUnit
	), params[3] as float, epsilon)


var force_params := [
	[10.0, GISUtils.ForceUnit.NEWTON, GISUtils.ForceUnit.NEWTON, 10.0],
	]
func test_force_conversion(params: Array = use_parameters(force_params)) -> void:
	assert_almost_eq(GISUtils.convert_force(
		params[0] as float,
		params[1] as GISUtils.ForceUnit,
		params[2] as GISUtils.ForceUnit
	), params[3] as float, epsilon)


var length_params := [
	[10.0, GISUtils.LengthUnit.CENTIMETER, GISUtils.LengthUnit.KILOMETER, 0.0001],
	[10.0, GISUtils.LengthUnit.KILOMETER, GISUtils.LengthUnit.MILE, 6.213_711_922],
	]
func test_length_conversion(params: Array = use_parameters(length_params)) -> void:
	assert_almost_eq(GISUtils.convert_length(
		params[0] as float,
		params[1] as GISUtils.LengthUnit,
		params[2] as GISUtils.LengthUnit
	), params[3] as float, epsilon)


var mass_params := [
	[10.0, GISUtils.MassUnit.KILOGRAM, GISUtils.MassUnit.POUND, 22.04622622],
	[10.0, GISUtils.MassUnit.POUND, GISUtils.MassUnit.TONNE, 0.004_535_923_7],
	]
func test_mass_conversion(params: Array = use_parameters(mass_params)) -> void:
	assert_almost_eq(GISUtils.convert_mass(
		params[0] as float,
		params[1] as GISUtils.MassUnit,
		params[2] as GISUtils.MassUnit
	), params[3] as float, epsilon)


var power_params := [
	[10.0, GISUtils.PowerUnit.WATT, GISUtils.PowerUnit.WATT, 10.0],
	]
func test_power_conversion(params: Array = use_parameters(power_params)) -> void:
	assert_almost_eq(GISUtils.convert_power(
		params[0] as float,
		params[1] as GISUtils.PowerUnit,
		params[2] as GISUtils.PowerUnit
	), params[3] as float, epsilon)


var speed_params := [
	[10.0, GISUtils.SpeedUnit.METER_PER_SECOND, GISUtils.SpeedUnit.KPH, 36.0],
	[10.0, GISUtils.SpeedUnit.KPH, GISUtils.SpeedUnit.MPH, 6.213_711_922],
	[100.0, GISUtils.SpeedUnit.MPH, GISUtils.SpeedUnit.KPH, 160.9344],
	]
func test_speed_conversion(params: Array = use_parameters(speed_params)) -> void:
	assert_almost_eq(GISUtils.convert_speed(
		params[0] as float,
		params[1] as GISUtils.SpeedUnit,
		params[2] as GISUtils.SpeedUnit
	), params[3] as float, epsilon)


var time_params := [
	[10.0, GISUtils.TimeUnit.SECOND, GISUtils.TimeUnit.MILLISECOND, 10_000.0],
	[10_000.0, GISUtils.TimeUnit.MILLISECOND, GISUtils.TimeUnit.MINUTE, 1 / 6.0],
	[2.5, GISUtils.TimeUnit.HOUR, GISUtils.TimeUnit.MINUTE, 150.0],
	]
func test_time_conversion(params: Array = use_parameters(time_params)) -> void:
	assert_almost_eq(GISUtils.convert_time(
		params[0] as float,
		params[1] as GISUtils.TimeUnit,
		params[2] as GISUtils.TimeUnit
	), params[3] as float, epsilon)
