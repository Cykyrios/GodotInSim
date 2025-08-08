extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_slc_packet.gd"

var buffers := [
	[PackedByteArray([2, 62, 0, 1, 0, 0, 0, 0])],
	[PackedByteArray([2, 62, 0, 1, 70, 66, 77, 0])],
	[PackedByteArray([2, 62, 1, 1, 70, 66, 77, 0])],
	[PackedByteArray([2, 62, 255, 21, 46, 241, 219, 0])],
]

func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := buffers) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimSLCPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimSLCPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * packet.size_multiplier)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.ucid).is_equal(buffer.decode_u8(3))
	_test = assert_str(packet.car_name).is_equal(LFSText.car_name_from_lfs_bytes(buffer.slice(4)))
	packet.fill_buffer()
	_test = assert_array(packet.buffer).is_equal(buffer)
