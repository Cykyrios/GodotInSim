extends GutTest


var args: Array[Array] = [
	[1, 0, 5, 3, 0, 16, 21, 232, 230, 253, 13, 544, 9412],
]
var bytes: Array[PackedByteArray] = [
	PackedByteArray([1, 0, 0, 5, 3, 0, 16, 21, 232, 230, 253, 13, 32, 2, 196, 36]),
]
var epsilon := 1e-5

var params_buffer_to_struct := [
	[bytes[0], args[0]],
]
func test_buffer_to_struct(params: Array = use_parameters(params_buffer_to_struct)) -> void:
	var buffer := params[0] as PackedByteArray
	var struct := CarContact.new()
	struct.set_from_buffer(buffer)
	assert_eq(struct.plid, params[1][0] as int)
	assert_eq(struct.info, params[1][1] as int)
	assert_eq(struct.steer, params[1][2] as int)
	assert_eq(struct.throttle_brake, params[1][3] as int)
	assert_eq(struct.clutch_handbrake, params[1][4] as int)
	assert_eq(struct.gear_spare, params[1][5] as int)
	assert_eq(struct.speed, params[1][6] as int)
	assert_eq(struct.direction, params[1][7] as int)
	assert_eq(struct.heading, params[1][8] as int)
	assert_eq(struct.accel_forward, params[1][9] as int)
	assert_eq(struct.accel_right, params[1][10] as int)
	assert_eq(struct.x, params[1][11] as int)
	assert_eq(struct.y, params[1][12] as int)
	assert_almost_eq(struct.gis_position,
			Vector2(struct.x, struct.y) / CarContact.POSITION_MULTIPLIER, epsilon * Vector2.ONE)
	assert_almost_eq(struct.gis_speed, struct.speed / CarContact.SPEED_MULTIPLIER, epsilon)
	assert_almost_eq(struct.gis_direction, struct.direction / CarContact.ANGLE_MULTIPLIER, epsilon)
	assert_almost_eq(struct.gis_acceleration, Vector2(struct.accel_right, struct.accel_forward) \
			/ CarContact.SPEED_MULTIPLIER, epsilon * Vector2.ONE)
	assert_almost_eq(struct.gis_heading, struct.heading / CarContact.ANGLE_MULTIPLIER, epsilon)
	assert_almost_eq(struct.gis_steer, struct.steer / CarContact.STEER_MULTIPLIER, epsilon)


var params_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := CarContact.new()
	struct.plid = params[0][0] as int
	struct.info = params[0][1] as int
	struct.steer = params[0][2] as int
	struct.throttle_brake = params[0][3] as int
	struct.clutch_handbrake = params[0][4] as int
	struct.gear_spare = params[0][5] as int
	struct.speed = params[0][6] as int
	struct.direction = params[0][7] as int
	struct.heading = params[0][8] as int
	struct.accel_forward = params[0][9] as int
	struct.accel_right = params[0][10] as int
	struct.x = params[0][11] as int
	struct.y = params[0][12] as int
	assert_eq(struct.get_buffer(), params[1] as PackedByteArray)


var params_gis_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_gis_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := CarContact.new()
	struct.plid = params[0][0] as int
	struct.info = params[0][1] as int
	struct.gis_steer = params[0][2] as float / CarContact.STEER_MULTIPLIER
	struct.throttle_brake = params[0][3] as int
	struct.clutch_handbrake = params[0][4] as int
	struct.gear_spare = params[0][5] as int
	struct.gis_speed = params[0][6] as float / CarContact.SPEED_MULTIPLIER
	struct.gis_direction = params[0][7] as float / CarContact.ANGLE_MULTIPLIER
	struct.gis_heading = params[0][8] as float / CarContact.ANGLE_MULTIPLIER
	# gis_acceleration = Vector2(acceleration_right, acceleration_forward)
	struct.gis_acceleration = Vector2(params[0][10] as int, params[0][9] as int) \
			/ CarContact.ACCELERATION_MULTIPLIER
	struct.gis_position = Vector2(params[0][11] as int, params[0][12] as int) \
			/ CarContact.POSITION_MULTIPLIER
	assert_eq(struct.get_buffer(true), params[1] as PackedByteArray)
