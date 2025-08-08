class_name TestInSimPacket
extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/insim/packet/insim_packet.gd"


@warning_ignore("unused_parameter")
func test_decode_header(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([5, 2, 1, 0])],
	[PackedByteArray([20, 50, 9, 42])],
]) -> void:
	var packet := InSimPacket.new()
	packet.buffer = buffer
	packet.decode_header(buffer)
	var _test := assert_int(packet.size).is_equal(buffer[0] * packet.size_multiplier)
	_test = assert_int(packet.type).is_equal(buffer[1])
	_test = assert_int(packet.req_i).is_equal(buffer[2])


@warning_ignore("unused_parameter")
func test_decode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([5, 2, 1, 0, 48, 46, 55, 70, 0, 0, 0, 0, 83, 51, 0, 0, 0, 0, 9, 0])],
	[PackedByteArray([10, 50, 0, 0, 102, 0, 151, 4, 1, 0, 0, 254, 240, 112, 16, 9, 249, 249, 3,
			255, 227, 251, 64, 7, 34, 0, 0, 220, 240, 0, 16, 8, 50, 40, 1, 243, 6, 252, 93, 7])],
]) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer)
	var _test: GdUnitAssert = assert_int(packet.size).is_equal(
		buffer[0] * packet.size_multiplier
	)
	_test = assert_int(packet.type).is_equal(buffer[1])
	_test = assert_int(packet.req_i).is_equal(buffer[2])
	_test = assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_encode_packet(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([5, 2, 1, 0, 48, 46, 55, 70, 0, 0, 0, 0, 83, 51, 0, 0, 0, 0, 9, 0])],
	[PackedByteArray([10, 50, 0, 0, 102, 0, 151, 4, 1, 0, 0, 254, 240, 112, 16, 9, 249, 249, 3,
			255, 227, 251, 64, 7, 34, 0, 0, 220, 240, 0, 16, 8, 50, 40, 1, 243, 6, 252, 93, 7])],
]) -> void:
	var packet := InSimPacket.create_packet_from_buffer(buffer)
	var _test := assert_array(packet.buffer).is_equal(buffer)
