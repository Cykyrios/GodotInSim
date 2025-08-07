extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_ism_packet.gd"

var buffers := [
	[PackedByteArray([10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([10, 10, 0, 0, 0, 0, 0, 0, 94, 48, 91, 94, 55, 77, 82, 94, 48, 99, 93,
			94, 55, 32, 69, 45, 67, 104, 97, 108, 108, 101, 110, 103, 101, 0, 0, 0, 0, 0, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimISMPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimISMPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimISMPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(buffer.decode_u8(3)).is_zero()
	_test = assert_int(packet.host).is_equal(buffer.decode_u8(4))
	_test = assert_int(buffer.decode_u8(5)).is_zero()
	_test = assert_int(buffer.decode_u8(6)).is_zero()
	_test = assert_int(buffer.decode_u8(7)).is_zero()
	_test = assert_str(packet.h_name).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(8)))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
