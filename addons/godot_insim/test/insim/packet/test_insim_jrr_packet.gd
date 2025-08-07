extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_jrr_packet.gd"

var buffers := [
	[PackedByteArray([4, 58, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([4, 58, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([4, 58, 0, 11, 0, 5, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0])],
	[PackedByteArray([4, 58, 0, 11, 0, 5, 0, 0, 208, 255, 80, 1, 196, 128, 0, 128])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimJRRPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.plid = buffer.decode_u8(3)
	packet.ucid = buffer.decode_u8(4)
	packet.action = buffer.decode_u8(5)
	var _sp2 := buffer.decode_u8(6)
	var _sp3 := buffer.decode_u8(7)
	var object_info := ObjectInfo.new()
	object_info.set_from_buffer(buffer.slice(8))
	packet.start_pos = object_info
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
