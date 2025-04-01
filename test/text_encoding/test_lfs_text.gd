extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/text_encoding/lfs_text.gd"


@warning_ignore("unused_parameter")
func test_car_name_from_lfs_bytes(buffer: PackedByteArray, car_name: String, test_parameters := [
	[PackedByteArray([85, 70, 49, 0]), "UF1"],
	[PackedByteArray([88, 82, 84, 0]), "XRT"],
	[PackedByteArray([70, 66, 77, 0]), "FBM"],
	[PackedByteArray([70, 90, 53, 0]), "FZ5"],
	[PackedByteArray([46, 241, 219, 0]), "DBF12E"],
]) -> void:
	var _test := assert_str(LFSText.car_name_from_lfs_bytes(buffer)).is_equal(car_name)


@warning_ignore("unused_parameter")
func test_car_name_to_lfs_bytes(buffer: PackedByteArray, car_name: String, test_parameters := [
	[PackedByteArray([85, 70, 49, 0]), "UF1"],
	[PackedByteArray([88, 82, 84, 0]), "XRT"],
	[PackedByteArray([70, 66, 77, 0]), "FBM"],
	[PackedByteArray([70, 90, 53, 0]), "FZ5"],
	[PackedByteArray([46, 241, 219, 0]), "DBF12E"],
]) -> void:
	var _test := assert_array(LFSText.car_name_to_lfs_bytes(car_name)).is_equal(buffer)


#region colors
@warning_ignore("unused_parameter")
func test_convert_colors(
	text: String, to: LFSText.ColorType, from: LFSText.ColorType, expected: String,
	test_parameters := [
		[
			"Test test",
			LFSText.ColorType.BBCODE,
			LFSText.ColorType.LFS,
			"Test test",
		],
		[
			"Test test",
			LFSText.ColorType.BBCODE,
			LFSText.ColorType.ANSI,
			"Test test",
		],
		[
			"Test test",
			LFSText.ColorType.BBCODE,
			LFSText.ColorType.STRIP,
			"Test test",
		],
		[
			"Test test",
			LFSText.ColorType.LFS,
			LFSText.ColorType.LFS,
			"Test test",
		],
		[
			"Test test",
			LFSText.ColorType.LFS,
			LFSText.ColorType.BBCODE,
			"Test test",
		],
		[
			"Test test",
			LFSText.ColorType.LFS,
			LFSText.ColorType.STRIP,
			"Test test",
		],
		[
			"Test test",
			LFSText.ColorType.ANSI,
			LFSText.ColorType.LFS,
			"Test test",
		],
		[
			"Test test",
			LFSText.ColorType.ANSI,
			LFSText.ColorType.BBCODE,
			"Test test",
		],
		[
			"Test test",
			LFSText.ColorType.ANSI,
			LFSText.ColorType.STRIP,
			"Test test",
		],
		[
			"Test test",
			LFSText.ColorType.STRIP,
			LFSText.ColorType.LFS,
			"Test test",
		],
		[
			"Test test",
			LFSText.ColorType.STRIP,
			LFSText.ColorType.BBCODE,
			"Test test",
		],
		[
			"Test test",
			LFSText.ColorType.STRIP,
			LFSText.ColorType.ANSI,
			"Test test",
		],
		[
			"^7Test ^1te^9st",
			LFSText.ColorType.STRIP,
			LFSText.ColorType.LFS,
			"Test test",
		],
		[
			"[color=#ffffff]Test [/color][color=#ff0000]te[/color]st",
			LFSText.ColorType.STRIP,
			LFSText.ColorType.BBCODE,
			"Test test",
		],
		[
			"\u001b[97mTest \u001b[91mte\u001b[39mst",
			LFSText.ColorType.STRIP,
			LFSText.ColorType.ANSI,
			"Test test",
		],
		[
			"\u001b[38;2;255;255;255mTest \u001b[38;2;255;0;0mte\u001b[39mst",
			LFSText.ColorType.STRIP,
			LFSText.ColorType.ANSI,
			"Test test",
		],
		[
			"[color=#ffffff]Test [/color][color=#ff0000]te[/color]st",
			LFSText.ColorType.LFS,
			LFSText.ColorType.BBCODE,
			"^7Test ^1te^9st",
		],
		[
			"\u001b[97mTest \u001b[91mte\u001b[39mst",
			LFSText.ColorType.LFS,
			LFSText.ColorType.ANSI,
			"^7Test ^1te^9st",
		],
		[
			"\u001b[38;2;255;255;255mTest \u001b[38;2;255;0;0mte\u001b[39mst",
			LFSText.ColorType.LFS,
			LFSText.ColorType.ANSI,
			"^7Test ^1te^9st",
		],
		[
			"\u001b[97mTest \u001b[91mte\u001b[39mst",
			LFSText.ColorType.LFS,
			LFSText.ColorType.LFS,
			"\u001b[97mTest \u001b[91mte\u001b[39mst",
		],
		[
			"\u001b[97mTest \u001b[91mte\u001b[39mst",
			LFSText.ColorType.ANSI,
			LFSText.ColorType.ANSI,
			"\u001b[97mTest \u001b[91mte\u001b[39mst",
		],
		[
			"[color=#ffffff]Test [/color][color=#ff0000]te[/color]st",
			LFSText.ColorType.ANSI,
			LFSText.ColorType.BBCODE,
			"\u001b[38;2;255;255;255mTest \u001b[38;2;255;0;0mte\u001b[39mst",
		],
		[
			"^7Test ^1te^9st",
			LFSText.ColorType.ANSI,
			LFSText.ColorType.LFS,
			"\u001b[38;2;255;255;255mTest \u001b[38;2;255;0;0mte\u001b[39mst",
		],
		[
			"\u001b[97mTest \u001b[91mte\u001b[39mst",
			LFSText.ColorType.BBCODE,
			LFSText.ColorType.ANSI,
			"[color=#ffffff]Test [/color][color=#ff0000]te[/color]st",
		],
		[
			"[color=#ffffff]Test [/color][color=#ff0000]te[/color]st",
			LFSText.ColorType.BBCODE,
			LFSText.ColorType.BBCODE,
			"[color=#ffffff]Test [/color][color=#ff0000]te[/color]st",
		],
		[
			"^7Test ^1te^9st",
			LFSText.ColorType.BBCODE,
			LFSText.ColorType.LFS,
			"[color=#ffffff]Test [/color][color=#ff0000]te[/color]st",
		],
	]
) -> void:
	var _test := assert_str(LFSText.convert_colors(text, to, from)).is_equal(expected)


@warning_ignore("unused_parameter")
func test_strip_colors(text: String, expected: String, test_parameters := [
	["Test test", "Test test"],
	["^^1^4Test ^^^2test", "^^1Test ^^test"],
	["^^1[color=#0000ff]Test ^^[/color][color=#00ff00]test[/color]", "^^1Test ^^test"],
	["^^1\u001b[94mTest ^^\u001b[92mtest\u001b[39m", "^^1Test ^^test"],
	["^^1^4Test ^^[color=#00ff00]test[/color]", "^^1Test ^^test"],
	["^^1\u001b[94mTest ^^\u001b[m[color=#00ff00]test[/color]", "^^1Test ^^test"],
	["^^1\u001b[94mTest ^^^7[color=#00ff00]test[/color]", "^^1Test ^^test"],
]) -> void:
	var _test: GdUnitAssert = assert_str(LFSText.strip_colors(text)) \
			.is_equal(expected)
#endregion


func test_lfs_string_to_unicode() -> void:
	var _test := assert_str(LFSText.lfs_string_to_unicode("Test string, ASCII only.")) \
			.is_equal("Test string, ASCII only.")
	_test = assert_str(LFSText.lfs_string_to_unicode(
			"Other scripts and special characters^c ^J鏺陻質, ^^a^a^v^d.")) \
			.is_equal("Other scripts and special characters: 日本語, ^^a*|\\.")
	_test = assert_str(LFSText.lfs_string_to_unicode("^Eì ^Cø ^JÏ")) \
			.is_equal("ě ш ﾏ")
	_test = assert_str(LFSText.lfs_string_to_unicode("^72^45 ^7B2^4^JÏ ^1Ayoub")) \
			.is_equal("^72^45 ^7B2^4ﾏ ^1Ayoub")
	_test = assert_str(LFSText.lfs_string_to_unicode("^405 ^J¢^7Ï§^4£ ^7TJ")) \
			.is_equal("^405 ｢^7ﾏｧ^4｣ ^7TJ")
	_test = assert_str(LFSText.lfs_string_to_unicode("^8^1^7^2")) \
			.is_equal("^8^1‹^7—^2›")


func test_unicode_to_lfs_string() -> void:
	var _test := assert_str(LFSText.unicode_to_lfs_string("Test string, ASCII only.")) \
			.is_equal("Test string, ASCII only.")
	# Do not convert escapable characters from unicode to LFS format as they work anyway.
	_test = assert_str(LFSText.unicode_to_lfs_string(
			"Other scripts and special characters: 日本語, ^^a*|\\.")) \
			.is_equal("Other scripts and special characters: ^J鏺陻質, ^^a*|\\.")
	_test = assert_str(LFSText.unicode_to_lfs_string("ě ш ﾏ")) \
			.is_equal("^Eì ^Cø ^JÏ")
	_test = assert_str(LFSText.unicode_to_lfs_string("^72^45 ^7B2^4ﾏ ^1Ayoub")) \
			.is_equal("^72^45 ^7B2^4^JÏ ^1Ayoub")
	_test = assert_str(LFSText.unicode_to_lfs_string("^405 ｢^7ﾏｧ^4｣ ^7TJ")) \
			.is_equal("^405 ^J¢^7Ï§^4£ ^7TJ")
	_test = assert_str(LFSText.unicode_to_lfs_string("/command test")) \
			.is_equal("/command test")
	_test = assert_str(LFSText.unicode_to_lfs_string("/command with a /slash")) \
			.is_equal("/command with a /slash")
	_test = assert_str(LFSText.unicode_to_lfs_string("^8^1‹^7—^2›")) \
			.is_equal("^8^1^7^2")
