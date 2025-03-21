extends GutTest


var epsilon := 1e-5

var buffers := [
	[PackedByteArray([8, 9, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			3, 3, 0, 0, 140, 66, 0, 0, 129, 72])],
	[PackedByteArray([8, 9, 1, 0, 43, 195, 126, 255, 149, 195, 197, 0, 7, 173, 49, 0, 78, 25,
			225, 13, 0, 0, 3, 3, 0, 0, 112, 66, 0, 0, 9, 72])],
	[PackedByteArray([8, 9, 1, 0, 239, 96, 132, 1, 255, 36, 80, 254, 135, 175, 1, 0, 193, 252,
			58, 4, 0, 0, 3, 3, 0, 0, 112, 66, 0, 100, 73, 72])],
]


func test_receivable_sendable() -> void:
	var packet := InSimCPPPacket.new()
	if packet.receivable:
		assert_true(has_method("test_decode_packet"),
			"Receivable packet has test_decode_packet test")
	else:
		assert_false(has_method("test_decode_packet"),
			"Non-receivable packet does not have test_decode_packet test")
	if packet.sendable:
		assert_true(has_method("test_encode_packet"),
			"Sendable packet has test_encode_packet test")
	else:
		assert_false(has_method("test_encode_packet"),
			"Non-sendable packet does not have test_encode_packet test")


var params_decode_packet := buffers
func test_decode_packet(params: Array = use_parameters(params_decode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimPacket.create_packet_from_buffer(buffer) as InSimCPPPacket
	assert_is(packet, InSimCPPPacket)
	if is_failing():
		return
	assert_eq(packet.size, buffer.decode_u8(0) * InSimCPPPacket.SIZE_MULTIPLIER)
	assert_eq(packet.type, buffer.decode_u8(1))
	assert_eq(packet.req_i, buffer.decode_u8(2))
	assert_eq(packet.zero, buffer.decode_u8(3))
	assert_eq(packet.pos, Vector3i(
		buffer.decode_s32(4),
		buffer.decode_s32(8),
		buffer.decode_s32(12)
	))
	assert_eq(packet.heading, buffer.decode_u16(16))
	assert_eq(packet.pitch, buffer.decode_u16(18))
	assert_eq(packet.roll, buffer.decode_u16(20))
	assert_eq(packet.view_plid, buffer.decode_u8(22))
	assert_eq(packet.ingame_cam, buffer.decode_u8(23))
	assert_eq(packet.fov, buffer.decode_float(24))
	assert_eq(packet.time, buffer.decode_u16(28))
	assert_eq(packet.flags, buffer.decode_u16(30))
	packet.fill_buffer()
	assert_eq(packet.buffer, buffer)


var params_encode_packet := buffers
func test_encode_packet(params: Array = use_parameters(params_encode_packet)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimCPPPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.zero = buffer.decode_u8(3)
	packet.pos = Vector3i(
		buffer.decode_s32(4),
		buffer.decode_s32(8),
		buffer.decode_s32(12)
	)
	packet.heading = buffer.decode_u16(16)
	packet.pitch = buffer.decode_u16(18)
	packet.roll = buffer.decode_u16(20)
	packet.view_plid = buffer.decode_u8(22)
	packet.ingame_cam = buffer.decode_u8(23)
	packet.fov = buffer.decode_float(24)
	packet.time = buffer.decode_u16(28)
	packet.flags = buffer.decode_u16(30)
	packet.fill_buffer()
	if packet.type != buffer.decode_u8(1):
		fail_test("Incorrect packet type")
		return
	assert_eq(packet.buffer, buffer)


var params_encode_packet_gis := buffers
func test_encode_packet_gis(params: Array = use_parameters(params_encode_packet_gis)) -> void:
	var buffer := params[0] as PackedByteArray
	var packet := InSimCPPPacket.new()
	packet.req_i = buffer.decode_u8(2)
	packet.zero = buffer.decode_u8(3)
	packet.gis_position = Vector3(
		buffer.decode_s32(4),
		buffer.decode_s32(8),
		buffer.decode_s32(12)
	) / InSimCPPPacket.POSITION_MULTIPLIER
	packet.gis_angles = Vector3(
		wrapf(deg_to_rad(-buffer.decode_u16(18) / InSimCPPPacket.ANGLE_MULTIPLIER), -PI, PI),
		wrapf(deg_to_rad(buffer.decode_u16(20) / InSimCPPPacket.ANGLE_MULTIPLIER), -PI, PI),
		wrapf(deg_to_rad(buffer.decode_u16(16) / InSimCPPPacket.ANGLE_MULTIPLIER - 180), -PI, PI)
	)
	packet.view_plid = buffer.decode_u8(22)
	packet.ingame_cam = buffer.decode_u8(23)
	packet.fov = buffer.decode_float(24)
	packet.gis_time = buffer.decode_u16(28) / InSimCPPPacket.TIME_MULTIPLIER
	packet.flags = buffer.decode_u16(30)
	packet.fill_buffer(true)
	if packet.type != buffer.decode_u8(1):
		fail_test("Incorrect packet type")
		return
	if packet.buffer == buffer:
		assert_eq(packet.buffer, buffer)
	else:
		if packet.buffer.size() != buffer.size():
			fail_test("Wrong buffer size")
			return
		for i in buffer.size():
			var got := packet.buffer[i]
			var expected := buffer[i]
			if (
				got < expected - 1 and not(got == 0 and expected == 255)
				or got > expected + 1 and not(got == 255 and expected == 0)
			):
				print("Got %d, expected %d" % [packet.buffer[i], buffer[i]])
				fail_test("Wrong buffer value(s)")
		pending("Buffer has at least one float precision issue, but result is acceptable.")
