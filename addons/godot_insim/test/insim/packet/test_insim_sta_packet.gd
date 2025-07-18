extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_sta_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([7, 5, 250, 0, 0, 0, 128, 63, 197, 72, 0, 54, 13, 20, 0, 1, 0,
			33, 0, 0, 76, 65, 49, 88, 0, 0, 0, 1])],
	[PackedByteArray([7, 5, 0, 0, 0, 0, 128, 63, 193, 72, 0, 54, 13, 20, 0, 1, 0,
			33, 0, 0, 76, 65, 49, 88, 0, 0, 0, 1])],
	[PackedByteArray([7, 5, 0, 0, 0, 0, 128, 63, 209, 200, 0, 54, 13, 20, 0, 1, 0,
			33, 0, 0, 76, 65, 49, 88, 0, 0, 0, 1])],
	[PackedByteArray([7, 5, 0, 0, 0, 0, 128, 63, 193, 8, 0, 54, 13, 20, 0, 1, 0,
			33, 0, 0, 76, 65, 49, 88, 0, 0, 0, 1])],
	[PackedByteArray([7, 5, 0, 0, 0, 0, 128, 63, 192, 8, 0, 0, 2, 1, 0, 0, 0, 0,
			0, 0, 76, 65, 49, 88, 0, 0, 0, 0])],
	[PackedByteArray([7, 5, 0, 0, 0, 0, 128, 63, 192, 72, 0, 0, 2, 1, 0, 0, 10,
			30, 0, 0, 76, 65, 49, 88, 0, 0, 0, 2])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimSTAPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimSTAPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimSTAPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.zero).is_equal(buffer.decode_u8(3))
	_test = assert_float(packet.replay_speed).is_equal_approx(buffer.decode_float(4), epsilon)
	_test = assert_int(packet.flags).is_equal(buffer.decode_u16(8))
	_test = assert_int(packet.ingame_cam).is_equal(buffer.decode_u8(10))
	_test = assert_int(packet.view_plid).is_equal(buffer.decode_u8(11))
	_test = assert_int(packet.num_players).is_equal(buffer.decode_u8(12))
	_test = assert_int(packet.num_connections).is_equal(buffer.decode_u8(13))
	_test = assert_int(packet.num_finished).is_equal(buffer.decode_u8(14))
	_test = assert_int(packet.race_in_progress).is_equal(buffer.decode_u8(15))
	_test = assert_int(packet.qual_mins).is_equal(buffer.decode_u8(16))
	_test = assert_int(packet.race_laps).is_equal(buffer.decode_u8(17))
	_test = assert_int(packet.sp2).is_equal(buffer.decode_u8(18))
	_test = assert_int(packet.server_status).is_equal(buffer.decode_u8(19))
	_test = assert_str(packet.track).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(20, 26)))
	_test = assert_int(packet.weather).is_equal(buffer.decode_u8(26))
	_test = assert_int(packet.wind).is_equal(buffer.decode_u8(27))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
