extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/utils/gis_time.gd"


func test_get_time_string_from_seconds() -> void:
	var _test := assert_str(GISTime.get_time_string_from_seconds(0)) \
			.is_equal("00.00")
	_test = assert_str(GISTime.get_time_string_from_seconds(0, 2, true)) \
			.is_equal("0.00")
	_test = assert_str(GISTime.get_time_string_from_seconds(0, 2, false, true)) \
			.is_equal("+00.00")
	_test = assert_str(GISTime.get_time_string_from_seconds(0, 1, true, false, true)) \
			.is_equal("0:00.0")
	_test = assert_str(GISTime.get_time_string_from_seconds(42.21)) \
			.is_equal("42.21")
	_test = assert_str(GISTime.get_time_string_from_seconds(42.21, 2, true, false, true)) \
			.is_equal("0:42.21")
	_test = assert_str(GISTime.get_time_string_from_seconds(42.21, 2, false, false, true)) \
			.is_equal("00:42.21")
	_test = assert_str(GISTime.get_time_string_from_seconds(-10, 2, true)) \
			.is_equal("-10.00")
	_test = assert_str(GISTime.get_time_string_from_seconds(3600)) \
			.is_equal("1:00:00.00")
	_test = assert_str(GISTime.get_time_string_from_seconds(3599.99)) \
			.is_equal("59:59.99")
	_test = assert_str(GISTime.get_time_string_from_seconds(-65.842, 1)) \
			.is_equal("-01:05.8")
	_test = assert_str(GISTime.get_time_string_from_seconds(-65.842, 1, true, true)) \
			.is_equal("-1:05.8")
	_test = assert_str(GISTime.get_time_string_from_seconds(5.678, 2, true)) \
			.is_equal("5.68")
	_test = assert_str(GISTime.get_time_string_from_seconds(5.678, 1, false, true)) \
			.is_equal("+05.7")
	_test = assert_str(GISTime.get_time_string_from_seconds(5.678, 3, true, true)) \
			.is_equal("+5.678")
	_test = assert_str(GISTime.get_time_string_from_seconds(5.678, 2, true, true, true)) \
			.is_equal("+0:05.68")


func test_get_seconds_from_time_string() -> void:
	var _test := assert_float(GISTime.get_seconds_from_time_string("00:00.00")) \
			.is_equal(0.0)
	_test = assert_float(GISTime.get_seconds_from_time_string("12:34.56")) \
			.is_equal(754.56)
	_test = assert_float(GISTime.get_seconds_from_time_string("12:0:34.56")) \
			.is_equal(43234.56)
	_test = assert_float(GISTime.get_seconds_from_time_string("99:59:59.99")) \
			.is_equal(359_999.99)
	_test = assert_float(GISTime.get_seconds_from_time_string("100:0:0.0")) \
			.is_equal(360_000.0)
	_test = assert_float(GISTime.get_seconds_from_time_string("0:70:80.9990")) \
			.is_equal(4280.999)
	_test = assert_float(GISTime.get_seconds_from_time_string("8.")) \
			.is_equal(8.0)
	_test = assert_float(GISTime.get_seconds_from_time_string("0:1:0.")) \
			.is_equal(60.0)
