extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_isi_packet.gd"

var buffers := [
	[PackedByteArray([
		11, 1, 1, 0, 0, 0, 8, 0, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 73, 110, 83, 105, 109, 32, 66, 117, 116, 116, 111, 110, 115,
		0, 0, 0,
	])],
	[PackedByteArray([
		11, 1, 1, 0, 0, 0, 44, 0, 9, 33, 100, 0, 121, 97, 121, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 84, 101, 115, 116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	])],
]


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimISIPacket.new()
	packet.req_i = buffer.decode_u8(2)
	var _zero := buffer.decode_u8(3)
	packet.udp_port = buffer.decode_u16(4)
	packet.flags = buffer.decode_u16(6)
	packet.insim_version = buffer.decode_u8(8)
	var offset := 9 + InSimISIPacket.PREFIX_LENGTH
	packet.prefix = LFSText.lfs_bytes_to_unicode(buffer.slice(9, offset))
	packet.interval = buffer.decode_u16(offset)
	offset += 2
	packet.admin = LFSText.lfs_bytes_to_unicode(
		buffer.slice(offset, offset + InSimISIPacket.ADMIN_LENGTH)
	)
	offset += InSimISIPacket.ADMIN_LENGTH
	packet.i_name = LFSText.lfs_bytes_to_unicode(
		buffer.slice(offset, offset + InSimISIPacket.NAME_LENGTH)
	)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail("Incorrect packet type")
		return
	var _test := assert_array(packet.buffer).is_equal(buffer)
