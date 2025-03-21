extends GutTest


func test_receivable_sendable() -> void:
	var packet := InSimCPRPacket.new()
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
	[PackedByteArray([9, 20, 0, 0, 94, 52, 52, 50, 32, 94, 55, 67, 121, 107, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 52, 50, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([9, 20, 0, 0, 94, 55, 67, 121, 107, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 67, 121, 107, 0, 67, 89, 75, 75])],
]
func test_decode_packet(params: Array = use_parameters(params_decode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimCPRPacket
	assert_is(packet, InSimCPRPacket)
	if is_failing():
		return
	assert_eq(packet.size, buffer.decode_u8(0) * InSimCPRPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer.decode_u8(1))
	assert_eq(packet.req_i, buffer.decode_u8(2))
	assert_eq(packet.ucid, buffer.decode_u8(3))
	assert_eq(packet.player_name, LFSText.lfs_bytes_to_unicode(
			buffer.slice(4, 4 + InSimCPRPacket.PLAYER_NAME_MAX_LENGTH)))
	assert_eq(packet.plate, LFSText.lfs_bytes_to_unicode(
			buffer.slice(4 + InSimCPRPacket.PLAYER_NAME_MAX_LENGTH)))
	packet.fill_buffer()
	assert_eq(packet.buffer, buffer)
