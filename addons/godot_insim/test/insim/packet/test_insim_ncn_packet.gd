extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_ncn_packet.gd"

var buffers := [
	[PackedByteArray([14, 18, 0, 4, 66, 111, 107, 117, 106, 105, 115, 104, 105, 110,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 94, 55, 67, 121, 107, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 4, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimNCNPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimNCNPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimNCNPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(3))
	_test = assert_str(packet.user_name).is_equal(
		LFSText.lfs_bytes_to_unicode(buffer.slice(4, 28))
	)
	_test = assert_str(packet.player_name).is_equal(
		LFSText.lfs_bytes_to_unicode(buffer.slice(28, 52))
	)
	_test = assert_int(packet.admin).is_equal(buffer.decode_u8(52))
	_test = assert_int(packet.total).is_equal(buffer.decode_u8(53))
	_test = assert_int(packet.flags).is_equal(buffer.decode_u8(54))
	_test = assert_int(packet.sp3).is_equal(buffer.decode_u8(55))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
