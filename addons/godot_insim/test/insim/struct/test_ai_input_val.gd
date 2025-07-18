extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/struct/ai_input_val.gd"

var epsilon := 1e-5
var params := [
	[
		PackedByteArray([1, 10, 0, 128]),
		InSim.AIControl.CS_THROTTLE, 10, 32768
	],
]


@warning_ignore("unused_parameter")
func test_buffer_to_struct(
	buffer: PackedByteArray, input: InSim.AIControl, time: int, value: int,
	test_parameters := params
) -> void:
	var struct := AIInputVal.new()
	struct.set_from_buffer(buffer)
	var _test: GdUnitAssert = assert_int(struct.input).is_equal(input)
	_test = assert_int(struct.time).is_equal(time)
	_test = assert_float(struct.gis_time).is_equal_approx(
		time / AIInputVal.TIME_MULTIPLIER, epsilon
	)
	_test = assert_int(struct.value).is_equal(value)


@warning_ignore("unused_parameter")
func test_struct_to_buffer(
	buffer: PackedByteArray, input: InSim.AIControl, time: int, value: int,
	test_parameters := params
) -> void:
	var struct := AIInputVal.new()
	struct.input = input
	struct.time = time
	struct.value = value
	var _test := assert_array(struct.get_buffer()).is_equal(buffer)
