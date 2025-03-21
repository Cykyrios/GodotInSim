extends GutTest


func test_receivable_sendable() -> void:
	var packet := InSimAXIPacket.new()
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
	[PackedByteArray([10, 43, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([10, 43, 0, 0, 0, 3, 8, 0, 66, 76, 49, 95, 116, 101, 115, 116, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([10, 43, 0, 0, 0, 2, 83, 11, 76, 65, 50, 88, 95, 66, 66, 66, 32, 82,
			105, 110, 103, 32, 86, 101, 114, 32, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
]
func test_decode_packet(params: Array = use_parameters(params_decode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimAXIPacket
	assert_is(packet, InSimAXIPacket)
	if is_failing():
		return
	assert_eq(packet.size, buffer.decode_u8(0) * InSimAXIPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer.decode_u8(1))
	assert_eq(packet.req_i, buffer.decode_u8(2))
	assert_eq(packet.zero, buffer.decode_u8(3))
	assert_eq(packet.ax_start, buffer.decode_u8(4))
	assert_eq(packet.num_checkpoints, buffer.decode_u8(5))
	assert_eq(packet.num_objects, buffer.decode_u16(6))
	assert_eq(packet.layout_name, LFSText.lfs_bytes_to_unicode(buffer.slice(8)))
	assert_eq(packet.buffer, buffer)
