extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_sch_packet.gd"

var buffers := [
	[PackedByteArray([2, 6, 0, 0, 65, 0, 0, 0])],
	[PackedByteArray([2, 6, 0, 0, 90, 0, 0, 0])],
	[PackedByteArray([2, 6, 0, 0, 48, 0, 0, 0])],
	[PackedByteArray([2, 6, 0, 0, 57, 0, 0, 0])],
	[PackedByteArray([2, 6, 0, 0, 72, 1, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimSCHPacket.new()
	packet.req_i = buffer.decode_u8(2)
	var _zero := buffer.decode_u8(3)
	packet.char_byte = buffer.decode_u8(4)
	packet.flags = buffer.decode_u8(5)
	var _spare2 := buffer.decode_u8(6)
	var _spare3 := buffer.decode_u8(7)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
