extends GutTest


func test_receivable_sendable() -> void:
	var packet := InSimACRPacket.new()
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
	[PackedByteArray([4, 55, 0, 0, 0, 1, 1, 0, 47, 108, 97, 112, 115, 32, 53, 0])],
	[PackedByteArray([5, 55, 0, 0, 0, 1, 1, 0, 47, 104, 111, 117, 114, 115, 32, 50, 0, 0, 0, 0])],
]
func test_decode_packet(params: Array = use_parameters(params_decode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimACRPacket
	assert_is(packet, InSimACRPacket)
	if is_failing():
		return
	assert_eq(packet.size, buffer[0] * InSimACRPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer[1])
	assert_eq(packet.req_i, buffer[2])
	assert_eq(packet.zero, buffer[3])
	assert_eq(packet.ucid, buffer[4])
	assert_eq(packet.admin, buffer[5])
	assert_eq(packet.result, buffer[6])
	assert_eq(packet.sp3, buffer[7])
	assert_eq(packet.text, LFSText.lfs_bytes_to_unicode(buffer.slice(8)))
