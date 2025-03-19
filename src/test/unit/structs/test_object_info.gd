extends GutTest


var args: Array[Array] = [
	[-229, 4811, 0, 40, 253, 4],
]
var bytes: Array[PackedByteArray] = [
	PackedByteArray([27, 255, 203, 18, 0, 40, 253, 4]),
]
var epsilon := 1e-5

var params_buffer_to_struct := [
	[bytes[0], args[0]],
]
func test_buffer_to_struct(params: Array = use_parameters(params_buffer_to_struct)) -> void:
	var buffer := params[0] as PackedByteArray
	var struct := ObjectInfo.new()
	struct.set_from_buffer(buffer)
	assert_eq(struct.x, params[1][0] as int)
	assert_eq(struct.y, params[1][1] as int)
	assert_eq(struct.z, params[1][2] as int)
	assert_eq(struct.flags, params[1][3] as int)
	assert_eq(struct.index, params[1][4] as int)
	assert_eq(struct.heading, params[1][5] as int)
	assert_almost_eq(struct.gis_position, Vector3(
		struct.x / ObjectInfo.POSITION_MULTIPLIER,
		struct.y / ObjectInfo.POSITION_MULTIPLIER,
		struct.z / ObjectInfo.Z_MULTIPLIER
	), epsilon * Vector3.ONE)
	assert_almost_eq(struct.gis_heading,
			deg_to_rad(struct.heading / ObjectInfo.ANGLE_MULTIPLIER - 180), epsilon)


var params_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := ObjectInfo.new()
	struct.x = params[0][0] as int
	struct.y = params[0][1] as int
	struct.z = params[0][2] as int
	struct.flags = params[0][3] as int
	struct.index = params[0][4] as int
	struct.heading = params[0][5] as int
	assert_eq(struct.get_buffer(), params[1] as PackedByteArray)


var params_gis_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_gis_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := ObjectInfo.new()
	struct.flags = params[0][3] as int
	struct.index = params[0][4] as int
	struct.gis_position = Vector3(params[0][0] as int, params[0][1] as int, params[0][2] as int) \
			/ ObjectInfo.POSITION_MULTIPLIER
	struct.gis_heading = deg_to_rad(params[0][5] as float / ObjectInfo.ANGLE_MULTIPLIER - 180)
	assert_eq(struct.get_buffer(true), params[1] as PackedByteArray)
