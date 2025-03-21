extends GutTest


var epsilon := 1e-5

var buffers := [
	[PackedByteArray([1, 41, 0, 1])],
	[PackedByteArray([1, 41, 0, 3])],
]


func test_receivable_sendable() -> void:
	var packet := InSimCRSPacket.new()
	if packet.receivable:
		assert_true(has_method("test_decode_packet"),
			"Receivable packet has test_decode_packet test")
	else:
		assert_false(has_method("test_decode_packet"),
			"Non-receivable packet does not have test_decode_packet test")
	if packet.sendable:
		assert_true(has_method("test_encode_packet"),
			"Sendable packet has test_encode_packet test")
	else:
		assert_false(has_method("test_encode_packet"),
			"Non-sendable packet does not have test_encode_packet test")


var params_decode_packet := buffers
func test_decode_packet(params: Array = use_parameters(params_decode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimCRSPacket
	assert_is(packet, InSimCRSPacket)
	if is_failing():
		return
	assert_eq(packet.size, buffer.decode_u8(0) * InSimCRSPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer.decode_u8(1))
	assert_eq(packet.req_i, buffer.decode_u8(2))
	assert_eq(packet.plid, buffer.decode_u8(3))
	packet.fill_buffer()
	assert_eq(packet.buffer, buffer)
