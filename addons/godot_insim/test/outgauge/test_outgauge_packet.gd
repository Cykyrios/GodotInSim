extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/outgauge/outgauge_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([134, 110, 1, 0, 46, 241, 219, 0, 0, 224, 2, 11, 103, 130, 132,
			55, 0, 0, 0, 0, 79, 63, 12, 181, 0, 0, 0, 0, 153, 153, 25, 62, 0, 0, 0,
			0, 0, 0, 0, 0, 110, 219, 1, 16, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 128, 63, 70, 117, 101, 108, 32, 49, 53, 46, 48, 37, 32, 32, 32, 0, 0,
			0, 66, 114, 97, 107, 101, 32, 66, 97, 108, 32, 70, 114, 32, 56, 52, 37])],
	[PackedByteArray([254, 130, 1, 0, 46, 241, 219, 0, 0, 224, 2, 11, 209, 146, 160,
			65, 30, 13, 162, 69, 179, 158, 80, 63, 0, 0, 0, 0, 58, 12, 25, 62, 0, 0,
			0, 0, 0, 0, 0, 0, 110, 219, 1, 16, 8, 0, 0, 0, 139, 1, 73, 63, 0, 0, 0,
			0, 0, 0, 0, 0, 70, 117, 101, 108, 32, 49, 52, 46, 57, 37, 32, 32, 32, 0,
			0, 0, 66, 114, 97, 107, 101, 32, 66, 97, 108, 32, 70, 114, 32, 56, 52, 37])],
	[PackedByteArray([206, 158, 1, 0, 46, 241, 219, 0, 0, 224, 5, 11, 4, 32, 18, 66,
			20, 2, 149, 69, 22, 126, 123, 63, 0, 0, 0, 0, 231, 84, 24, 62, 0, 0, 0,
			0, 0, 0, 0, 0, 110, 219, 1, 16, 0, 0, 0, 0, 0, 0, 128, 63, 0, 0, 0, 0,
			0, 0, 0, 0, 70, 117, 101, 108, 32, 49, 52, 46, 57, 37, 32, 32, 32, 0,
			0, 0, 66, 114, 97, 107, 101, 32, 66, 97, 108, 32, 70, 114, 32, 56, 52, 37])],
	[PackedByteArray([226, 168, 1, 0, 46, 241, 219, 0, 0, 224, 5, 11, 65, 22, 34, 66,
			204, 37, 163, 69, 29, 252, 37, 191, 0, 0, 0, 0, 157, 252, 23, 62, 0, 0,
			0, 0, 0, 0, 0, 0, 110, 219, 1, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 70, 117, 101, 108, 32, 49, 52, 46, 56, 37, 32, 32, 32, 0,
			0, 0, 66, 114, 97, 107, 101, 32, 66, 97, 108, 32, 70, 114, 32, 56, 52, 37])],
]


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := OutGaugePacket.new(buffer)
	var _test: GdUnitAssert = assert_int(packet.time).is_equal(buffer.decode_u32(0))
	_test = (
		assert_float(packet.gis_time)
		.is_equal_approx(buffer.decode_u32(0) / OutGaugePacket.TIME_MULTIPLIER, epsilon)
	)
	_test = (
		assert_str(packet.car_name).is_equal(LFSText.car_name_from_lfs_bytes(buffer.slice(4, 8)))
	)
	_test = assert_int(packet.flags).is_equal(buffer.decode_u16(8))
	_test = assert_int(packet.gear).is_equal(buffer.decode_u8(10))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(11))
	_test = assert_float(packet.speed).is_equal_approx(buffer.decode_float(12), epsilon)
	_test = assert_float(packet.rpm).is_equal_approx(buffer.decode_float(16), epsilon)
	_test = assert_float(packet.turbo).is_equal_approx(buffer.decode_float(20), epsilon)
	_test = assert_float(packet.engine_temp).is_equal_approx(buffer.decode_float(24), epsilon)
	_test = assert_float(packet.fuel).is_equal_approx(buffer.decode_float(28), epsilon)
	_test = assert_float(packet.oil_pres).is_equal_approx(buffer.decode_float(32), epsilon)
	_test = assert_float(packet.oil_temp).is_equal_approx(buffer.decode_float(36), epsilon)
	_test = assert_int(packet.dash_lights).is_equal(buffer.decode_u32(40))
	_test = assert_int(packet.show_lights).is_equal(buffer.decode_u32(44))
	_test = assert_float(packet.throttle).is_equal_approx(buffer.decode_float(48), epsilon)
	_test = assert_float(packet.brake).is_equal_approx(buffer.decode_float(52), epsilon)
	_test = assert_float(packet.clutch).is_equal_approx(buffer.decode_float(56), epsilon)
	_test = (
		assert_str(packet.display1).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(60, 76)))
	)
	_test = (
		assert_str(packet.display2).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(76, 92)))
	)
	if buffer.size() == OutGaugePacket.SIZE_WITH_ID:
		_test = assert_int(packet.id).is_equal(buffer.decode_s32(92))
