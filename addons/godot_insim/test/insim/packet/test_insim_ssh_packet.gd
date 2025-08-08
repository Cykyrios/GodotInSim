extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_ssh_packet.gd"

var buffers := [
	[PackedByteArray([10, 49, 1, 0, 0, 0, 0, 0, 115, 99, 114, 101, 101, 110, 115,
			104, 111, 116, 95, 116, 101, 115, 116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([10, 49, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([10, 49, 255, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimSSHPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimSSHPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * packet.size_multiplier)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.error).is_equal(buffer.decode_u8(3))
	_test = assert_int(buffer.decode_u8(4)).is_zero()
	_test = assert_int(buffer.decode_u8(5)).is_zero()
	_test = assert_int(buffer.decode_u8(6)).is_zero()
	_test = assert_int(buffer.decode_u8(7)).is_zero()
	_test = (
		assert_str(packet.screenshot_name)
		.is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(8)))
	)
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimSSHPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.error = buffer.decode_u8(3) as InSim.Screenshot
	var _sp0 := buffer.decode_u8(4)
	var _sp1 := buffer.decode_u8(5)
	var _sp2 := buffer.decode_u8(6)
	var _sp3 := buffer.decode_u8(7)
	packet.screenshot_name = LFSText.lfs_bytes_to_unicode(buffer.slice(8))
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
