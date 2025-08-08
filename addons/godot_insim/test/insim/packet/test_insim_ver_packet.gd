extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_ver_packet.gd"

var buffers := [
	[PackedByteArray([5, 2, 1, 0, 48, 46, 55, 70, 0, 0, 0, 0, 83, 51, 0, 0, 0, 0, 9, 0])],
	[PackedByteArray([5, 2, 1, 0, 48, 46, 54, 72, 0, 0, 0, 0, 68, 69, 77, 79, 0, 0, 8, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimVERPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimVERPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * packet.size_multiplier)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(buffer.decode_u8(3)).is_zero()
	_test = assert_str(packet.version).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(4, 12)))
	_test = assert_str(packet.product).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(12, 18)))
	_test = assert_int(packet.insim_ver).is_equal(buffer.decode_u8(18))
	_test = assert_int(buffer.decode_u8(19)).is_zero()
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
