extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_aic_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([1, 68, 0, 1])],
	[PackedByteArray([2, 68, 0, 1, 0, 1, 1, 0])],
	[PackedByteArray([3, 68, 0, 1, 0, 1, 1, 0, 47, 104, 111, 117])],
	[PackedByteArray([4, 68, 0, 1, 3, 10, 1, 0, 9, 10, 1, 0, 13, 10, 3, 0])],
]) -> void:
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
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
