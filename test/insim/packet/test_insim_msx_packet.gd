extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_msx_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([25, 39, 0, 0, 84, 101, 115, 116, 33, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([25, 39, 0, 0, 83, 101, 110, 100, 105, 110, 103, 32, 97, 32, 54,
			52, 45, 98, 121, 116, 101, 32, 109, 101, 115, 115, 97, 103, 101, 44, 32, 119,
			104, 105, 99, 104, 32, 105, 115, 32, 116, 111, 111, 32, 108, 111, 110, 103,
			32, 102, 111, 114, 32, 73, 83, 95, 77, 83, 84, 32, 116, 111, 32, 104, 111,
			108, 100, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([25, 39, 0, 0, 83, 101, 110, 100, 105, 110, 103, 32, 97, 32, 57, 53,
	45, 98, 121, 116, 101, 32, 109, 101, 115, 115, 97, 103, 101, 44, 32, 119, 104, 105,
	99, 104, 32, 105, 115, 32, 116, 104, 101, 32, 109, 97, 120, 105, 109, 117, 109, 32,
	108, 101, 110, 103, 116, 104, 32, 102, 111, 114, 32, 73, 83, 95, 77, 83, 88, 32, 40,
	115, 105, 110, 99, 101, 32, 98, 121, 116, 101, 32, 57, 54, 32, 109, 117, 115, 116, 32,
	98, 101, 32, 122, 101, 114, 111, 41, 46, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimMSXPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.zero = buffer.decode_u8(3)
	packet.msg = LFSText.lfs_bytes_to_unicode(buffer.slice(4))
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
