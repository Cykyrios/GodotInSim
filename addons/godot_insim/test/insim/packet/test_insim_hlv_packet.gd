extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_hlv_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([4, 52, 0, 4, 0, 0, 223, 5, 0, 6, 17, 1, 124, 250, 250, 241])],
	[PackedByteArray([4, 52, 0, 4, 1, 0, 60, 8, 0, 174, 14, 1, 14, 253, 233, 248])],
	[PackedByteArray([4, 52, 0, 1, 4, 0, 110, 4, 0, 253, 23, 40, 155, 250, 151, 9])],
	[PackedByteArray([4, 52, 0, 1, 5, 0, 180, 33, 0, 234, 31, 2, 21, 253, 185, 241])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimHLVPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimHLVPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimHLVPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.hlvc).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.sp1).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.time).is_equal(buffer.decode_u16(6))
	_test = assert_float(packet.gis_time).is_equal_approx(
		buffer.decode_u16(6) / InSimHLVPacket.TIME_MULTIPLIER, epsilon
	)
	_test = assert_array(packet.object.get_buffer()).is_equal(buffer.slice(8))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
