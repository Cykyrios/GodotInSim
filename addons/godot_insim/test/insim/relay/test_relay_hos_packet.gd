extends TestInSimPacketGeneric

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/relay/relay_hos_packet.gd"


func test_receivable_sendable() -> void:
	_test_receivable_sendable(preload(__source).new())


var params_decode_packet := [
	[PackedByteArray([
		61, 253, 1, 6, 78, 117, 98, 98, 105, 110, 115, 32, 65, 85, 32, 68, 101,
		109, 111, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 66, 76, 49,
		0, 0, 0, 32, 5, 94, 50, 82, 111, 110, 121, 115, 32, 94, 51, 84, 117, 101,
		115, 100, 97, 121, 115, 32, 94, 53, 70, 117, 110, 32, 94, 50, 82, 97, 99,
		101, 0, 82, 79, 50, 0, 0, 0, 18, 1, 94, 48, 91, 94, 55, 77, 82, 94, 48,
		99, 93, 94, 55, 32, 66, 101, 103, 105, 110, 110, 101, 114, 94, 48, 32, 66,
		77, 87, 0, 0, 0, 0, 66, 76, 50, 0, 0, 0, 0, 6, 94, 54, 91, 94, 55, 76, 67,
		83, 94, 54, 93, 32, 94, 55, 67, 114, 117, 105, 115, 101, 32, 83, 101, 114,
		118, 101, 114, 0, 0, 0, 0, 0, 66, 76, 49, 0, 0, 0, 32, 1, 94, 48, 119, 119,
		119, 46, 94, 49, 67, 69, 83, 94, 51, 65, 94, 49, 86, 94, 48, 46, 101, 115,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70, 69, 51, 82, 0, 0, 18, 1, 94, 49, 40, 94,
		51, 70, 77, 94, 49, 41, 32, 94, 52, 71, 84, 105, 32, 84, 104, 117, 114, 115,
		100, 97, 121, 0, 0, 0, 0, 0, 0, 0, 65, 83, 55, 82, 0, 0, 18, 1,
	])],
	[PackedByteArray([
		11, 253, 1, 1, 94, 54, 91, 94, 55, 83, 82, 94, 51, 153, 94, 54, 93, 32, 94,
		48, 83, 51, 32, 94, 49, 77, 117, 108, 116, 105, 99, 108, 97, 115, 115, 0,
		70, 69, 51, 0, 0, 0, 146, 1,
	])],
]
@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := params_decode_packet) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer) as RelayHOSPacket
	var _test: GdUnitAssert = assert_object(packet).is_instanceof(RelayHOSPacket)
	_test = assert_int(packet.size).is_equal(buffer[0] * packet.size_multiplier)
	_test = assert_int(packet.type).is_equal(buffer[1])
	_test = assert_int(packet.req_i).is_equal(buffer[2])
	_test = assert_int(packet.num_hosts).is_equal(buffer[3])
	var host_info_buffer := buffer.slice(4)
	for h in packet.num_hosts:
		var host_info := HostInfo.new()
		var buffer_slice := host_info_buffer.slice(
			h * HostInfo.STRUCT_SIZE, (h + 1) * HostInfo.STRUCT_SIZE
		)
		host_info.set_from_buffer(buffer_slice)
		_test = assert_array(host_info.get_buffer()).is_equal(buffer_slice)
