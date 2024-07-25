class_name TestSuperviser
extends RefCounted


var title := ""
var test_count := 0
var passed_tests := 0
var failed_tests := 0


func add_result(result: bool) -> void:
	test_count += 1
	if result:
		passed_tests += 1
	else:
		failed_tests += 1


func end_test_suite() -> void:
	assert(passed_tests + failed_tests == test_count,
			"Incoherent test count, expected %d, got %d." % [test_count, passed_tests + failed_tests])
	print_rich("%s: %d tests run, %s%d failed%s." % [title, test_count,
			"[color=red]" if failed_tests > 0 else "", failed_tests, "[/color]" if failed_tests > 0 else ""])


func start_test_suite(test_title := "test") -> void:
	title = test_title
	test_count = 0
	passed_tests = 0
	failed_tests = 0
