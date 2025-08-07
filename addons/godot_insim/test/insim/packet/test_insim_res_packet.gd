extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_res_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([21, 35, 0, 54, 66, 111, 107, 117, 106, 105, 115, 104, 105, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 94, 55, 50, 49, 32, 67, 46, 66, 105, 115, 115, 101, 121, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 32, 50, 49, 32, 45, 0, 112, 32, 227, 116, 0, 130, 129, 36, 0, 36, 8, 1, 0, 0, 0, 2, 0, 33, 0, 129, 0, 1, 3, 0, 0])],
	[PackedByteArray([21, 35, 0, 58, 66, 111, 107, 117, 106, 105, 115, 104, 105, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 94, 52, 52, 50, 32, 94, 55, 67, 121, 107, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52, 50, 0, 0, 0, 0, 0, 0, 80, 138, 137, 0, 236, 44, 115, 0, 250, 104, 1, 0, 0, 1, 2, 0, 77, 0, 1, 2, 8, 11, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimRESPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimRESPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimRESPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = (
		assert_str(packet.username)
		.is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(4, 28)))
	)
	_test = (
		assert_str(packet.player_name)
		.is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(28, 52)))
	)
	_test = (
		assert_str(packet.plate)
		.is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(52, 60)))
	)
	_test = (
		assert_str(packet.car_name)
		.is_equal(LFSText.car_name_from_lfs_bytes(buffer.slice(60, 64)))
	)
	_test = assert_int(packet.total_time).is_equal(buffer.decode_u32(64))
	_test = (
		assert_float(packet.gis_total_time)
		.is_equal_approx(buffer.decode_u32(64) / InSimRESPacket.TIME_MULTIPLIER, epsilon)
	)
	_test = assert_int(packet.best_lap).is_equal(buffer.decode_u32(68))
	_test = (
		assert_float(packet.gis_best_lap)
		.is_equal_approx(buffer.decode_u32(68) / InSimRESPacket.TIME_MULTIPLIER, epsilon)
	)
	_test = assert_int(buffer.decode_u8(72)).is_zero()
	_test = assert_int(packet.num_stops).is_equal(buffer.decode_u8(73))
	_test = assert_int(packet.confirm).is_equal(buffer.decode_u8(74))
	_test = assert_int(buffer.decode_u8(75)).is_zero()
	_test = assert_int(packet.laps_done).is_equal(buffer.decode_u16(76))
	_test = assert_int(packet.flags).is_equal(buffer.decode_u16(78))
	_test = assert_int(packet.result_num).is_equal(buffer.decode_u8(80))
	_test = assert_int(packet.num_results).is_equal(buffer.decode_u8(81))
	_test = assert_int(packet.penalty_seconds).is_equal(buffer.decode_u16(82))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
