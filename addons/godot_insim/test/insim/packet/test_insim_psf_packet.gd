extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_psf_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([3, 27, 0, 1, 108, 12, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([3, 27, 0, 3, 34, 81, 0, 0, 0, 0, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimPSFPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimPSFPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimPSFPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.stop_time).is_equal(buffer.decode_u32(4))
	_test = (
		assert_float(packet.gis_stop_time)
		.is_equal_approx(buffer.decode_u32(4) / InSimPSFPacket.TIME_MULTIPLIER, epsilon)
	)
	_test = assert_int(packet.spare).is_equal(buffer.decode_u32(8))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
