extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_mtc_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([3, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([3, 14, 0, 0, 0, 0, 0, 0, 109, 105, 110, 0])],
	[PackedByteArray([9, 14, 0, 0, 255, 0, 0, 0, 77, 101, 115, 115, 97, 103, 101,
			32, 116, 111, 32, 97, 108, 108, 32, 99, 111, 110, 110, 101, 99, 116, 105,
			111, 110, 115, 33, 0])],
	[PackedByteArray([34, 14, 0, 0, 0, 10, 0, 0, 83, 101, 110, 100, 105, 110, 103, 32,
			97, 32, 118, 101, 114, 121, 32, 108, 111, 110, 103, 44, 32, 49, 50, 55, 45,
			98, 121, 116, 101, 32, 109, 101, 115, 115, 97, 103, 101, 32, 116, 111, 32,
			80, 76, 73, 68, 32, 49, 48, 44, 32, 116, 104, 101, 32, 108, 111, 110, 103,
			101, 115, 116, 32, 112, 111, 115, 115, 105, 98, 108, 101, 32, 97, 99, 116,
			117, 97, 108, 108, 121, 44, 32, 98, 101, 99, 97, 117, 115, 101, 32, 104, 101,
			32, 114, 101, 97, 108, 108, 121, 32, 108, 105, 107, 101, 115, 32, 114, 101,
			97, 100, 105, 110, 103, 32, 108, 111, 110, 103, 32, 109, 101, 115, 115, 97,
			103, 101, 115, 46, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimMTCPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.sound = buffer.decode_u8(3) as InSim.MessageSound
	packet.ucid = buffer.decode_u8(4)
	packet.plid = buffer.decode_u8(5)
	packet.sp2 = buffer.decode_u8(6)
	packet.sp3 = buffer.decode_u8(7)
	packet.text = LFSText.lfs_bytes_to_unicode(buffer.slice(8))
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_too_long_message(text: String, test_parameters := [
	[
		"123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_"
		+ "123456789_123456789_123456789_123456789_12345678"
	],
	[
		"123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_"
		+ "123456789_123456789_123456789_123456789_1234夢"
	],
	[
		"123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_"
		+ "123456789_123456789_123456789_123456789_12345夢"
	],
	[
		"123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_"
		+ "123456789_123456789_123456789_123456789_123456夢"
	],
	[
		"123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_"
		+ "123456789_123456789_123456789_123456789_1234567夢"
	],
	[
		"123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_"
		+ "123456789_123456789_123456789_123456789_12345678夢"
	],
	[
		"123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_"
		+ "123456789_123456789_123456789_123456789_123456789_123456789_123456789_"
	],
]) -> void:
	var packet := InSimMTCPacket.create(255, 0, text)
	packet.fill_buffer()
	var _test := assert_str(packet.text).is_not_equal(text)
	_test = (
		assert_str(packet.text)
		.starts_with(text.left(mini(text.length(), InSimMTCPacket.TEXT_MAX_LENGTH) - 1))
	)
