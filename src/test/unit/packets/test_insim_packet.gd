extends GutTest


var params_decode_header := [
	[PackedByteArray([5, 2, 1, 0])],
	[PackedByteArray([20, 50, 9, 42])],
]
func test_decode_header(params: Array = use_parameters(params_decode_header)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.new()
	packet.buffer = buffer
	packet.decode_header(buffer)
	assert_eq(packet.size, buffer[0] * InSimPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer[1])
	assert_eq(packet.req_i, buffer[2])


var params_decode_packet := [
	[PackedByteArray([5, 2, 1, 0, 48, 46, 55, 70, 0, 0, 0, 0, 83, 51, 0, 0, 0, 0, 9, 0])],
	[PackedByteArray([10, 50, 0, 0, 102, 0, 151, 4, 1, 0, 0, 254, 240, 112, 16, 9, 249, 249, 3,
			255, 227, 251, 64, 7, 34, 0, 0, 220, 240, 0, 16, 8, 50, 40, 1, 243, 6, 252, 93, 7])],
]
func test_decode_packet(params: Array = use_parameters(params_decode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.create_packet_from_buffer(buffer)
	assert_eq(packet.size, buffer[0] * InSimPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer[1])
	assert_eq(packet.req_i, buffer[2])
	assert_eq(packet.buffer, buffer)


var params_encode_packet := [
	[PackedByteArray([5, 2, 1, 0, 48, 46, 55, 70, 0, 0, 0, 0, 83, 51, 0, 0, 0, 0, 9, 0])],
	[PackedByteArray([10, 50, 0, 0, 102, 0, 151, 4, 1, 0, 0, 254, 240, 112, 16, 9, 249, 249, 3,
			255, 227, 251, 64, 7, 34, 0, 0, 220, 240, 0, 16, 8, 50, 40, 1, 243, 6, 252, 93, 7])],
]
func test_encode_packet(params: Array = use_parameters(params_encode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.create_packet_from_buffer(buffer)
	assert_eq(packet.buffer, buffer)
