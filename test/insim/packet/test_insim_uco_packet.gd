extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_uco_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([7, 59, 0, 3, 0, 2, 0, 0, 46, 3, 0, 0, 0, 249, 13, 39, 111, 249,
			66, 11, 143, 249, 58, 11, 37, 21, 252, 120])],
	[PackedByteArray([7, 59, 0, 3, 0, 2, 0, 0, 164, 3, 0, 0, 0, 245, 10, 39, 164, 249,
			16, 12, 184, 249, 11, 12, 37, 23, 252, 120])],
	[PackedByteArray([7, 59, 0, 3, 0, 3, 0, 0, 76, 6, 0, 0, 0, 245, 9, 39, 138, 249,
			171, 11, 166, 249, 166, 11, 37, 22, 252, 120])],
	[PackedByteArray([7, 59, 0, 3, 0, 0, 0, 0, 161, 25, 0, 0, 0, 107, 0, 38, 213, 246,
			5, 11, 219, 246, 21, 11, 36, 4, 253, 42])],
	[PackedByteArray([7, 59, 0, 3, 0, 1, 0, 0, 112, 29, 0, 0, 0, 106, 0, 38, 213, 246,
			5, 11, 219, 246, 21, 11, 36, 4, 253, 42])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimUCOPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimUCOPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimUCOPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.sp0).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.uco_action).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.sp2).is_equal(buffer.decode_u8(6))
	_test = assert_int(packet.sp3).is_equal(buffer.decode_u8(7))
	_test = assert_int(packet.time).is_equal(buffer.decode_u32(8))
	_test = assert_float(packet.gis_time) \
			.is_equal_approx(buffer.decode_u32(8) / InSimUCOPacket.TIME_MULTIPLIER, epsilon)
	_test = assert_array(packet.object.get_buffer()) \
			.is_equal(buffer.slice(12, 12 + CarContObj.STRUCT_SIZE))
	_test = assert_array(packet.info.get_buffer()) \
			.is_equal(buffer.slice(12 + CarContObj.STRUCT_SIZE))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
