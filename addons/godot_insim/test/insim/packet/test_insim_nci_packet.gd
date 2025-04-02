extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_nci_packet.gd"

var buffers := [
	[PackedByteArray([4, 57, 0, 4, 0, 3, 0, 0, 110, 10, 6, 0, 11, 22, 33, 44])],
	[PackedByteArray([4, 57, 0, 1, 3, 0, 0, 0, 64, 226, 1, 0, 11, 22, 33, 44])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimNCIPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimNCIPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimNCIPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.language).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.license).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.sp2).is_equal(buffer.decode_u8(6))
	_test = assert_int(packet.sp3).is_equal(buffer.decode_u8(7))
	_test = assert_int(packet.user_id).is_equal(buffer.decode_u32(8))
	_test = assert_int(packet.ip_address.address_int).is_equal(buffer.decode_u32(12))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
