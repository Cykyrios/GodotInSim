extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/struct/node_lap.gd"

var params := [
	[
		PackedByteArray([122, 1, 1, 0, 34, 1]),
		378, 1, 34, 1,
	],
]

@warning_ignore("unused_parameter")
func test_buffer_to_struct(
	buffer: PackedByteArray, node: int, lap: int, plid: int, position: int,
	test_parameters := params
) -> void:
	var struct := NodeLap.new()
	struct.set_from_buffer(buffer)
	var _test: GdUnitAssert = assert_int(struct.node).is_equal(node)
	_test = assert_int(struct.lap).is_equal(lap)
	_test = assert_int(struct.plid).is_equal(plid)
	_test = assert_int(struct.position).is_equal(position)


@warning_ignore("unused_parameter")
func test_struct_to_buffer(
	buffer: PackedByteArray, node: int, lap: int, plid: int, position: int,
	test_parameters := params
) -> void:
	var struct := NodeLap.new()
	struct.node = node
	struct.lap = lap
	struct.plid = plid
	struct.position = position
	var _test := assert_array(struct.get_buffer()).is_equal(buffer)
