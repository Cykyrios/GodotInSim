extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_plp_packet.gd"

var buffers := [
	[PackedByteArray([1, 22, 0, 1])],
	[PackedByteArray([1, 22, 0, 5])],
	[PackedByteArray([1, 22, 0, 30])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimPLPPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimPLPPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimPLPPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
