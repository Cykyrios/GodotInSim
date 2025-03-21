extends GutTest


func test_receivable_sendable() -> void:
	var packet := InSimBFNPacket.new()
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
	[PackedByteArray([2, 42, 0, 2, 0, 0, 0, 0])],
	[PackedByteArray([2, 42, 0, 3, 0, 0, 0, 0])],
]
func test_decode_packet(params: Array = use_parameters(params_decode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimBFNPacket
	assert_is(packet, InSimBFNPacket)
	if is_failing():
		return
	assert_eq(packet.size, buffer.decode_u8(0) * InSimBFNPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer.decode_u8(1))
	assert_eq(packet.req_i, buffer.decode_u8(2))
	assert_eq(packet.subtype, buffer.decode_u8(3))
	assert_eq(packet.ucid, buffer.decode_u8(4))
	assert_eq(packet.click_id, buffer.decode_u8(5))
	assert_eq(packet.click_max, buffer.decode_u8(6))
	assert_eq(packet.inst, buffer.decode_u8(7))
	assert_eq(packet.buffer, buffer)


var params_encode_packet := [
	[PackedByteArray([2, 42, 0, 0, 0, 2, 5, 0])],
	[PackedByteArray([2, 42, 0, 1, 0, 0, 0, 0])],
]
func test_encode_packet(params: Array = use_parameters(params_encode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimBFNPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.subtype = buffer.decode_u8(3) as InSim.ButtonFunction
	packet.ucid = buffer.decode_u8(4)
	packet.click_id = buffer.decode_u8(5)
	packet.click_max = buffer.decode_u8(6)
	packet.inst = buffer.decode_u8(7)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail_test("Incorrect packet type")
		return
	assert_eq(packet.buffer, buffer)
