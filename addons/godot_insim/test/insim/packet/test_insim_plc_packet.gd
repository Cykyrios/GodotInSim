extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_plc_packet.gd"

var buffers := [
	[PackedByteArray([3, 53, 0, 0, 1, 0, 0, 0, 28, 0, 0, 0])],
	[PackedByteArray([3, 53, 0, 0, 1, 0, 0, 0, 0, 128, 3, 0])],
	[PackedByteArray([3, 53, 0, 0, 1, 0, 0, 0, 255, 255, 255, 255])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPLCPacket.new()
	packet.req_i = buffer.decode_u8(2)
	var _zero := buffer.decode_u8(3)
	packet.ucid = buffer.decode_u8(4)
	var _sp1 := buffer.decode_u8(5)
	var _sp2 := buffer.decode_u8(6)
	var _sp3 := buffer.decode_u8(7)
	packet.cars = buffer.decode_u32(8)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
