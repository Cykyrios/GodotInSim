extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_cnl_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([5, 63, 0, 3, 0, 1, 0, 0, 36, 2, 0, 0, 0, 193, 1, 42, 92, 249, 64, 7])],
	[PackedByteArray([5, 63, 0, 3, 0, 0, 0, 0, 148, 3, 0, 0, 0, 252, 1, 42, 27, 250, 19, 8])],
	[PackedByteArray([5, 63, 0, 1, 0, 0, 0, 0, 228, 15, 0, 0, 0, 254, 1, 42, 129, 250, 12, 8])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


var params_decode_packet := buffers
@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([5, 63, 0, 3, 0, 1, 0, 0, 36, 2, 0, 0, 0, 193, 1, 42, 92, 249, 64, 7])],
	[PackedByteArray([5, 63, 0, 3, 0, 0, 0, 0, 148, 3, 0, 0, 0, 252, 1, 42, 27, 250, 19, 8])],
	[PackedByteArray([5, 63, 0, 1, 0, 0, 0, 0, 228, 15, 0, 0, 0, 254, 1, 42, 129, 250, 12, 8])],
]) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimCSCPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimCSCPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimCSCPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.sp0).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.csc_action).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.sp2).is_equal(buffer.decode_u8(6))
	_test = assert_int(packet.sp3).is_equal(buffer.decode_u8(7))
	_test = assert_int(packet.time).is_equal(buffer.decode_u32(8))
	_test = assert_float(packet.gis_time).is_equal_approx(
		buffer.decode_u32(8) / InSimCSCPacket.TIME_MULTIPLIER, epsilon
	)
	_test = assert_array(packet.object.get_buffer()).is_equal(buffer.slice(12))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
