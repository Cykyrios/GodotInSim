extends GutTest


func test_time_float_to_string() -> void:
	assert_eq(GISUtils.get_time_string_from_seconds(0), "00:00.000")
	assert_eq(GISUtils.get_time_string_from_seconds(42.21), "42.210")
	assert_eq(GISUtils.get_time_string_from_seconds(-10), "00:00.000")
	assert_eq(GISUtils.get_time_string_from_seconds(3600), "1:00:00.000")
	assert_eq(GISUtils.get_time_string_from_seconds(3599.99), "59:59.990")


func test_time_string_to_float() -> void:
	assert_eq(GISUtils.get_seconds_from_time_string("00:00.00"), 0.0)
	assert_eq(GISUtils.get_seconds_from_time_string("12:34.56"), 754.56)
	assert_eq(GISUtils.get_seconds_from_time_string("12:0:34.56"), 43234.56)
	assert_eq(GISUtils.get_seconds_from_time_string("99:59:59.99"), 359_999.99)
	assert_eq(GISUtils.get_seconds_from_time_string("100:0:0.0"), 360_000.0)
	assert_eq(GISUtils.get_seconds_from_time_string("0:70:80.9990"), 4280.999)
	assert_eq(GISUtils.get_seconds_from_time_string("8."), 8.0)
	assert_eq(GISUtils.get_seconds_from_time_string("0:1:0."), 60.0)
