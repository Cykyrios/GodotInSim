extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_lap_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([5, 24, 0, 62, 220, 4, 1, 0, 166, 196, 3, 0, 2, 0, 129, 0, 0, 0, 0, 175])],
	[PackedByteArray([5, 24, 0, 45, 144, 209, 2, 0, 144, 209, 2, 0, 1, 0, 64, 0, 0, 0, 0, 188])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimLAPPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimLAPPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimLAPPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.lap_time).is_equal(buffer.decode_u32(4))
	_test = (
		assert_float(packet.gis_lap_time)
		.is_equal_approx(buffer.decode_u32(4) / InSimLAPPacket.TIME_MULTIPLIER, epsilon)
	)
	_test = assert_int(packet.elapsed_time).is_equal(buffer.decode_u32(8))
	_test = (
		assert_float(packet.gis_elapsed_time)
		.is_equal_approx(buffer.decode_u32(8) / InSimLAPPacket.TIME_MULTIPLIER, epsilon)
	)
	_test = assert_int(packet.laps_done).is_equal(buffer.decode_u16(12))
	_test = assert_int(packet.flags).is_equal(buffer.decode_u16(14))
	_test = assert_int(packet.sp0).is_equal(buffer.decode_u8(16))
	_test = assert_int(packet.penalty).is_equal(buffer.decode_u8(17))
	_test = assert_int(packet.num_stops).is_equal(buffer.decode_u8(18))
	_test = assert_int(packet.fuel200).is_equal(buffer.decode_u8(19))
	_test = (
		assert_float(packet.gis_fuel)
		.is_equal_approx(buffer.decode_u8(19) / InSimLAPPacket.FUEL_MULTIPLIER, epsilon)
	)
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
