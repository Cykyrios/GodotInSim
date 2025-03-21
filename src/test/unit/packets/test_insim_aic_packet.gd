extends GutTest


func test_receivable_sendable() -> void:
	var packet := InSimAICPacket.new()
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
	[PackedByteArray([1, 68, 0, 1])],
	[PackedByteArray([2, 68, 0, 1, 0, 1, 1, 0])],
	[PackedByteArray([3, 68, 0, 1, 0, 1, 1, 0, 47, 104, 111, 117])],
	[PackedByteArray([4, 68, 0, 1, 3, 10, 1, 0, 9, 10, 1, 0, 13, 10, 3, 0])],
]
func test_encode_packet(params: Array = use_parameters(params_encode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimAICPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.plid = buffer.decode_u8(3)
	var inputs_buffer := buffer.slice(4)
	for i in int(inputs_buffer.size() as float / AIInputVal.STRUCT_SIZE):
		var offset := AIInputVal.STRUCT_SIZE * i
		packet.inputs.append(AIInputVal.create(
			inputs_buffer.decode_u8(offset),
			inputs_buffer.decode_u8(offset + 1),
			inputs_buffer.decode_u16(offset + 2)
		))
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail_test("Incorrect packet type")
		return
	assert_eq(packet.buffer, buffer)
