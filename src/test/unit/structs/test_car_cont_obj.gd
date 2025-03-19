extends GutTest


var args: Array[Array] = [
	[0, 225, 22, 56, 490, 9683],
]
var bytes: Array[PackedByteArray] = [
	PackedByteArray([0, 225, 22, 56, 234, 1, 211, 37]),
]
var epsilon := 1e-5

var params_buffer_to_struct := [
	[bytes[0], args[0]],
]
func test_buffer_to_struct(params: Array = use_parameters(params_buffer_to_struct)) -> void:
	var buffer := params[0] as PackedByteArray
	var struct := CarContObj.new()
	struct.set_from_buffer(buffer)
	assert_eq(struct.direction, params[1][0] as int)
	assert_eq(struct.heading, params[1][1] as int)
	assert_eq(struct.speed, params[1][2] as int)
	assert_eq(struct.z, params[1][3] as int)
	assert_eq(struct.x, params[1][4] as int)
	assert_eq(struct.y, params[1][5] as int)
	assert_almost_eq(struct.gis_direction, struct.direction / CarContObj.ANGLE_MULTIPLIER, epsilon)
	assert_almost_eq(struct.gis_heading, struct.heading / CarContObj.ANGLE_MULTIPLIER, epsilon)
	assert_almost_eq(struct.gis_speed, struct.speed / CarContObj.SPEED_MULTIPLIER, epsilon)
	assert_almost_eq(struct.gis_position, Vector3(
		struct.x / CarContObj.POSITION_MULTIPLIER,
		struct.y / CarContObj.POSITION_MULTIPLIER,
		struct.z / CarContObj.Z_MULTIPLIER
	), epsilon * Vector3.ONE)


var params_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := CarContObj.new()
	struct.direction = params[0][0] as int
	struct.heading = params[0][1] as int
	struct.speed = params[0][2] as int
	struct.z = params[0][3] as int
	struct.x = params[0][4] as int
	struct.y = params[0][5] as int
	assert_eq(struct.get_buffer(), params[1] as PackedByteArray)


var params_gis_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_gis_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := CarContObj.new()
	struct.gis_direction = params[0][0] as float / CarContObj.ANGLE_MULTIPLIER
	struct.gis_heading = params[0][1] as float / CarContObj.ANGLE_MULTIPLIER
	struct.gis_speed = params[0][2] as float / CarContObj.SPEED_MULTIPLIER
	struct.gis_position = Vector3(
		params[0][4] as int / CarContObj.POSITION_MULTIPLIER,
		params[0][5] as int / CarContObj.POSITION_MULTIPLIER,
		params[0][3] as int / CarContObj.Z_MULTIPLIER
	)
	assert_eq(struct.get_buffer(true), params[1] as PackedByteArray)
