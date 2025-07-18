extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/struct/car_contact.gd"

var params := [
	[
		PackedByteArray([1, 0, 0, 5, 3, 0, 16, 21, 232, 230, 253, 13, 32, 2, 196, 36]),
		1, 0, 0, 5, 3, 0, 16, 21, 232, 230, -3, 13, 544, 9412,
	],
	[
		PackedByteArray([15, 0, 0, 5, 16, 0, 16, 23, 18, 17, 0, 14, 228, 209, 74, 5]),
		15, 0, 0, 5, 16, 0, 16, 23, 18, 17, 0, 14, -11804, 1354,
	],
]
var epsilon := 1e-5

@warning_ignore("unused_parameter")
func test_buffer_to_struct(
	buffer: PackedByteArray, plid: int, info: int, sp2: int, steer: int, throttle_brake: int,
	clutch_handbrake: int, gear_spare: int, speed: int, direction: int, heading: int,
	accel_forward: int, accel_right: int, x: int, y: int, test_parameters := params
) -> void:
	var struct := CarContact.new()
	struct.set_from_buffer(buffer)
	var _test: GdUnitAssert = assert_int(struct.plid).is_equal(plid)
	_test = assert_int(struct.info).is_equal(info)
	_test = assert_int(struct.sp2).is_equal(sp2)
	_test = assert_int(struct.steer).is_equal(steer)
	_test = assert_int(struct.throttle_brake).is_equal(throttle_brake)
	_test = assert_int(struct.clutch_handbrake).is_equal(clutch_handbrake)
	_test = assert_int(struct.gear).is_equal(gear_spare >> 4)
	_test = assert_int(struct.spare).is_equal(gear_spare & 0b1111)
	_test = assert_int(struct.speed).is_equal(speed)
	_test = assert_int(struct.direction).is_equal(direction)
	_test = assert_int(struct.heading).is_equal(heading)
	_test = assert_int(struct.accel_forward).is_equal(accel_forward)
	_test = assert_int(struct.accel_right).is_equal(accel_right)
	_test = assert_int(struct.x).is_equal(x)
	_test = assert_int(struct.y).is_equal(y)
	_test = assert_vector(struct.gis_position).is_equal_approx(
		Vector2(struct.x, struct.y) / CarContact.POSITION_MULTIPLIER, epsilon * Vector2.ONE
	)
	_test = assert_float(struct.gis_speed).is_equal_approx(
		struct.speed / CarContact.SPEED_MULTIPLIER, epsilon
	)
	_test = assert_float(struct.gis_direction).is_equal_approx(
		struct.direction / CarContact.ANGLE_MULTIPLIER, epsilon
	)
	_test = assert_vector(struct.gis_acceleration).is_equal_approx(
		Vector2(struct.accel_right, struct.accel_forward) / CarContact.SPEED_MULTIPLIER,
		epsilon * Vector2.ONE,
	)
	_test = assert_float(struct.gis_heading).is_equal_approx(
		struct.heading / CarContact.ANGLE_MULTIPLIER, epsilon
	)
	_test = assert_float(struct.gis_steer).is_equal_approx(
		struct.steer / CarContact.STEER_MULTIPLIER, epsilon
	)


@warning_ignore("unused_parameter")
func test_struct_to_buffer(
	buffer: PackedByteArray, plid: int, info: int, sp2: int, steer: int, throttle_brake: int,
	clutch_handbrake: int, gear_spare: int, speed: int, direction: int, heading: int,
	accel_forward: int, accel_right: int, x: int, y: int, test_parameters := params
) -> void:
	var struct := CarContact.new()
	struct.plid = plid
	struct.info = info
	struct.sp2 = sp2
	struct.steer = steer
	struct.throttle_brake = throttle_brake
	struct.clutch_handbrake = clutch_handbrake
	struct.gear = gear_spare >> 4
	struct.spare = gear_spare & 0b1111
	struct.speed = speed
	struct.direction = direction
	struct.heading = heading
	struct.accel_forward = accel_forward
	struct.accel_right = accel_right
	struct.x = x
	struct.y = y
	var _test := assert_array(struct.get_buffer()).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_gis_struct_to_buffer(
	buffer: PackedByteArray, plid: int, info: int, sp2: int, steer: int, throttle_brake: int,
	clutch_handbrake: int, gear_spare: int, speed: int, direction: int, heading: int,
	accel_forward: int, accel_right: int, x: int, y: int, test_parameters := params
) -> void:
	var struct := CarContact.new()
	struct.plid = plid
	struct.info = info
	struct.sp2 = sp2
	struct.gis_steer = steer / CarContact.STEER_MULTIPLIER
	struct.throttle_brake = throttle_brake
	struct.clutch_handbrake = clutch_handbrake
	struct.gear = gear_spare >> 4
	struct.spare = gear_spare & 0b1111
	struct.gis_speed = speed / CarContact.SPEED_MULTIPLIER
	struct.gis_direction = direction / CarContact.ANGLE_MULTIPLIER
	struct.gis_heading = heading / CarContact.ANGLE_MULTIPLIER
	struct.gis_acceleration = (
		Vector2(accel_right, accel_forward) / CarContact.ACCELERATION_MULTIPLIER
	)
	struct.gis_position = Vector2(x, y) / CarContact.POSITION_MULTIPLIER
	var _test := assert_array(struct.get_buffer(true)).is_equal(buffer)
