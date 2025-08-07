extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_sfp_packet.gd"

var buffers := [
	[PackedByteArray([2, 7, 0, 0, 0, 64, 1, 0])],
	[PackedByteArray([2, 7, 0, 0, 16, 0, 1, 0])],
	[PackedByteArray([2, 7, 0, 0, 16, 0, 0, 0])],
	[PackedByteArray([2, 7, 0, 0, 20, 192, 1, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimSFPPacket.new()
	packet.req_i = buffer.decode_u8(2)
	var _zero := buffer.decode_u8(3)
	packet.flag = buffer.decode_u16(4) as InSim.State
	packet.off_on = buffer.decode_u8(6)
	var _sp3 := buffer.decode_u8(7)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
