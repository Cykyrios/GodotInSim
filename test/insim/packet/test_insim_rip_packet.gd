extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_rip_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([20, 48, 1, 0, 1, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 77, 82, 99,
			69, 67, 72, 50, 48, 50, 53, 95, 82, 111, 117, 110, 100, 52, 95, 70, 101,
			97, 116, 117, 114, 101, 82, 97, 99, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([20, 48, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 227, 127, 4, 0, 77, 82,
			99, 69, 67, 72, 50, 48, 50, 53, 95, 82, 111, 117, 110, 100, 52, 95, 70,
			101, 97, 116, 117, 114, 101, 82, 97, 99, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([20, 48, 1, 0, 1, 1, 0, 0, 82, 78, 0, 0, 227, 127, 4, 0, 77, 82,
			99, 69, 67, 72, 50, 48, 50, 53, 95, 82, 111, 117, 110, 100, 52, 95, 70, 101,
			97, 116, 117, 114, 101, 82, 97, 99, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([20, 48, 1, 1, 1, 1, 0, 0, 82, 78, 0, 0, 227, 127, 4, 0, 77, 82,
			99, 69, 67, 72, 50, 48, 50, 53, 95, 82, 111, 117, 110, 100, 52, 95, 70, 101,
			97, 116, 117, 114, 101, 82, 97, 99, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimRIPPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimRIPPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimRIPPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.error).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.mpr).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.paused).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.options).is_equal(buffer.decode_u8(6))
	_test = assert_int(packet.sp3).is_equal(buffer.decode_u8(7))
	_test = assert_int(packet.c_time).is_equal(buffer.decode_u32(8))
	_test = assert_float(packet.gis_c_time) \
			.is_equal_approx(buffer.decode_u32(8) / InSimRIPPacket.TIME_MULTIPLIER, epsilon)
	_test = assert_int(packet.t_time).is_equal(buffer.decode_u32(12))
	_test = assert_float(packet.gis_t_time) \
			.is_equal_approx(buffer.decode_u32(12) / InSimRIPPacket.TIME_MULTIPLIER, epsilon)
	_test = assert_str(packet.replay_name).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(16)))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimRIPPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.error = buffer.decode_u8(3)
	packet.mpr = buffer.decode_u8(4)
	packet.paused = buffer.decode_u8(5)
	packet.options = buffer.decode_u8(6)
	packet.sp3 = buffer.decode_u8(7)
	packet.c_time = buffer.decode_u32(8)
	packet.t_time = buffer.decode_u32(12)
	packet.replay_name = LFSText.lfs_bytes_to_unicode(buffer.slice(16))
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet_gis(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimRIPPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.error = buffer.decode_u8(3)
	packet.mpr = buffer.decode_u8(4)
	packet.paused = buffer.decode_u8(5)
	packet.options = buffer.decode_u8(6)
	packet.sp3 = buffer.decode_u8(7)
	packet.gis_c_time = buffer.decode_u32(8) / InSimRIPPacket.TIME_MULTIPLIER
	packet.gis_t_time = buffer.decode_u32(12) / InSimRIPPacket.TIME_MULTIPLIER
	packet.replay_name = LFSText.lfs_bytes_to_unicode(buffer.slice(16))
	packet.fill_buffer(true)
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
