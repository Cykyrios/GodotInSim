class_name TimeTests
extends RefCounted


func test_time_float_to_string() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("Time value to string")
	superviser.add_result(test_float_to_string(0, "00:00.000"))
	superviser.add_result(test_float_to_string(42.21, "42.210"))
	superviser.add_result(test_float_to_string(-10, "00:00.000"))
	superviser.add_result(test_float_to_string(3600, "1:00:00.000"))
	superviser.add_result(test_float_to_string(3599.99, "59:59.990"))
	superviser.end_test_suite()


func test_time_string_to_float() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("Time string to value")
	superviser.add_result(test_string_to_float("00:00.00", 0))
	superviser.add_result(test_string_to_float("12:34.56", 754.56))
	superviser.add_result(test_string_to_float("12:0:34.56", 43234.56))
	superviser.add_result(test_string_to_float("99:59:59.99", 359_999.99))
	superviser.add_result(test_string_to_float("100:0:0.0", 360_000))
	superviser.add_result(test_string_to_float("0:70:80.9990", 4280.999))
	superviser.add_result(test_string_to_float("8.", 8))
	superviser.add_result(test_string_to_float("0:1:0.", 60))
	superviser.end_test_suite()


func test_float_to_string(input: float, expected: String) -> bool:
	var tester := TimeTester.new()
	tester.test_float_to_string(input, expected)
	if not tester.passed:
		print_rich("[color=red]NOK: %s -> %s[/color]" % [tester.input_float, tester.output_text])
	return tester.passed


func test_string_to_float(input: String, expected: float) -> bool:
	var tester := TimeTester.new()
	tester.test_string_to_float(input, expected)
	if not tester.passed:
		print_rich("[color=red]NOK: %s -> %s[/color]" % [tester.input_text, tester.output_float])
	return tester.passed


class TimeTester extends RefCounted:
	var input_text := ""
	var output_text := ""
	var expected_text := ""
	var input_float := 0.0
	var output_float := 0.0
	var expected_float := 0.0
	var passed := false

	func test_float_to_string(in_float: float, expected_result: String) -> void:
		input_float = in_float
		expected_text = expected_result
		output_text = GISUtils.get_time_string_from_seconds(input_float)
		passed = true if output_text == expected_text else false

	func test_string_to_float(in_text: String, expected_result: float) -> void:
		input_text = in_text
		expected_float = expected_result
		output_float = GISUtils.get_seconds_from_time_strings(input_text)
		passed = true if output_float == expected_float else false
