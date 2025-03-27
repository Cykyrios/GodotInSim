extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/struct/comp_car.gd"

var params := [
	[
		PackedByteArray([122, 1, 1, 0, 34, 1, 192, 0, 5, 136, 229, 255, 81, 67, 255, 0,
				208, 40, 0, 0, 110, 43, 135, 242, 117, 244, 124, 6]),
		378, 1, 34, 1, 192, 0, -1734651, 16728913, 10448, 11118, 62087, 62581, 1660,
	],
]
var epsilon := 1e-5


@warning_ignore("unused_parameter")
func test_buffer_to_struct(
	buffer: PackedByteArray, node: int, lap: int, plid: int, position: int, info: int, sp3: int,
	x: int, y: int, z: int,speed: int, direction: int, heading: int, ang_vel: int,
	test_parameters := params
) -> void:
	var struct := CompCar.new()
	struct.set_from_buffer(buffer)
	var _test: GdUnitAssert = assert_int(struct.node).is_equal(node)
	_test = assert_int(struct.lap).is_equal(lap)
	_test = assert_int(struct.plid).is_equal(plid)
	_test = assert_int(struct.position).is_equal(position)
	_test = assert_int(struct.info).is_equal(info)
	_test = assert_int(struct.sp3).is_equal(sp3)
	_test = assert_int(struct.x).is_equal(x)
	_test = assert_int(struct.y).is_equal(y)
	_test = assert_int(struct.z).is_equal(z)
	_test = assert_int(struct.speed).is_equal(speed)
	_test = assert_int(struct.direction).is_equal(direction)
	_test = assert_int(struct.heading).is_equal(heading)
	_test = assert_int(struct.ang_vel).is_equal(ang_vel)
	_test = assert_vector(struct.gis_position) \
			.is_equal_approx(Vector3(struct.x, struct.y, struct.z) \
			/ CompCar.POSITION_MULTIPLIER, epsilon * Vector3.ONE)
	_test = assert_float(struct.gis_speed) \
			.is_equal_approx(struct.speed / CompCar.SPEED_MULTIPLIER, epsilon)
	_test = assert_float(struct.gis_direction) \
			.is_equal_approx(deg_to_rad(struct.direction / CompCar.ANGLE_MULTIPLIER), epsilon)
	_test = assert_float(struct.gis_heading) \
			.is_equal_approx(deg_to_rad(struct.heading / CompCar.ANGLE_MULTIPLIER), epsilon)
	_test = assert_float(struct.gis_angular_velocity) \
			.is_equal_approx(deg_to_rad(struct.ang_vel / CompCar.ANGVEL_MULTIPLIER), epsilon)


@warning_ignore("unused_parameter")
func test_struct_to_buffer(
	buffer: PackedByteArray, node: int, lap: int, plid: int, position: int, info: int, sp3: int,
	x: int, y: int, z: int,speed: int, direction: int, heading: int, ang_vel: int,
	test_parameters := params
) -> void:
	var struct := CompCar.new()
	struct.node = node
	struct.lap = lap
	struct.plid = plid
	struct.position = position
	struct.info = info
	struct.sp3 = sp3
	struct.x = x
	struct.y = y
	struct.z = z
	struct.speed = speed
	struct.direction = direction
	struct.heading = heading
	struct.ang_vel = ang_vel
	var _test := assert_array(struct.get_buffer()).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_gis_struct_to_buffer(
	buffer: PackedByteArray, node: int, lap: int, plid: int, position: int, info: int, sp3: int,
	x: int, y: int, z: int,speed: int, direction: int, heading: int, ang_vel: int,
	test_parameters := params
) -> void:
	var struct := CompCar.new()
	struct.node = node
	struct.lap = lap
	struct.plid = plid
	struct.position = position
	struct.info = info
	struct.sp3 = sp3
	struct.gis_position = Vector3(x, y, z) \
			/ CompCar.POSITION_MULTIPLIER
	struct.gis_speed = speed / CompCar.SPEED_MULTIPLIER
	struct.gis_direction = deg_to_rad(direction / CompCar.ANGLE_MULTIPLIER)
	struct.gis_heading = deg_to_rad(heading / CompCar.ANGLE_MULTIPLIER)
	struct.gis_angular_velocity = deg_to_rad(ang_vel / CompCar.ANGVEL_MULTIPLIER)
	var _test := assert_array(struct.get_buffer(true)).is_equal(buffer)
