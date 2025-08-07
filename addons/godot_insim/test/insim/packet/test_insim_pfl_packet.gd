extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_pfl_packet.gd"

var buffers := [
	[PackedByteArray([2, 33, 0, 3, 1, 4, 0, 0])],
	[PackedByteArray([2, 33, 0, 3, 65, 6, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimPFLPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimPFLPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimPFLPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.flags).is_equal(buffer.decode_u16(4))
	_test = assert_int(buffer.decode_u16(6)).is_zero()
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
