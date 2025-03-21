extends GutTest


func test_receivable_sendable() -> void:
	var packet := InSimCCHPacket.new()
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


var params_decode_packet := [
	[PackedByteArray([2, 29, 0, 3, 4, 0, 0, 0])],
	[PackedByteArray([2, 29, 0, 64, 255, 0, 0, 0])],
	[PackedByteArray([2, 29, 0, 3, 2, 0, 0, 0])],
	[PackedByteArray([2, 29, 0, 51, 0, 0, 0, 0])],
]
func test_decode_packet(params: Array = use_parameters(params_decode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimCCHPacket
	assert_is(packet, InSimCCHPacket)
	if is_failing():
		return
	assert_eq(packet.size, buffer.decode_u8(0) * InSimCCHPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer.decode_u8(1))
	assert_eq(packet.req_i, buffer.decode_u8(2))
	assert_eq(packet.plid, buffer.decode_u8(3))
	assert_eq(packet.camera, buffer.decode_u8(4))
	assert_eq(packet.sp1, buffer.decode_u8(5))
	assert_eq(packet.sp2, buffer.decode_u8(6))
	assert_eq(packet.sp3, buffer.decode_u8(7))
	packet.fill_buffer()
	assert_eq(packet.buffer, buffer)
