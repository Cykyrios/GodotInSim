extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/relay/relay_hlr_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


var params_encode_packet := [
	[PackedByteArray([4, 252, 1, 0])],
	[PackedByteArray([4, 252, 42, 0])],
]
@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := params_encode_packet) -> void:
	var packet := RelayHLRPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
