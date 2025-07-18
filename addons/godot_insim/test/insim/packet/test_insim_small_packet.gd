extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_small_packet.gd"

var receivable_buffers := [
	[PackedByteArray([2, 4, 0, 3, 1, 0, 0, 0])],
	[PackedByteArray([2, 4, 2, 6, 175, 24, 0, 0])],
	[PackedByteArray([2, 4, 0, 8, 0, 0, 0, 0])],
]
var sendable_buffers := [
	[PackedByteArray([2, 4, 0, 1, 0, 0, 0, 0])],
	[PackedByteArray([2, 4, 0, 2, 0, 0, 0, 0])],
	[PackedByteArray([2, 4, 208, 4, 1, 0, 0, 0])],
	[PackedByteArray([2, 4, 0, 7, 0, 0, 0, 0])],
	[PackedByteArray([2, 4, 0, 8, 0, 0, 0, 0])],
	[PackedByteArray([2, 4, 0, 9, 0, 0, 0, 0])],
	[PackedByteArray([2, 4, 0, 10, 0, 0, 0, 0])],
	[PackedByteArray([2, 4, 0, 11, 0, 0, 0, 0])],
]


func test_receivable_sendable() -> void:
	for subtype in InSim.Small.size():
		var packet := InSimSmallPacket.create(0, subtype)
		var _test := (
			assert_bool(packet.receivable).is_equal(subtype in InSimSmallPacket.RECEIVABLES)
		)
		_test = (
			assert_bool(packet.sendable).is_equal(subtype in InSimSmallPacket.SENDABLES)
		)


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := receivable_buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimSmallPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimSmallPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimSmallPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.sub_type).is_equal(buffer.decode_u8(3))
	_test = assert_int(packet.value).is_equal(buffer.decode_u32(4))
	packet.fill_buffer()
	_test = assert_int(packet.sub_type).is_in(InSimSmallPacket.RECEIVABLES)
	_test = assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := sendable_buffers) -> void:
	var packet := InSimSmallPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.sub_type = buffer.decode_u8(3) as InSim.Small
	packet.value = buffer.decode_u32(4)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test: GdUnitAssert = assert_int(packet.sub_type).is_in(InSimSmallPacket.SENDABLES)
	_test = assert_array(packet.buffer).is_equal(buffer)
