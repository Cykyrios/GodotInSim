class_name TextTests
extends RefCounted


func test_lfs_to_unicode() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("LFS to UTF8")
	superviser.add_result(test_string_to_unicode("Test string, ASCII only.", "Test string, ASCII only."))
	superviser.add_result(test_string_to_unicode("Other scripts and special characters^c ^J鏺陻質, ^^a^a^v^d.",
			"Other scripts and special characters: 日本語, ^a*|\\."))
	superviser.add_result(test_string_to_unicode("^Eì ^Cø ^JÏ", "ě ш ﾏ"))
	superviser.add_result(test_string_to_unicode("^72^45 ^7B2^4^JÏ ^1Ayoub", "^72^45 ^7B2^4ﾏ ^1Ayoub"))
	superviser.add_result(test_string_to_unicode("^405 ^J¢^7Ï§^4£ ^7TJ", "^405 ｢^7ﾏｧ^4｣ ^7TJ"))
	superviser.end_test_suite()


func test_unicode_to_lfs() -> void:
	var superviser := TestSuperviser.new()
	superviser.start_test_suite("UTF8 to LFS")
	superviser.add_result(test_unicode_to_string("Test string, ASCII only.", "Test string, ASCII only."))
	superviser.add_result(test_unicode_to_string("Other scripts and special characters: 日本語, ^a*|\\.",
			"Other scripts and special characters^c ^J鏺陻質, ^^a^a^v^d."))
	superviser.add_result(test_unicode_to_string("ě ш ﾏ", "^Eì ^Cø ^JÏ"))
	superviser.add_result(test_unicode_to_string("^72^45 ^7B2^4ﾏ ^1Ayoub", "^72^45 ^7B2^4^JÏ ^1Ayoub"))
	superviser.add_result(test_unicode_to_string("^405 ｢^7ﾏｧ^4｣ ^7TJ", "^405 ^J¢^7Ï§^4£ ^7TJ"))
	superviser.end_test_suite()


func test_unicode_to_string(input: String, expected: String) -> bool:
	var tester := TextTester.new()
	tester.test_unicode_to_string(input, expected)
	if not tester.passed:
		print("%s: %s -> %s" % ["OK" if tester.passed else "NOK", tester.input, tester.output])
	return tester.passed


func test_string_to_unicode(input: String, expected: String) -> bool:
	var tester := TextTester.new()
	tester.test_string_to_unicode(input, expected)
	if not tester.passed:
		print("%s: %s -> %s" % ["OK" if tester.passed else "NOK", tester.input, tester.output])
	return tester.passed


class TextTester extends RefCounted:
	var input := ""
	var output := ""
	var expected := ""
	var passed := false

	func test_string_to_unicode(in_text: String, expected_text: String) -> void:
		input = in_text
		expected = expected_text
		output = LFSText.lfs_string_to_unicode(input)
		passed = true if output == expected else false

	func test_unicode_to_string(in_text: String, expected_text: String) -> void:
		input = in_text
		expected = expected_text
		output = LFSText.unicode_to_lfs_string(input)
		passed = true if output == expected else false
