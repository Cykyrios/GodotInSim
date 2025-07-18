extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_ttc_packet.gd"

var buffers := [
	[PackedByteArray([2, 61, 1, 1, 0, 0, 0, 0])],
	[PackedByteArray([2, 61, 1, 2, 10, 0, 0, 0])],
	[PackedByteArray([2, 61, 1, 3, 50, 0, 0, 0])],
]


func test_receivable_sendable() -> void:
	for subtype in InSim.TTC.size():
		var packet := InSimTTCPacket.create(0, subtype)
		var _test := assert_bool(packet.receivable).is_equal(subtype in InSimTTCPacket.RECEIVABLES)
		_test = assert_bool(packet.sendable).is_equal(subtype in InSimTTCPacket.SENDABLES)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimTTCPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.sub_type = buffer.decode_u8(3) as InSim.TTC
	packet.ucid = buffer.decode_u8(4)
	packet.b1 = buffer.decode_u8(5)
	packet.b2 = buffer.decode_u8(6)
	packet.b3 = buffer.decode_u8(7)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test: GdUnitAssert = assert_int(packet.sub_type).is_in(InSimTTCPacket.SENDABLES)
	_test = assert_array(packet.buffer).is_equal(buffer)
