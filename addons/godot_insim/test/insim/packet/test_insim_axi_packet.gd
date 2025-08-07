extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_axi_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


var params_decode_packet := [
	[PackedByteArray([10, 43, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([10, 43, 0, 0, 0, 3, 8, 0, 66, 76, 49, 95, 116, 101, 115, 116, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([10, 43, 0, 0, 0, 2, 83, 11, 76, 65, 50, 88, 95, 66, 66, 66, 32, 82,
			105, 110, 103, 32, 86, 101, 114, 32, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
]
@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([10, 43, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([10, 43, 0, 0, 0, 3, 8, 0, 66, 76, 49, 95, 116, 101, 115, 116, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
	[PackedByteArray([10, 43, 0, 0, 0, 2, 83, 11, 76, 65, 50, 88, 95, 66, 66, 66, 32, 82,
			105, 110, 103, 32, 86, 101, 114, 32, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])],
]) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimAXIPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimAXIPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimAXIPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(buffer.decode_u8(3)).is_zero()
	_test = assert_int(packet.ax_start).is_equal(buffer.decode_u8(4))
	_test = assert_int(packet.num_checkpoints).is_equal(buffer.decode_u8(5))
	_test = assert_int(packet.num_objects).is_equal(buffer.decode_u16(6))
	_test = assert_str(packet.layout_name).is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(8)))
	_test = assert_array(packet.buffer).is_equal(buffer)
