extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_rst_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([7, 17, 0, 0, 10, 0, 2, 66, 66, 76, 49, 0, 0, 0, 1, 1, 99, 52,
			146, 1, 109, 1, 95, 0, 255, 0, 255, 255])],
	[PackedByteArray([7, 17, 0, 0, 0, 0, 2, 66, 66, 76, 49, 0, 0, 0, 1, 1, 99, 52,
			146, 1, 109, 1, 95, 0, 255, 0, 255, 255])],
	[PackedByteArray([7, 17, 0, 0, 0, 5, 2, 66, 66, 76, 49, 0, 0, 0, 1, 0, 99, 52,
			146, 1, 109, 1, 95, 0, 255, 0, 255, 255])],
	[PackedByteArray([7, 17, 0, 0, 33, 0, 15, 130, 76, 65, 49, 88, 0, 0, 0, 1, 161,
			52, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimRSTPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimRSTPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * packet.size_multiplier)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(buffer.decode_u8(3)).is_zero()
	_test = assert_int(packet.race_laps).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.qual_mins).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.num_players).is_equal(buffer.decode_u8(6))
	_test = assert_int(packet.timing).is_equal(buffer.decode_u8(7))
	_test = assert_str(packet.track).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(8, 14)))
	_test = assert_int(packet.weather).is_equal(buffer.decode_u8(14))
	_test = assert_int(packet.wind).is_equal(buffer.decode_u8(15))
	_test = assert_int(packet.flags).is_equal(buffer.decode_u16(16))
	_test = assert_int(packet.num_nodes).is_equal(buffer.decode_u16(18))
	_test = assert_int(packet.finish).is_equal(buffer.decode_u16(20))
	_test = assert_int(packet.split1).is_equal(buffer.decode_u16(22))
	_test = assert_int(packet.split2).is_equal(buffer.decode_u16(24))
	_test = assert_int(packet.split3).is_equal(buffer.decode_u16(26))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
