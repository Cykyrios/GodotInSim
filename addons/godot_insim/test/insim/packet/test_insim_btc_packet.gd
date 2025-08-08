extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_btc_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([2, 46, 1, 0, 2, 8, 1, 0])],
	[PackedByteArray([2, 46, 1, 0, 192, 8, 13, 0])],
]) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimBTCPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimBTCPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * packet.size_multiplier)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.click_id).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.inst).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.click_flags).is_equal(buffer.decode_u8(6))
	_test = assert_int(buffer.decode_u8(7)).is_zero()
	_test = assert_array(packet.buffer).is_equal(buffer)
