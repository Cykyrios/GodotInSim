extends GutTest


func test_receivable_sendable() -> void:
	var packet := InSimAIIPacket.new()
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
	[PackedByteArray([24, 69, 1, 1, 193, 73, 162, 188, 208, 49, 134, 184, 162, 128, 49, 187, 147,
			23, 199, 191, 249, 227, 248, 59, 124, 139, 62, 186, 60, 245, 36, 185, 190, 200, 76,
			57, 56, 247, 16, 186, 253, 255, 28, 182, 213, 170, 140, 184, 181, 250, 178, 185, 48,
			98, 149, 255, 118, 255, 115, 0, 71, 82, 10, 0, 1, 1, 0, 0, 219, 67, 144, 68, 0, 0, 0,
			0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
]
func test_decode_packet(params: Array = use_parameters(params_decode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimAIIPacket
	assert_is(packet, InSimAIIPacket)
	if is_failing():
		return
	assert_eq(packet.size, buffer.decode_u8(0) * InSimAIIPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer.decode_u8(1))
	assert_eq(packet.req_i, buffer.decode_u8(2))
	assert_eq(packet.plid, buffer.decode_u8(3))
	pending("OutSimMain: buffer/gis values to be added")
	#assert_eq(packet.outsim_data, buffer.slice(4, 4 + OutSimMain.STRUCT_SIZE))
	assert_eq(packet.flags, buffer.decode_u8(OutSimMain.STRUCT_SIZE + 4))
	assert_eq(packet.gear, buffer.decode_u8(OutSimMain.STRUCT_SIZE + 5))
	assert_eq(packet.sp2, buffer.decode_u8(OutSimMain.STRUCT_SIZE + 6))
	assert_eq(packet.sp3, buffer.decode_u8(OutSimMain.STRUCT_SIZE + 7))
	assert_eq(packet.rpm, buffer.decode_float(OutSimMain.STRUCT_SIZE + 8))
	assert_eq(packet.spf0, buffer.decode_float(OutSimMain.STRUCT_SIZE + 12))
	assert_eq(packet.spf1, buffer.decode_float(OutSimMain.STRUCT_SIZE + 16))
	assert_eq(packet.show_lights, buffer.decode_u32(OutSimMain.STRUCT_SIZE + 20))
	assert_eq(packet.spu1, buffer.decode_u32(OutSimMain.STRUCT_SIZE + 24))
	assert_eq(packet.spu2, buffer.decode_u32(OutSimMain.STRUCT_SIZE + 28))
	assert_eq(packet.spu3, buffer.decode_u32(OutSimMain.STRUCT_SIZE + 32))
	assert_eq(packet.buffer, buffer)
