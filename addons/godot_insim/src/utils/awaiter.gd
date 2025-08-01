class_name Awaiter
extends RefCounted
## Utility class for awaiting multiple signals
##
## This class is used to await multiple signals passed to it, and emits its own signals
## depending on the expected occurrences of those signals:[br]
## - await any single signal[br]
## - await all signals[br]
## - await with an optional maximum delay[br]
## This allows for things like waiting for a particular event, but having a timeout as a
## backup signal, or waiting for multiple conditions to be fulfilled before proceeding.
## [codeblock]
## # Standard use to await any signal
## await Awaiter.await_any([first_signal, second_signal]).completed
## # Same as above, with a 2-second timeout
## var timed_out: bool = await Awaiter.await_any(
## 	[first_signal, second_signal], get_tree().create_timer(2).timeout
## ).completed_or_timed_out
## # Same as above, but including the 2-second timeout as an "expected" signal
## await Awaiter.await_any(
## 	[first_signal, second_signal, get_tree().create_timer(2).timeout]
## ).completed
## # Awaiting all signals, with a 2-second timeout
## var timed_out: bool = await Awaiter.await_all(
## 	[first_signal, second_signal], get_tree().create_timer(2).timeout
## ).completed_or_timed_out
## [/codeblock]

## Emitted when the await condition is fulfilled, i.e. when any or all of the provided signals
## have fired, depending on whether [method await_any] or [method await_all] was called.
signal completed
## Emitted when the await condition is fulfilled (see [signal completed] signal),
## or when the timeout delay passed to [method await_any] or [method await_all] runs out,
## whichever comes first.
signal completed_or_timed_out(timed_out: bool)
## Emitted when the timeout delay passed to [method await_any] or [method await_all]
## runs out, before the await condition is fulfilled.
signal timed_out

# The number of signals to be awaited.
var _remaining_signals := 0
# The signal used to abort await. Should be `get_tree().create_timer(delay).timeout`.
var _timeout_signal := Signal()


## Returns an [Awaiter] that will emit the [signal completed] signal when any of
## the passed [param signals] triggers, with an optional [param timeout_signal] (which should
## be [code]get_tree().create_timer(delay).timeout[/code]) that causes the [signal timed_out]
## signal to be emitted.
static func await_all(signals: Array[Signal], timeout_signal := Signal()) -> Awaiter:
	var awaiter := Awaiter.new(signals, timeout_signal)
	awaiter._remaining_signals = signals.size()
	return awaiter


## Returns an [Awaiter] that will emit the [signal completed] signal after all of
## the passed [param signals] have triggered, with an optional [param timeout_signal]
## (which should be [code]get_tree().create_timer(delay).timeout[/code]) that causes
## the [signal timed_out] signal to be emitted.
static func await_any(signals: Array[Signal], timeout_signal := Signal()) -> Awaiter:
	var awaiter := Awaiter.new(signals, timeout_signal)
	awaiter._remaining_signals = 1
	return awaiter


func _init(signals: Array[Signal], timeout_signal := Signal()) -> void:
	for s in signals:
		var _connect := s.connect(_on_signal, CONNECT_ONE_SHOT)
	if not timeout_signal.is_null():
		_timeout_signal = timeout_signal
		var _connect := _timeout_signal.connect(_on_timeout)


func _on_signal() -> void:
	_remaining_signals -= 1
	if _remaining_signals <= 0:
		completed.emit()
		if not _timeout_signal.is_null():
			completed_or_timed_out.emit(false)


func _on_timeout() -> void:
	timed_out.emit()
	completed_or_timed_out.emit(true)
