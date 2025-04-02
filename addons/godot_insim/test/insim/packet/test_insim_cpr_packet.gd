extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_cpr_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([9, 20, 0, 0, 94, 52, 52, 50, 32, 94, 55, 67, 121, 107, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 52, 50, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([9, 20, 0, 0, 94, 55, 67, 121, 107, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 67, 121, 107, 0, 67, 89, 75, 75])],
]) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimCPRPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimCPRPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimCPRPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(3))
	_test = assert_str(packet.player_name).is_equal(LFSText.lfs_bytes_to_unicode(
			buffer.slice(4, 4 + InSimCPRPacket.PLAYER_NAME_MAX_LENGTH)))
	_test = assert_str(packet.plate).is_equal(LFSText.lfs_bytes_to_unicode(
			buffer.slice(4 + InSimCPRPacket.PLAYER_NAME_MAX_LENGTH)))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
