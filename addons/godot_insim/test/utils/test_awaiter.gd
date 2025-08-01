extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/utils/awaiter.gd"


func test_await_all_timeout_no_signal() -> void:
	var awaiter := Awaiter.await_all([])
	await assert_signal(awaiter).wait_until(100).is_not_emitted("timed_out")


func test_await_all_timeout() -> void:
	var awaiter := Awaiter.await_all([], get_tree().create_timer(0.1).timeout)
	await assert_signal(awaiter).is_emitted("timed_out")


func test_await_all_timeout_two_signals() -> void:
	var awaiter := Awaiter.await_all(
		[
			get_tree().create_timer(0.05).timeout,
			get_tree().create_timer(1).timeout,
		],
		get_tree().create_timer(0.1).timeout,
	)
	await assert_signal(awaiter).is_emitted("timed_out")


func test_await_all_with_no_signal() -> void:
	var awaiter := Awaiter.await_all([])
	await assert_signal(awaiter).wait_until(100).is_not_emitted("completed")


func test_await_all_with_one_signal() -> void:
	var awaiter := Awaiter.await_all([get_tree().create_timer(0.1).timeout])
	await assert_signal(awaiter).is_emitted("completed")


func test_await_all_with_two_signals() -> void:
	var awaiter := Awaiter.await_all([
		get_tree().create_timer(0.05).timeout,
		get_tree().create_timer(0.1).timeout,
	])
	await assert_signal(awaiter).is_emitted("completed")


func test_await_any_timeout_no_signal() -> void:
	var awaiter := Awaiter.await_any([])
	await assert_signal(awaiter).wait_until(100).is_not_emitted("timed_out")


func test_await_any_timeout() -> void:
	var awaiter := Awaiter.await_any([], get_tree().create_timer(0.1).timeout)
	await assert_signal(awaiter).is_emitted("timed_out")


func test_await_any_timeout_two_signals() -> void:
	var awaiter := Awaiter.await_any(
		[
			get_tree().create_timer(1).timeout,
			get_tree().create_timer(2).timeout,
		],
		get_tree().create_timer(0.1).timeout,
	)
	await assert_signal(awaiter).is_emitted("timed_out")


func test_await_any_with_no_signal() -> void:
	var awaiter := Awaiter.await_any([])
	await assert_signal(awaiter).wait_until(100).is_not_emitted("completed")


func test_await_any_with_one_signal() -> void:
	var awaiter := Awaiter.await_any([get_tree().create_timer(0.1).timeout])
	await assert_signal(awaiter).is_emitted("completed")


func test_await_any_with_two_signals() -> void:
	var awaiter := Awaiter.await_any([
		get_tree().create_timer(0.5).timeout,
		get_tree().create_timer(0.1).timeout,
	])
	await assert_signal(awaiter).is_emitted("completed")
