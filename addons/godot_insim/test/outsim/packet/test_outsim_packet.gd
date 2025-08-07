extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/outsim/packet/outsim_packet.gd"

var epsilon := 1e-5
var parameters := [
	[0x1ff, PackedByteArray([76, 70, 83, 84, 0, 0, 0, 0, 122, 3, 0, 0, 199, 160,
			244, 59, 129, 104, 46, 188, 161, 208, 120, 188, 75, 24, 199, 191, 192,
			18, 236, 59, 75, 129, 106, 186, 165, 126, 6, 190, 192, 168, 178, 61,
			142, 118, 99, 59, 43, 36, 26, 60, 160, 161, 150, 59, 172, 64, 139, 186,
			59, 98, 149, 255, 138, 255, 115, 0, 120, 82, 10, 0, 179, 51, 51, 63,
			0, 0, 0, 0, 165, 231, 200, 188, 0, 0, 128, 63, 0, 0, 128, 63, 1, 0, 0,
			0, 40, 125, 61, 67, 243, 27, 130, 67, 0, 0, 0, 0, 20, 121, 77, 69, 225,
			138, 11, 61, 54, 250, 14, 60, 43, 64, 13, 66, 177, 176, 9, 66, 78, 33,
			246, 68, 0, 0, 0, 0, 184, 112, 117, 189, 80, 0, 1, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 7, 236, 6, 61, 54, 250, 14, 188, 178, 196, 178, 65, 25, 209,
			244, 194, 93, 47, 202, 68, 0, 0, 0, 0, 87, 25, 126, 61, 80, 0, 1, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 18, 84, 63, 61, 137, 220, 175, 188, 105, 115,
			11, 69, 216, 136, 163, 194, 28, 230, 83, 69, 214, 142, 29, 61, 181, 216,
			78, 189, 80, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 168, 239, 61, 61, 167,
			28, 235, 188, 5, 222, 20, 197, 214, 95, 120, 66, 32, 13, 80, 69, 63,
			109, 1, 61, 152, 115, 59, 61, 80, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32,
			3, 169, 192, 0, 0, 0, 0])],
	[0x1ff, PackedByteArray([76, 70, 83, 84, 0, 0, 0, 0, 140, 215, 0, 0, 149, 148,
			71, 188, 189, 169, 138, 189, 97, 21, 198, 190, 150, 149, 45, 64, 110,
			233, 69, 59, 168, 218, 61, 187, 97, 87, 16, 193, 14, 5, 8, 65, 38, 210,
			166, 190, 106, 98, 36, 193, 233, 179, 214, 193, 180, 25, 26, 61, 160,
			44, 167, 1, 194, 241, 21, 253, 184, 67, 0, 0, 0, 0, 0, 0, 179, 50, 179,
			62, 167, 118, 122, 189, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 28, 70, 225,
			67, 130, 17, 152, 67, 133, 212, 247, 68, 138, 128, 241, 68, 223, 11,
			13, 61, 54, 250, 14, 60, 252, 127, 135, 69, 59, 203, 200, 195, 130, 173,
			65, 69, 49, 23, 191, 66, 151, 145, 53, 188, 75, 174, 1, 0, 162, 71, 151,
			187, 234, 160, 159, 61, 177, 224, 193, 60, 54, 250, 14, 188, 73, 32,
			222, 190, 196, 52, 5, 191, 234, 70, 19, 195, 0, 0, 0, 0, 165, 171, 164,
			61, 75, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 97, 128, 117, 61, 151, 250,
			63, 189, 186, 121, 241, 69, 221, 27, 37, 197, 197, 103, 191, 69, 96,
			59, 188, 66, 96, 110, 70, 187, 79, 177, 1, 0, 190, 84, 129, 188, 5, 153,
			199, 61, 196, 26, 17, 61, 198, 206, 96, 189, 108, 16, 105, 68, 152, 67,
			115, 196, 108, 206, 74, 68, 130, 139, 166, 66, 97, 171, 163, 61, 79,
			255, 1, 0, 137, 129, 222, 189, 72, 20, 220, 61, 187, 41, 87, 67, 0, 0, 0, 0])],
	[0x50, PackedByteArray([0, 0, 0, 0, 0, 0, 0, 0, 95, 230, 168, 189, 0, 0, 0, 0,
			0, 0, 0, 0, 46, 96, 1, 69, 163, 53, 253, 68])],
]

@warning_ignore("unused_parameter")
func test_decode_packet(
	outsim_opts: int, buffer: PackedByteArray, test_parameters := parameters
) -> void:
	var packet := OutSimPacket.new(outsim_opts, buffer)
	var _test: GdUnitAssert = assert_int(packet.outsim_options).is_equal(outsim_opts)
	var offset := 0
	if packet.outsim_options & OutSim.OutSimOpts.OSO_HEADER:
		_test = (
			assert_str(packet.header)
			.is_equal(LFSText.lfs_bytes_to_unicode(buffer.slice(offset, offset + 4), false))
		)
		offset += 4
	if packet.outsim_options & OutSim.OutSimOpts.OSO_ID:
		_test = assert_int(packet.id).is_equal(buffer.decode_s32(offset))
		offset += 4
	if packet.outsim_options & OutSim.OutSimOpts.OSO_TIME:
		_test = assert_int(packet.time).is_equal(buffer.decode_u32(offset))
		_test = (
			assert_float(packet.gis_time)
			.is_equal_approx(buffer.decode_u32(offset) / OutSimPacket.TIME_MULTIPLIER, epsilon)
		)
		offset += 4
	if packet.outsim_options & OutSim.OutSimOpts.OSO_MAIN:
		_test = (
			assert_array(packet.os_main.get_buffer())
			.is_equal(buffer.slice(offset, offset + OutSimMain.STRUCT_SIZE))
		)
		offset += OutSimMain.STRUCT_SIZE
	if packet.outsim_options & OutSim.OutSimOpts.OSO_INPUTS:
		_test = (
			assert_float(packet.os_inputs.throttle)
			.is_equal_approx(buffer.decode_float(offset), epsilon)
		)
		_test = (
			assert_float(packet.os_inputs.brake)
			.is_equal_approx(buffer.decode_float(offset + 4), epsilon)
		)
		_test = (
			assert_float(packet.os_inputs.input_steer)
			.is_equal_approx(buffer.decode_float(offset + 8), epsilon)
		)
		_test = (
			assert_float(packet.os_inputs.clutch)
			.is_equal_approx(buffer.decode_float(offset + 12), epsilon)
		)
		_test = (
			assert_float(packet.os_inputs.handbrake)
			.is_equal_approx(buffer.decode_float(offset + 16), epsilon)
		)
		offset += OutSimInputs.STRUCT_SIZE
	if packet.outsim_options & OutSim.OutSimOpts.OSO_DRIVE:
		_test = assert_int(packet.gear).is_equal(buffer.decode_u8(offset))
		_test = assert_int(buffer.decode_u8(offset + 1)).is_zero()
		_test = assert_int(buffer.decode_u8(offset + 2)).is_zero()
		_test = assert_int(buffer.decode_u8(offset + 3)).is_zero()
		_test = (
			assert_float(packet.engine_ang_vel)
			.is_equal_approx(buffer.decode_float(offset + 4), epsilon)
		)
		_test = (
			assert_float(packet.max_torque_at_vel)
			.is_equal_approx(buffer.decode_float(offset + 8), epsilon)
		)
		offset += 12
	if packet.outsim_options & OutSim.OutSimOpts.OSO_DISTANCE:
		_test = (
			assert_float(packet.current_lap_distance)
			.is_equal_approx(buffer.decode_float(offset), epsilon)
		)
		_test = (
			assert_float(packet.indexed_distance)
			.is_equal_approx(buffer.decode_float(offset + 4), epsilon)
		)
		offset += 8
	if packet.outsim_options & OutSim.OutSimOpts.OSO_WHEELS:
		for i in 4:
			var wheel := packet.os_wheels[i]
			_test = (
				assert_float(wheel.susp_deflect)
				.is_equal_approx(buffer.decode_float(offset), epsilon)
			)
			_test = (
				assert_float(wheel.steer)
				.is_equal_approx(buffer.decode_float(offset + 4), epsilon)
			)
			_test = (
				assert_float(wheel.x_force)
				.is_equal_approx(buffer.decode_float(offset + 8), epsilon)
			)
			_test = (
				assert_float(wheel.y_force)
				.is_equal_approx(buffer.decode_float(offset + 12), epsilon)
			)
			_test = (
				assert_float(wheel.vertical_load)
				.is_equal_approx(buffer.decode_float(offset + 16), epsilon)
			)
			_test = (
				assert_float(wheel.ang_vel)
				.is_equal_approx(buffer.decode_float(offset + 20), epsilon)
			)
			_test = (
				assert_float(wheel.lean_rel_to_road)
				.is_equal_approx(buffer.decode_float(offset + 24), epsilon)
			)
			_test = assert_int(wheel.air_temp).is_equal(buffer.decode_u8(offset + 28))
			_test = assert_int(wheel.slip_fraction).is_equal(buffer.decode_u8(offset + 29))
			_test = assert_int(wheel.touching).is_equal(buffer.decode_u8(offset + 30))
			_test = assert_int(wheel.sp3).is_equal(buffer.decode_u8(offset + 31))
			_test = (
				assert_float(wheel.slip_ratio)
				.is_equal_approx(buffer.decode_float(offset + 32), epsilon)
			)
			_test = (
				assert_float(wheel.tan_slip_angle)
				.is_equal_approx(buffer.decode_float(offset + 36), epsilon)
			)
			offset += OutSimWheel.STRUCT_SIZE
	if packet.outsim_options & OutSim.OutSimOpts.OSO_EXTRA_1:
		_test = (
			assert_float(packet.steer_torque)
			.is_equal_approx(buffer.decode_float(offset), epsilon)
		)
		_test = (
			assert_float(buffer.decode_float(offset + 4)).is_zero()
		)
