extends GutTest


func test_time_float_to_string() -> void:
	assert_eq(GISUtils.get_time_string_from_seconds(0), "00.00")
	assert_eq(GISUtils.get_time_string_from_seconds(0, 2, true), "0.00")
	assert_eq(GISUtils.get_time_string_from_seconds(0, 2, false, true), "+00.00")
	assert_eq(GISUtils.get_time_string_from_seconds(0, 1, true, false, true), "0:00.0")
	assert_eq(GISUtils.get_time_string_from_seconds(42.21), "42.21")
	assert_eq(GISUtils.get_time_string_from_seconds(42.21, 2, true, false, true), "0:42.21")
	assert_eq(GISUtils.get_time_string_from_seconds(42.21, 2, false, false, true), "00:42.21")
	assert_eq(GISUtils.get_time_string_from_seconds(-10, 2, true), "-10.00")
	assert_eq(GISUtils.get_time_string_from_seconds(3600), "1:00:00.00")
	assert_eq(GISUtils.get_time_string_from_seconds(3599.99), "59:59.99")
	assert_eq(GISUtils.get_time_string_from_seconds(-65.842, 1), "-01:05.8")
	assert_eq(GISUtils.get_time_string_from_seconds(-65.842, 1, true, true), "-1:05.8")
	assert_eq(GISUtils.get_time_string_from_seconds(5.678, 2, true), "5.68")
	assert_eq(GISUtils.get_time_string_from_seconds(5.678, 1, false, true), "+05.7")
	assert_eq(GISUtils.get_time_string_from_seconds(5.678, 3, true, true), "+5.678")
	assert_eq(GISUtils.get_time_string_from_seconds(5.678, 2, true, true, true), "+0:05.68")


func test_time_string_to_float() -> void:
	assert_eq(GISUtils.get_seconds_from_time_string("00:00.00"), 0.0)
	assert_eq(GISUtils.get_seconds_from_time_string("12:34.56"), 754.56)
	assert_eq(GISUtils.get_seconds_from_time_string("12:0:34.56"), 43234.56)
	assert_eq(GISUtils.get_seconds_from_time_string("99:59:59.99"), 359_999.99)
	assert_eq(GISUtils.get_seconds_from_time_string("100:0:0.0"), 360_000.0)
	assert_eq(GISUtils.get_seconds_from_time_string("0:70:80.9990"), 4280.999)
	assert_eq(GISUtils.get_seconds_from_time_string("8."), 8.0)
	assert_eq(GISUtils.get_seconds_from_time_string("0:1:0."), 60.0)
