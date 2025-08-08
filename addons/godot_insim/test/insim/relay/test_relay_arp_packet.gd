extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/relay/relay_hos_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


var params_decode_packet := [
	[PackedByteArray([4, 251, 1, 0])],
]
@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := params_decode_packet) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as RelayARPPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(RelayARPPacket)
	_test = assert_int(packet.size).is_equal(buffer[0] * packet.size_multiplier)
	_test = assert_int(packet.type).is_equal(buffer[1])
	_test = assert_int(packet.req_i).is_equal(buffer[2])
	_test = assert_int(packet.admin).is_equal(buffer[3])
