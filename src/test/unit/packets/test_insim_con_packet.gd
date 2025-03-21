extends GutTest


var epsilon := 1e-5


func test_receivable_sendable() -> void:
	var packet := InSimCONPacket.new()
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
	[PackedByteArray([10, 50, 0, 0, 9, 0, 106, 16, 1, 0, 0, 255, 240, 0, 48, 40, 245, 246, 2,
			251, 158, 255, 242, 24, 3, 0, 0, 255, 240, 0, 64, 41, 244, 245, 2, 251, 147, 255,
			178, 24])],
	[PackedByteArray([10, 50, 0, 0, 65, 0, 254, 38, 1, 0, 0, 220, 0, 48, 16, 17, 130, 53, 3,
			6, 159, 27, 131, 205, 3, 0, 0, 6, 0, 0, 80, 1, 37, 124, 0, 252, 206, 27, 87, 205])],
	[PackedByteArray([10, 50, 0, 0, 76, 0, 36, 63, 15, 0, 0, 5, 16, 0, 16, 23, 18, 17, 0, 14,
			228, 209, 74, 5, 67, 0, 0, 5, 11, 0, 16, 31, 19, 17, 243, 9, 4, 210, 6, 5])],
]
func test_decode_packet(params: Array = use_parameters(params_decode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimCONPacket
	assert_is(packet, InSimCONPacket)
	if is_failing():
		return
	assert_eq(packet.size, buffer.decode_u8(0) * InSimCONPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer.decode_u8(1))
	assert_eq(packet.req_i, buffer.decode_u8(2))
	assert_eq(packet.zero, buffer.decode_u8(3))
	assert_eq(packet.sp_close, buffer.decode_u16(4))
	assert_almost_eq(
		packet.gis_closing_speed,
		packet.sp_close / InSimCONPacket.CLOSING_SPEED_MULTIPLIER,
		epsilon)
	assert_eq(packet.time, buffer.decode_u16(6))
	assert_almost_eq(
		packet.gis_time,
		packet.time / InSimCONPacket.TIME_MULTIPLIER,
		epsilon)
	assert_eq(packet.car_a.get_buffer(), buffer.slice(8, 8 + CarContact.STRUCT_SIZE))
	assert_eq(packet.car_b.get_buffer(), buffer.slice(8 + CarContact.STRUCT_SIZE))
	packet.fill_buffer()
	assert_eq(packet.buffer, buffer)
