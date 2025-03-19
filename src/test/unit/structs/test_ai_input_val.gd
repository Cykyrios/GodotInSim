extends GutTest


var args: Array[Array] = [
	[InSim.AIControl.CS_THROTTLE, 10, 32768],
]
var bytes: Array[PackedByteArray] = [
	PackedByteArray([1, 10, 0, 128]),
]

var params_buffer_to_struct := [
	[bytes[0], args[0]],
]
func test_buffer_to_struct(params: Array = use_parameters(params_buffer_to_struct)) -> void:
	var buffer := params[0] as PackedByteArray
	var struct := AIInputVal.new()
	struct.set_from_buffer(buffer)
	assert_eq(struct.input, params[1][0] as InSim.AIControl)
	assert_eq(struct.time, params[1][1] as int)
	assert_eq(struct.gis_time, params[1][1] as int / AIInputVal.TIME_MULTIPLIER)
	assert_eq(struct.value, params[1][2] as int)


var params_struct_to_buffer := [
	[args[0], bytes[0]],
]
func test_struct_to_buffer(params: Array = use_parameters(params_struct_to_buffer)) -> void:
	var struct := AIInputVal.new()
	struct.input = params[0][0] as InSim.AIControl
	struct.time = params[0][1] as int
	struct.value = params[0][2] as int
	assert_eq(struct.get_buffer(), params[1] as PackedByteArray)
