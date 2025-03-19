extends GutTest


var args: Array[Array] = [
	[1, 3, 55, 30],
]
var bytes: Array[PackedByteArray] = [
	PackedByteArray([1, 3, 55, 30]),
]
var epsilon := 1e-5

var params_buffer_to_struct := [
	[bytes[0], args[0]],
]
func test_buffer_to_struct(params: Array = use_parameters(params_buffer_to_struct)) -> void:
	var buffer := params[0] as PackedByteArray
	var struct := PlayerHandicap.new()
	struct.set_from_buffer(buffer)
	assert_eq(struct.plid, params[1][0] as int)
	assert_eq(struct.flags, params[1][1] as int)
	assert_eq(struct.h_mass, params[1][2] as int)
	assert_eq(struct.h_tres, params[1][3] as int)
	assert_almost_eq(struct.gis_mass, struct.h_mass / PlayerHandicap.MASS_MULTIPLIER, epsilon)


var params_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := PlayerHandicap.create(
		params[0][0] as int,
		params[0][1] as int,
		params[0][2] as int,
		params[0][3] as int
	)
	assert_eq(struct.get_buffer(), params[1] as PackedByteArray)


var params_gis_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_gis_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := PlayerHandicap.create_from_gis_values(
		params[0][0] as int,
		params[0][1] as int,
		params[0][2] as float / PlayerHandicap.MASS_MULTIPLIER,
		params[0][3] as int
	)
	assert_eq(struct.get_buffer(true), params[1] as PackedByteArray)
