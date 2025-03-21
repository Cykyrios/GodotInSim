extends GutTest


func test_receivable_sendable() -> void:
	var packet := InSimBTNPacket.new()
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


var params_encode_packet := [
	[PackedByteArray([12, 45, 1, 0, 1, 0, 40, 32, 90, 100, 30, 10, 0, 94, 50, 116, 121, 112,
			101, 32, 94, 51, 105, 110, 32, 94, 52, 116, 101, 115, 116, 0, 84, 121, 112, 101,
			105, 110, 32, 94, 49, 98, 117, 116, 116, 111, 110, 0])],
	[PackedByteArray([7, 45, 1, 0, 2, 0, 40, 0, 120, 100, 30, 10, 67, 108, 105, 99, 107, 32,
			94, 49, 98, 117, 116, 116, 111, 110, 0, 0])],
]
func test_encode_packet(params: Array = use_parameters(params_encode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimBTNPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.ucid = buffer.decode_u8(3)
	packet.click_id = buffer.decode_u8(4)
	packet.inst = buffer.decode_u8(5)
	packet.button_style = buffer.decode_u8(6)
	packet.type_in = buffer.decode_u8(7)
	packet.left = buffer.decode_u8(8)
	packet.top = buffer.decode_u8(9)
	packet.width = buffer.decode_u8(10)
	packet.height = buffer.decode_u8(11)
	var text_buffer := buffer.slice(12)
	if text_buffer[0] == 0:
		var zero_idx := 1
		while zero_idx < text_buffer.size():
			if text_buffer[zero_idx] == 0:
				break
			zero_idx += 1
		packet.caption = LFSText.lfs_bytes_to_unicode(text_buffer.slice(1, zero_idx), false)
		packet.text = LFSText.lfs_bytes_to_unicode((text_buffer.slice(zero_idx + 1)))
	else:
		packet.text = LFSText.lfs_bytes_to_unicode(buffer.slice(12))
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail_test("Incorrect packet type")
		return
	assert_eq(packet.buffer, buffer)
