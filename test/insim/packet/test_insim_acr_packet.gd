extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_acr_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


var params_decode_packet := [
	[PackedByteArray([4, 55, 0, 0, 0, 1, 1, 0, 47, 108, 97, 112, 115, 32, 53, 0])],
	[PackedByteArray([5, 55, 0, 0, 0, 1, 1, 0, 47, 104, 111, 117, 114, 115, 32, 50, 0, 0, 0, 0])],
]
@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := params_decode_packet) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimACRPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimACRPacket)
	_test = assert_int(packet.size).is_equal(buffer[0] * InSimACRPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer[1])
	_test = assert_int(packet.req_i).is_equal(buffer[2])
	_test = assert_int(packet.zero).is_equal(buffer[3])
	_test = assert_int(packet.ucid).is_equal(buffer[4])
	_test = assert_int(packet.admin).is_equal(buffer[5])
	_test = assert_int(packet.result).is_equal(buffer[6])
	_test = assert_int(packet.sp3).is_equal(buffer[7])
	_test = assert_str(packet.text).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(8)))
