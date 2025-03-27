extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/struct/object_info.gd"

var params := [
	[
		PackedByteArray([27, 255, 203, 18, 0, 40, 253, 4]),
		-229, 4811, 0, 40, 253, 4,
	],
]
var epsilon := 1e-5


@warning_ignore("unused_parameter")
func test_buffer_to_struct(
	buffer: PackedByteArray, x: int, y: int, z: int, flags: int, index: int, heading: int,
	test_parameters := params
) -> void:
	var struct := ObjectInfo.new()
	struct.set_from_buffer(buffer)
	var _test: GdUnitAssert = assert_int(struct.x).is_equal(x)
	_test = assert_int(struct.y).is_equal(y)
	_test = assert_int(struct.z).is_equal(z)
	_test = assert_int(struct.flags).is_equal(flags)
	_test = assert_int(struct.index).is_equal(index)
	_test = assert_int(struct.heading).is_equal(heading)
	_test = assert_vector(struct.gis_position).is_equal_approx(Vector3(
		struct.x / ObjectInfo.POSITION_MULTIPLIER,
		struct.y / ObjectInfo.POSITION_MULTIPLIER,
		struct.z / ObjectInfo.Z_MULTIPLIER
	), epsilon * Vector3.ONE)
	var angle := deg_to_rad(struct.heading / ObjectInfo.ANGLE_MULTIPLIER - 180)
	_test = assert_float(struct.gis_heading).is_equal_approx(angle, epsilon)


@warning_ignore("unused_parameter")
func test_struct_to_buffer(
	buffer: PackedByteArray, x: int, y: int, z: int, flags: int, index: int, heading: int,
	test_parameters := params
) -> void:
	var struct := ObjectInfo.new()
	struct.x = x
	struct.y = y
	struct.z = z
	struct.flags = flags
	struct.index = index
	struct.heading = heading
	var _test := assert_array(struct.get_buffer()).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_gis_struct_to_buffer(
	buffer: PackedByteArray, x: int, y: int, z: int, flags: int, index: int, heading: int,
	test_parameters := params
) -> void:
	var struct := ObjectInfo.new()
	struct.flags = flags
	struct.index = index
	struct.gis_position = Vector3(x, y, z) \
			/ ObjectInfo.POSITION_MULTIPLIER
	struct.gis_heading = deg_to_rad(heading / ObjectInfo.ANGLE_MULTIPLIER - 180)
	var _test := assert_array(struct.get_buffer(true)).is_equal(buffer)
