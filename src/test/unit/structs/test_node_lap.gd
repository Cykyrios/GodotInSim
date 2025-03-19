extends GutTest


var args: Array[Array] = [
	[378, 1, 34, 1],
]
var bytes: Array[PackedByteArray] = [
	PackedByteArray([122, 1, 1, 0, 34, 1]),
]

var params_buffer_to_struct := [
	[bytes[0], args[0]],
]
func test_buffer_to_struct(params: Array = use_parameters(params_buffer_to_struct)) -> void:
	var buffer := params[0] as PackedByteArray
	var struct := NodeLap.new()
	struct.set_from_buffer(buffer)
	assert_eq(struct.node, params[1][0] as int)
	assert_eq(struct.lap, params[1][1] as int)
	assert_eq(struct.plid, params[1][2] as int)
	assert_eq(struct.position, params[1][3] as int)


var params_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := NodeLap.new()
	struct.node = params[0][0] as int
	struct.lap = params[0][1] as int
	struct.plid = params[0][2] as int
	struct.position = params[0][3] as int
	assert_eq(struct.get_buffer(), params[1] as PackedByteArray)
