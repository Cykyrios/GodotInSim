extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/relay/relay_sel_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


var params_encode_packet := [
	[PackedByteArray([
		68, 254, 1, 0, 94, 48, 91, 94, 55, 77, 82, 94, 48, 99, 93, 94, 55, 32, 66,
		101, 103, 105, 110, 110, 101, 114, 94, 48, 32, 66, 77, 87, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0,
	])],
	[PackedByteArray([
		68, 254, 1, 0, 94, 49, 40, 94, 51, 70, 77, 94, 49, 41, 32, 94, 52, 70, 111,
		120, 32, 70, 114, 105, 100, 97, 121, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0,
	])],
]
@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := params_encode_packet) -> void:
	var packet := RelaySELPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.host_name = LFSText.lfs_bytes_to_unicode(
		buffer.slice(4, 4 + RelaySELPacket.HOST_NAME_LENGTH)
	)
	packet.admin = LFSText.lfs_bytes_to_unicode(
		buffer.slice(
			4 + RelaySELPacket.HOST_NAME_LENGTH,
			4 + RelaySELPacket.HOST_NAME_LENGTH + RelaySELPacket.ADMIN_LENGTH,
		)
	)
	packet.spec = LFSText.lfs_bytes_to_unicode(
		buffer.slice(4 + RelaySELPacket.HOST_NAME_LENGTH + RelaySELPacket.ADMIN_LENGTH)
	)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
