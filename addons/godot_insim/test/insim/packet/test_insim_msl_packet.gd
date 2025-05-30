extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_msl_packet.gd"

var epsilon := 1e-5
var buffers := [
	[PackedByteArray([33, 40, 0, 1, 84, 101, 115, 116, 33, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([33, 40, 0, 2, 83, 101, 110, 100, 105, 110, 103, 32, 97, 32, 118,
			101, 114, 121, 32, 108, 111, 110, 103, 32, 108, 111, 99, 97, 108, 32, 109,
			101, 115, 115, 97, 103, 101, 44, 32, 98, 101, 99, 97, 117, 115, 101, 32,
			108, 111, 99, 97, 108, 32, 109, 101, 115, 115, 97, 103, 101, 115, 32, 99,
			97, 110, 32, 98, 101, 32, 118, 101, 114, 121, 32, 108, 111, 110, 103, 44,
			32, 49, 50, 55, 32, 98, 121, 116, 101, 115, 32, 108, 111, 110, 103, 32,
			116, 111, 32, 98, 101, 32, 101, 120, 97, 99, 116, 44, 32, 106, 117, 115,
			116, 32, 108, 105, 107, 101, 32, 116, 104, 105, 115, 32, 109, 101, 115,
			115, 97, 103, 101, 46, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimMSLPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.sound = buffer.decode_u8(3) as InSim.MessageSound
	packet.msg = LFSText.lfs_bytes_to_unicode(buffer.slice(4))
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_too_long_message(text: String, test_parameters := [
	["123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_" \
			+ "123456789_123456789_123456789_123456789_12345678"],
	["123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_" \
			+ "123456789_123456789_123456789_123456789_1234夢"],
	["123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_" \
			+ "123456789_123456789_123456789_123456789_12345夢"],
	["123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_" \
			+ "123456789_123456789_123456789_123456789_123456夢"],
	["123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_" \
			+ "123456789_123456789_123456789_123456789_1234567夢"],
	["123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_" \
			+ "123456789_123456789_123456789_123456789_12345678夢"],
	["123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_" \
			+ "123456789_123456789_123456789_123456789_123456789_123456789_123456789_"],
]) -> void:
	var packet := InSimMSLPacket.create(text)
	packet.fill_buffer()
	var _test := assert_str(packet.msg).is_not_equal(text)
	_test = assert_str(packet.msg) \
			.starts_with(text.left(mini(text.length(), InSimMSLPacket.MSG_MAX_LENGTH) - 1))
