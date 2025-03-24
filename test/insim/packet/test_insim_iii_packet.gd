extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_iii_packet.gd"

var buffers := [
	[PackedByteArray([10, 12, 0, 0, 0, 1, 0, 0, 84, 101, 115, 116, 105, 110, 103, 32,
			73, 83, 95, 73, 73, 73, 32, 112, 97, 99, 107, 101, 116, 32, 109, 101, 115,
			115, 97, 103, 101, 115, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimIIIPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimIIIPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimIIIPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.zero).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.sp2).is_equal(buffer.decode_u8(6))
	_test = assert_int(packet.sp3).is_equal(buffer.decode_u8(7))
	_test = assert_str(packet.msg).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(8)))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
