extends GutTest


var epsilon := 1e-5

var buffers := [
	[PackedByteArray([5, 63, 0, 3, 0, 1, 0, 0, 36, 2, 0, 0, 0, 193, 1, 42, 92, 249, 64, 7])],
	[PackedByteArray([5, 63, 0, 3, 0, 0, 0, 0, 148, 3, 0, 0, 0, 252, 1, 42, 27, 250, 19, 8])],
	[PackedByteArray([5, 63, 0, 1, 0, 0, 0, 0, 228, 15, 0, 0, 0, 254, 1, 42, 129, 250, 12, 8])],
]


func test_receivable_sendable() -> void:
	var packet := InSimCSCPacket.new()
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
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimCSCPacket
	assert_is(packet, InSimCSCPacket)
	if is_failing():
		return
	assert_eq(packet.size, buffer.decode_u8(0) * InSimCSCPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer.decode_u8(1))
	assert_eq(packet.req_i, buffer.decode_u8(2))
	assert_eq(packet.plid, buffer.decode_u8(3))
	assert_eq(packet.sp0, buffer.decode_u8(4))
	assert_eq(packet.csc_action, buffer.decode_u8(5))
	assert_eq(packet.sp2, buffer.decode_u8(6))
	assert_eq(packet.sp3, buffer.decode_u8(7))
	assert_eq(packet.time, buffer.decode_u32(8))
	assert_almost_eq(packet.gis_time, buffer.decode_u32(8) / InSimCSCPacket.TIME_MULTIPLIER,
			epsilon)
	assert_eq(packet.object.get_buffer(), buffer.slice(12))
	packet.fill_buffer()
	assert_eq(packet.buffer, buffer)
