extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_spx_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([4, 25, 0, 54, 38, 15, 2, 0, 38, 15, 2, 0, 1, 0, 0, 197])],
	[PackedByteArray([4, 25, 0, 23, 224, 129, 2, 0, 224, 129, 2, 0, 2, 0, 0, 194])],
	[PackedByteArray([4, 25, 0, 23, 216, 94, 0, 0, 18, 99, 33, 0, 1, 0, 0, 17])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimSPXPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimSPXPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimSPXPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.split_time).is_equal(buffer.decode_u32(4))
	_test = (
		assert_float(packet.gis_split_time)
		.is_equal_approx(buffer.decode_u32(4) / InSimSPXPacket.TIME_MULTIPLIER, epsilon)
	)
	_test = assert_int(packet.elapsed_time).is_equal(buffer.decode_u32(8))
	_test = (
		assert_float(packet.gis_elapsed_time)
		.is_equal_approx(buffer.decode_u32(8) / InSimSPXPacket.TIME_MULTIPLIER, epsilon)
	)
	_test = assert_int(packet.split).is_equal(buffer.decode_u8(12))
	_test = assert_int(packet.penalty).is_equal(buffer.decode_u8(13))
	_test = assert_int(packet.num_stops).is_equal(buffer.decode_u8(14))
	_test = assert_int(packet.fuel200).is_equal(buffer.decode_u8(15))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
