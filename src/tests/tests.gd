extends Node


var text_tests := TextTests.new()
var unit_conversion_tests := UnitConversionTests.new()
var time_tests := TimeTests.new()


func _ready() -> void:
	run_tests()


func run_tests() -> void:
	text_tests.test_unicode_to_lfs()
	text_tests.test_lfs_to_unicode()
	unit_conversion_tests.test_unit_conversions()
	time_tests.test_time_float_to_string()
	time_tests.test_time_string_to_float()
