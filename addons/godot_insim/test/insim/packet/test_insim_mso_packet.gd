extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_mso_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([4, 11, 0, 0, 0, 0, 0, 0, 84, 101, 115, 116, 33, 0, 0, 0])],
	[PackedByteArray([13, 11, 0, 0, 1, 2, 1, 14, 94, 55, 94, 55, 67, 121, 107, 32,
			94, 55, 58, 32, 94, 56, 94, 48, 87, 94, 49, 79, 94, 50, 87, 94, 51, 33,
			94, 52, 33, 94, 53, 33, 94, 54, 33, 94, 55, 33, 94, 57, 33, 0, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimMSOPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimMSOPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * packet.size_multiplier)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(buffer.decode_u8(3)).is_zero()
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.user_type).is_equal(buffer.decode_u8(6))
	_test = assert_int(packet.text_start).is_equal(buffer.decode_u8(7))
	_test = assert_str(packet.msg).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(8)))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
