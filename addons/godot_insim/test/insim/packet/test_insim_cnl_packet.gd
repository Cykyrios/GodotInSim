extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_cnl_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([2, 19, 0, 35, 0, 22, 0, 0])],
	[PackedByteArray([2, 19, 0, 31, 1, 23, 0, 0])],
]) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimCNLPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimCNLPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimCNLPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.reason).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.total).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.sp2).is_equal(buffer.decode_u8(6))
	_test = assert_int(packet.sp3).is_equal(buffer.decode_u8(7))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
