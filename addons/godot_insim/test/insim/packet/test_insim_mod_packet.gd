extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_mod_packet.gd"

var buffers := [
	[PackedByteArray([5, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([5, 15, 0, 0, 1, 0, 0, 0, 75, 0, 0, 0, 128, 7, 0, 0, 56, 4, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimMODPacket.new()
	packet.req_i = buffer.decode_u8(2)
	var _zero := buffer.decode_u8(3)
	packet.bits16 = buffer.decode_s32(4)
	packet.refresh_rate = buffer.decode_s32(8)
	packet.width = buffer.decode_s32(12)
	packet.height = buffer.decode_s32(16)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
