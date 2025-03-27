extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/lfs_packet.gd"

var packet: LFSPacket = null


func before_test() -> void:
	packet = auto_free(preload(__source).new())


@warning_ignore("unused_parameter")
func test_add_buffer(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([0])],
	[PackedByteArray([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])],
]) -> void:
	packet.resize_buffer(buffer.size())
	packet.add_buffer(buffer)
	var _test := assert_array(packet.buffer).is_equal(buffer)


func test_add_buffer_empty_buffer() -> void:
	packet.resize_buffer(10)
	var _test := await assert_error(func() -> void: packet.add_buffer(PackedByteArray())) \
			.is_push_error("Cannot add data, buffer is empty")


func test_add_buffer_not_enough_space() -> void:
	packet.resize_buffer(2)
	var buffer := PackedByteArray([0, 1, 2])
	var _test := await assert_error(func() -> void:
		packet.add_buffer(buffer)
	).is_push_error("Not enough space to add buffer (size %d, available %d)" % [buffer.size(),
			packet.buffer.size()])


@warning_ignore("unused_parameter")
func test_add_byte(byte: int, test_parameters := [
	[0],
	[255],
	[42],
]) -> void:
	packet.resize_buffer(1)
	packet.add_byte(byte)
	var _test := assert_array(packet.buffer).is_equal([byte])


@warning_ignore("unused_parameter")
func test_add_char(character: String, test_parameters := [
	["A"],
]) -> void:
	packet.resize_buffer(1)
	packet.add_char(character)
	var _test := assert_array(packet.buffer).is_equal(LFSText.unicode_to_lfs_bytes(character))


@warning_ignore("unused_parameter")
func test_add_float(number: float, test_parameters := [
	[PI],
]) -> void:
	packet.resize_buffer(4)
	packet.add_float(number)
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_float(0, number)
	var _test := assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_add_int(number: int, test_parameters := [
	[-0x8000_0000],
	[0x7FFF_FFFF],
	[int(PI * 1_000_000)],
]) -> void:
	packet.resize_buffer(4)
	packet.add_int(number)
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_s32(0, number)
	var _test := assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_add_short(number: int, test_parameters := [
	[-0x8000],
	[0x7FFF],
	[1337],
]) -> void:
	packet.resize_buffer(2)
	packet.add_short(number)
	var buffer := PackedByteArray([0, 0])
	buffer.encode_s16(0, number)
	var _test := assert_array(packet.buffer).is_equal(buffer)


func test_add_string() -> void:
	var buffer_size := 24
	var text := "test"
	packet.resize_buffer(buffer_size)
	var _buffer := packet.add_string(buffer_size, text)
	var _test: GdUnitAssert = assert_str(LFSText.lfs_bytes_to_unicode(packet.buffer)) \
			.is_equal(text)
	var expected := LFSText.unicode_to_lfs_bytes(text)
	var _discard := expected.resize(buffer_size)
	_test = assert_array(packet.buffer).is_equal(expected)


func test_add_string_as_utf8() -> void:
	var buffer_size := 24
	var text := "test"
	packet.resize_buffer(buffer_size)
	var _buffer := packet.add_string_as_utf8(buffer_size, text)
	var _test: GdUnitAssert = assert_str(packet.buffer.get_string_from_utf8()) \
			.is_equal(text)
	var expected := LFSText.unicode_to_lfs_bytes(text)
	var _discard := expected.resize(buffer_size)
	_test = assert_array(packet.buffer).is_equal(expected)


@warning_ignore("unused_parameter")
func test_add_string_variable_length(text: String, max_length: int, step: int, test_parameters := [
	["test", 4, 4],
	["test", 24, 4],
	["test test", 24, 4],
]
) -> void:
	packet.resize_buffer(max_length)
	var _buffer := packet.add_string_variable_length(text, max_length, step)
	var expected := LFSText.unicode_to_lfs_bytes(text)
	var needed_size := (text.length() + step) - ((text.length() + step) % step)
	var _discard := expected.resize(mini(needed_size, max_length))
	expected[-1] = 0
	var _test: GdUnitAssert = assert_array(packet.buffer.slice(0, expected.size())) \
			.is_equal(expected)
	_test = assert_str(LFSText.lfs_bytes_to_unicode(packet.buffer)) \
			.is_equal(LFSText.lfs_bytes_to_unicode(expected))


@warning_ignore("unused_parameter")
func test_add_unsigned(number: int, test_parameters := [
	[0],
	[0xFFFF_FFFF],
	[int(PI * 1_000_000)],
]) -> void:
	packet.resize_buffer(4)
	packet.add_unsigned(number)
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_u32(0, number)
	var _test := assert_array(packet.buffer).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_add_word(number: int, test_parameters := [
	[0],
	[0xFFFF],
	[1337],
]) -> void:
	packet.resize_buffer(2)
	packet.add_word(number)
	var buffer := PackedByteArray([0, 0])
	buffer.encode_u16(0, number)
	var _test := assert_array(packet.buffer).is_equal(buffer)


func test_get_dictionary_color_conversion() -> void:
	var mock_packet := mock(LFSPacket, CALL_REAL_FUNC) as LFSPacket
	var base_text := "^1Colored ^6text"
	var converted_text := "[color=#ff0000]Colored [/color][color=#00ffff]text[/color]"
	@warning_ignore("unsafe_method_access")
	do_return({"key": base_text}).on(mock_packet)._get_dictionary()
	var _test := assert_str(str(mock_packet.get_dictionary(false))).contains(base_text)
	_test = assert_str(str(mock_packet.get_dictionary(true))) \
			.contains(LFSText.lfs_colors_to_bbcode(converted_text))


@warning_ignore("unused_parameter")
func test_read_buffer(buffer: PackedByteArray, test_parameters := [
	[PackedByteArray([0])],
	[PackedByteArray([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])],
	[PackedByteArray([])],
]) -> void:
	packet.buffer = buffer
	var _test := assert_array(packet.read_buffer(buffer.size())).is_equal(buffer)


@warning_ignore("unused_parameter")
func test_read_byte(number: int, test_parameters := [
	[0],
	[255],
	[42],
]) -> void:
	var buffer := PackedByteArray([0])
	buffer.encode_u8(0, number)
	packet.buffer = buffer
	var _test := assert_int(packet.read_byte()).is_equal(number)


@warning_ignore("unused_parameter")
func test_read_car_name(car_name: String, test_parameters := [
	["UF1"],
	["FBM"],
	["XRT"],
	["FZ5"],
	["DBF12E"],
]) -> void:
	packet.buffer = LFSText.car_name_to_lfs_bytes(car_name)
	var _test := assert_str(packet.read_car_name()).is_equal(car_name)


@warning_ignore("unused_parameter")
func test_read_char(text: String, test_parameters := [
	["A"],
	["z"],
	["5"],
	["_"],
	["^"],
	["!"],
]) -> void:
	# Buffer sliced to keep only first character, as special characters
	# can be replaced with ^ and another character (and ^ == ^^)
	var buffer := LFSText.unicode_to_lfs_bytes(text).slice(0, 1)
	packet.buffer = buffer
	var _test := assert_str(packet.read_char()) \
			.is_equal(LFSText.lfs_bytes_to_unicode(buffer, false))


@warning_ignore("unused_parameter")
func test_read_float(number: float, test_parameters := [
	[PI * 1_000_000],
	[PI / 1_000],
]) -> void:
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_float(0, number)
	packet.buffer = buffer
	var _test := assert_float(packet.read_float()).is_equal(buffer.decode_float(0))


@warning_ignore("unused_parameter")
func test_read_int(number: int, test_parameters := [
	[int(PI * 1_000_000)],
	[42],
	[-123_456_789],
]) -> void:
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_s32(0, number)
	packet.buffer = buffer
	var _test := assert_int(packet.read_int()).is_equal(buffer.decode_s32(0))


@warning_ignore("unused_parameter")
func test_read_short(number: int, test_parameters := [
	[int(PI * 1_000_000)],
	[42],
	[-123_456_789],
]) -> void:
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_s16(0, number)
	packet.buffer = buffer
	var _test := assert_int(packet.read_short()).is_equal(buffer.decode_s16(0))


@warning_ignore("unused_parameter")
func test_read_string(text: String, test_parameters := [
	["test"],
	["Live For Speed"],
	["InSim"],
	["日本語"],
]) -> void:
	packet.buffer = LFSText.unicode_to_lfs_bytes(text)
	var _test := assert_str(packet.read_string(packet.buffer.size(), false)) \
			.is_equal(text)


@warning_ignore("unused_parameter")
func test_read_string_as_utf8(text: String, test_parameters := [
	["test"],
	["Live For Speed"],
	["InSim"],
	["日本語"],
]) -> void:
	packet.buffer = text.to_utf8_buffer()
	var _test := assert_str(packet.read_string_as_utf8(packet.buffer.size())) \
			.is_equal(text)


@warning_ignore("unused_parameter")
func test_read_unsigned(number: int, test_parameters := [
	[int(PI * 1_000_000)],
	[42],
	[-123_456_789],
]) -> void:
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_u32(0, number)
	packet.buffer = buffer
	var _test := assert_int(packet.read_unsigned()).is_equal(buffer.decode_u32(0))


@warning_ignore("unused_parameter")
func test_read_word(number: int, test_parameters := [
	[int(PI * 1_000_000)],
	[42],
	[-123_456_789],
]) -> void:
	var buffer := PackedByteArray([0, 0, 0, 0])
	buffer.encode_u16(0, number)
	packet.buffer = buffer
	var _test := assert_int(packet.read_word()).is_equal(buffer.decode_u16(0))


@warning_ignore("unused_parameter")
func test_resize_buffer(size: int, test_parameters := [
	[10],
	[0],
	[400],
]) -> void:
	var _discard := packet.buffer.resize(size)
	var _test := assert_array(packet.buffer).has_size(size)
