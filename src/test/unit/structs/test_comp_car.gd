extends GutTest


var args: Array[Array] = [
	[378, 1, 34, 1, 192, 0, -1734651, 16728913, 10448, 11118, 62087, 62581, 1660],
]
var bytes: Array[PackedByteArray] = [
	PackedByteArray([122, 1, 1, 0, 34, 1, 192, 0, 5, 136, 229, 255, 81, 67, 255, 0,
				208, 40, 0, 0, 110, 43, 135, 242, 117, 244, 124, 6]),
]
var epsilon := 1e-5

var params_buffer_to_struct := [
	[bytes[0], args[0]],
]
func test_buffer_to_struct(params: Array = use_parameters(params_buffer_to_struct)) -> void:
	var buffer := params[0] as PackedByteArray
	var struct := CompCar.new()
	struct.set_from_buffer(buffer)
	assert_eq(struct.node, params[1][0] as int)
	assert_eq(struct.lap, params[1][1] as int)
	assert_eq(struct.plid, params[1][2] as int)
	assert_eq(struct.position, params[1][3] as int)
	assert_eq(struct.info, params[1][4] as int)
	assert_eq(struct.sp3, params[1][5] as int)
	assert_eq(struct.x, params[1][6] as int)
	assert_eq(struct.y, params[1][7] as int)
	assert_eq(struct.z, params[1][8] as int)
	assert_eq(struct.speed, params[1][9] as int)
	assert_eq(struct.direction, params[1][10] as int)
	assert_eq(struct.heading, params[1][11] as int)
	assert_eq(struct.ang_vel, params[1][12] as int)
	assert_almost_eq(struct.gis_position, Vector3(struct.x, struct.y, struct.z) \
			/ CompCar.POSITION_MULTIPLIER, epsilon * Vector3.ONE)
	assert_almost_eq(struct.gis_speed, struct.speed / CompCar.SPEED_MULTIPLIER, epsilon)
	assert_almost_eq(struct.gis_direction,
			deg_to_rad(struct.direction / CompCar.ANGLE_MULTIPLIER), epsilon)
	assert_almost_eq(struct.gis_heading,
			deg_to_rad(struct.heading / CompCar.ANGLE_MULTIPLIER), epsilon)
	assert_almost_eq(struct.gis_angular_velocity,
			deg_to_rad(struct.ang_vel / CompCar.ANGVEL_MULTIPLIER), epsilon)


var params_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := CompCar.new()
	struct.node = params[0][0] as int
	struct.lap = params[0][1] as int
	struct.plid = params[0][2] as int
	struct.position = params[0][3] as int
	struct.info = params[0][4] as int
	struct.sp3 = params[0][5] as int
	struct.x = params[0][6] as int
	struct.y = params[0][7] as int
	struct.z = params[0][8] as int
	struct.speed = params[0][9] as int
	struct.direction = params[0][10] as int
	struct.heading = params[0][11] as int
	struct.ang_vel = params[0][12] as int
	assert_eq(struct.get_buffer(), params[1] as PackedByteArray)


var params_gis_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_gis_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := CompCar.new()
	struct.node = params[0][0] as int
	struct.lap = params[0][1] as int
	struct.plid = params[0][2] as int
	struct.position = params[0][3] as int
	struct.info = params[0][4] as int
	struct.sp3 = params[0][5] as int
	struct.gis_position = Vector3(params[0][6] as int, params[0][7] as int, params[0][8] as int) \
			/ CompCar.POSITION_MULTIPLIER
	struct.gis_speed = params[0][9] as float / CompCar.SPEED_MULTIPLIER
	struct.gis_direction = deg_to_rad(params[0][10] as float / CompCar.ANGLE_MULTIPLIER)
	struct.gis_heading = deg_to_rad(params[0][11] as float / CompCar.ANGLE_MULTIPLIER)
	struct.gis_angular_velocity = deg_to_rad(params[0][12] as float / CompCar.ANGVEL_MULTIPLIER)
	assert_eq(struct.get_buffer(true), params[1] as PackedByteArray)
