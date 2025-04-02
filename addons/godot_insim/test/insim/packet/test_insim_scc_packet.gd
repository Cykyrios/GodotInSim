extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_scc_packet.gd"

var buffers := [
	[PackedByteArray([2, 8, 0, 0, 1, 0, 0, 0])],
	[PackedByteArray([2, 8, 0, 0, 42, 4, 0, 0])],
	[PackedByteArray([2, 8, 0, 0, 255, 255, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimSCCPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.zero = buffer.decode_u8(3)
	packet.view_plid = buffer.decode_u8(4)
	packet.ingame_cam = buffer.decode_u8(5) as InSim.View
	packet.sp2 = buffer.decode_u8(6)
	packet.sp3 = buffer.decode_u8(7)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
