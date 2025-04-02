extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_axo_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([1, 44, 0, 34])],
]
) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimAXOPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(InSimAXOPacket)
	if is_failure():
		return
	_test = assert_int(packet.size).is_equal(buffer.decode_u8(0) * InSimAXOPacket.SIZE_MULTIPLIER)
	_test = assert_int(packet.type).is_equal(buffer.decode_u8(1))
	_test = assert_int(packet.req_i).is_equal(buffer.decode_u8(2))
	_test = assert_int(packet.plid).is_equal(buffer.decode_u8(3))
	_test = assert_array(packet.buffer).is_equal(buffer)
