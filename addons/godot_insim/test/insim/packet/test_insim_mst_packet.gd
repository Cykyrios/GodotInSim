extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_mst_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([17, 13, 0, 0, 84, 101, 115, 116, 33, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([17, 13, 0, 0, 83, 101, 110, 100, 105, 110, 103, 32, 97, 32,
			115, 111, 109, 101, 119, 104, 97, 116, 32, 108, 111, 110, 103, 32, 109,
			101, 115, 115, 97, 103, 101, 32, 40, 54, 51, 32, 98, 121, 116, 101, 115,
			41, 44, 32, 115, 111, 32, 115, 116, 105, 108, 108, 32, 97, 110, 32, 73,
			83, 95, 77, 83, 84, 46, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimMSTPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.zero = buffer.decode_u8(3)
	packet.msg = LFSText.lfs_bytes_to_unicode(buffer.slice(4))
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_too_long_message(text: String, test_parameters := [
	["123456789_123456789_123456789_123456789_123456789_123456789_1234"],
	["123456789_123456789_123456789_123456789_123456789_123456789_123夢"],
	["123456789_123456789_123456789_123456789_123456789_123456789_12夢"],
	["123456789_123456789_123456789_123456789_123456789_123456789_1夢"],
	["123456789_123456789_123456789_123456789_123456789_123456789_夢"],
]) -> void:
	var packet := InSimMSTPacket.create(text)
	packet.fill_buffer()
	var _test := assert_str(packet.msg).is_not_equal(text)
	_test = assert_str(packet.msg) \
			.starts_with(text.left(mini(text.length(), InSimMSTPacket.MSG_MAX_LENGTH) - 1))
