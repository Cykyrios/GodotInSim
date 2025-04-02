extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_tiny_packet.gd"

var receivable_buffers := [
	[PackedByteArray([1, 3, 0, 0])],
	[PackedByteArray([1, 3, 1, 4])],
	[PackedByteArray([1, 3, 2, 5])],
	[PackedByteArray([1, 3, 3, 12])],
	[PackedByteArray([1, 3, 255, 21])],
]
var sendable_buffers := [
	[PackedByteArray([1, 3, 0, 0])],
	[PackedByteArray([1, 3, 1, 1])],
	[PackedByteArray([1, 3, 2, 2])],
	[PackedByteArray([1, 3, 10, 5])],
	[PackedByteArray([1, 3, 100, 14])],
	[PackedByteArray([1, 3, 255, 28])],
]


func test_receivable_sendable() -> void:
	for subtype in InSim.Tiny.size():
		var packet := InSimTinyPacket.create(0, subtype)
		var _test := assert_bool(packet.receivable) \
				.is_equal(subtype in InSimTinyPacket.RECEIVABLES)
		_test = assert_bool(packet.sendable) \
				.is_equal(subtype in InSimTinyPacket.SENDABLES)


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := receivable_buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimTinyPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimTinyPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimTinyPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.sub_type).is_equal(buffer.decode_u8(3))
	packet.fill_buffer()
	_test = assert_int(packet.sub_type).is_in(InSimTinyPacket.RECEIVABLES)
	_test = assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := sendable_buffers) -> void:
	var packet := InSimTinyPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.sub_type = buffer.decode_u8(3) as InSim.Tiny
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test: GdUnitAssert = assert_int(packet.sub_type).is_in(InSimTinyPacket.SENDABLES)
	_test = assert_array(packet.buffer).is_equal(buffer)
