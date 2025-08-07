extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_oco_packet.gd"

var buffers := [
	[PackedByteArray([2, 60, 0, 0, 4, 0, 0, 0])],
	[PackedByteArray([2, 60, 0, 0, 5, InSim.OCO_INDEX_MAIN, 255, 1])],
	[PackedByteArray([2, 60, 0, 0, 5, InSim.OCO_INDEX_MAIN, 255, 15])],
	[PackedByteArray([2, 60, 0, 0, 5, 149, 255, 15])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimOCOPacket.new()
	packet.req_i = buffer.decode_u8(2)
	var _zero := buffer.decode_u8(3)
	packet.action = buffer.decode_u8(4) as InSim.OCOAction
	packet.index = buffer.decode_u8(5)
	packet.identifier = buffer.decode_u8(6)
	packet.data = buffer.decode_u8(7)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
