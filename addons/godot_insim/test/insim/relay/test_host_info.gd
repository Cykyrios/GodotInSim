extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/relay/host_info.gd"

var params := [
	[
		PackedByteArray([
			94, 49, 40, 94, 51, 70, 77, 94, 49, 41, 32, 94, 52, 70, 111, 120, 32,
			70, 114, 105, 100, 97, 121, 0, 0, 0, 0, 0, 0, 0, 0, 0, 76, 65, 49, 0,
			0, 0, 82, 1,
		]),
		"^1(^3FM^1) ^4Fox Friday", "LA1", 82, 1,
	],
	[
		PackedByteArray([
			94, 50, 82, 111, 110, 121, 115, 32, 94, 51, 84, 117, 101, 115, 100, 97,
			121, 115, 32, 94, 53, 70, 117, 110, 32, 94, 50, 82, 97, 99, 101, 0, 82,
			79, 50, 0, 0, 0, 18, 1,
		]),
		"^2Ronys ^3Tuesdays ^5Fun ^2Race", "RO2", 18, 1,
	],
	[
		PackedByteArray([
			94, 48, 91, 94, 55, 77, 82, 94, 48, 99, 93, 94, 55, 32, 66, 101, 103,
			105, 110, 110, 101, 114, 94, 48, 32, 66, 77, 87, 0, 0, 0, 0, 66, 76,
			50, 0, 0, 0, 0, 4,
		]),
		"^0[^7MR^0c]^7 Beginner^0 BMW", "BL2", 0, 4,
	],
]

@warning_ignore("unused_parameter")
func test_buffer_to_struct(
	buffer: PackedByteArray, host_name: String, track: String, flags: int, num_conns: int,
	test_parameters := params,
) -> void:
	var struct := HostInfo.new()
	struct.set_from_buffer(buffer)
	var _test: GdUnitAssert = assert_str(struct.host_name).is_equal(host_name)
	_test = assert_str(struct.track).is_equal(track)
	_test = assert_int(struct.flags).is_equal(flags)
	_test = assert_int(struct.num_conns).is_equal(num_conns)


@warning_ignore("unused_parameter")
func test_struct_to_buffer(
	buffer: PackedByteArray, host_name: String, track: String, flags: int, num_conns: int,
	test_parameters := params,
) -> void:
	var struct := HostInfo.new()
	struct.host_name = host_name
	struct.track = track
	struct.flags = flags
	struct.num_conns = num_conns
	var _test := assert_array(struct.get_buffer()).is_equal(buffer)
