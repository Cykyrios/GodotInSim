extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/struct/car_cont_obj.gd"

var params := [
	[
		PackedByteArray([0, 225, 22, 56, 234, 1, 211, 37]),
		0, 225, 22, 56, 490, 9683
	],
]
var epsilon := 1e-5

@warning_ignore("unused_parameter")
func test_buffer_to_struct(
	buffer: PackedByteArray, direction: int, heading: int, speed: int, z: int, x: int, y: int,
	test_parameters := params
) -> void:
	var struct := CarContObj.new()
	struct.set_from_buffer(buffer)
	var _test: GdUnitAssert = assert_int(struct.direction).is_equal(direction)
	_test = assert_int(struct.heading).is_equal(heading)
	_test = assert_int(struct.speed).is_equal(speed)
	_test = assert_int(struct.z).is_equal(z)
	_test = assert_int(struct.x).is_equal(x)
	_test = assert_int(struct.y).is_equal(y)
	_test = assert_float(struct.gis_direction).is_equal_approx(struct.direction / CarContObj.ANGLE_MULTIPLIER, epsilon)
	_test = assert_float(struct.gis_heading).is_equal_approx(struct.heading / CarContObj.ANGLE_MULTIPLIER, epsilon)
	_test = assert_float(struct.gis_speed).is_equal_approx(struct.speed / CarContObj.SPEED_MULTIPLIER, epsilon)
	_test = assert_vector(struct.gis_position).is_equal_approx(Vector3(
		struct.x / CarContObj.POSITION_MULTIPLIER,
		struct.y / CarContObj.POSITION_MULTIPLIER,
		struct.z / CarContObj.Z_MULTIPLIER
	), epsilon * Vector3.ONE)


@warning_ignore("unused_parameter")
func test_struct_to_buffer(
	buffer: PackedByteArray, direction: int, heading: int, speed: int, z: int, x: int, y: int,
	test_parameters := params
) -> void:
	var struct := CarContObj.new()
	struct.direction = direction
	struct.heading = heading
	struct.speed = speed
	struct.z = z
	struct.x = x
	struct.y = y
	var _test := assert_array(struct.get_buffer()).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_gis_struct_to_buffer(
	buffer: PackedByteArray, direction: int, heading: int, speed: int, z: int, x: int, y: int,
	test_parameters := params
) -> void:
	var struct := CarContObj.new()
	struct.gis_direction = direction / CarContObj.ANGLE_MULTIPLIER
	struct.gis_heading = heading / CarContObj.ANGLE_MULTIPLIER
	struct.gis_speed = speed / CarContObj.SPEED_MULTIPLIER
	struct.gis_position = Vector3(
		x as int / CarContObj.POSITION_MULTIPLIER,
		y as int / CarContObj.POSITION_MULTIPLIER,
		z as int / CarContObj.Z_MULTIPLIER
	)
	var _test := assert_array(struct.get_buffer(true)).is_equal(buffer)
