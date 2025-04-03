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


func test_get_color_code() -> void:
	var _test := assert_str(LFSText.get_color_code(LFSText.ColorCode.BLACK)).is_equal("^0")
	_test = assert_str(LFSText.get_color_code(LFSText.ColorCode.RED)).is_equal("^1")
	_test = assert_str(LFSText.get_color_code(LFSText.ColorCode.GREEN)).is_equal("^2")
	_test = assert_str(LFSText.get_color_code(LFSText.ColorCode.YELLOW)).is_equal("^3")
	_test = assert_str(LFSText.get_color_code(LFSText.ColorCode.BLUE)).is_equal("^4")
	_test = assert_str(LFSText.get_color_code(LFSText.ColorCode.MAGENTA)).is_equal("^5")
	_test = assert_str(LFSText.get_color_code(LFSText.ColorCode.CYAN)).is_equal("^6")
	_test = assert_str(LFSText.get_color_code(LFSText.ColorCode.WHITE)).is_equal("^7")
	_test = assert_str(LFSText.get_color_code(LFSText.ColorCode.RESET)).is_equal("^8")
	_test = assert_str(LFSText.get_color_code(LFSText.ColorCode.DEFAULT)).is_equal("^9")


@warning_ignore("unused_parameter")
func test_get_display_string(
	text: String, colors: LFSText.ColorType, expected: String, test_parameters := [
		[
			"",
			LFSText.ColorType.BBCODE,
			"",
		],
		[
			"^",
			LFSText.ColorType.BBCODE,
			"^",
		],
		[
			"^^",
			LFSText.ColorType.BBCODE,
			"^",
		],
		[
			"^1",
			LFSText.ColorType.ANSI,
			"\u001b[38;2;255;0;0m\u001b[39m",
		],
		[
			"^1",
			LFSText.ColorType.BBCODE,
			"[color=#ff0000][/color]",
		],
		[
			"^1Test \u001b[97mtest\u001b[39m",
			LFSText.ColorType.BBCODE,
			"[color=#ff0000]Test \u001b[97mtest\u001b[39m[/color]",
		],
		[
			"^^^1R^^^2G^^^4B^^^9^",
			LFSText.ColorType.BBCODE,
			"^[color=#ff0000]R^[/color][color=#00ff00]G^[/color][color=#0000ff]B^[/color]^",
		],
	]
) -> void:
	var _test := assert_str(LFSText.get_display_string(text, colors)).is_equal(expected)


@warning_ignore("unused_parameter")
func test_strip_colors(text: String, expected: String, test_parameters := [
	[
		"Test test",
		"Test test",
	],
	[
		"^^1^4Test ^^^2test",
		"^^1Test ^^test",
	],
	[
		"^^1[color=#0000ff]Test ^^[/color][color=#00ff00]test[/color]",
		"^^1Test ^^test",
	],
	[
		"^^1\u001b[94mTest ^^\u001b[92mtest\u001b[39m",
		"^^1Test ^^test",
	],
	[
		"^^1^4Test ^^[color=#00ff00]test[/color]",
		"^^1Test ^^test",
	],
	[
		"^^1\u001b[94mTest ^^\u001b[m[color=#00ff00]test[/color]",
		"^^1Test ^^test",
	],
	[
		"^^1\u001b[94mTest ^^^7[color=#00ff00]test[/color]",
		"^^1Test ^^test",
	],
]) -> void:
	var _test: GdUnitAssert = assert_str(LFSText.strip_colors(text)).is_equal(expected)
#endregion


@warning_ignore("unused_parameter")
func test_get_mso_start(player_name: String, message: String, test_parameters := [
	["Player", "Message"],
	["Nick\\^^name", "Message"],
	["^1red^7白white", "Message"],
]) -> void:
	const UCID := 1
	const PLID := 2
	var insim := auto_free(InSim.new()) as InSim
	var connection := Connection.new()
	connection.nickname = player_name
	insim.connections = {UCID: connection}
	var player := Player.new()
	player.player_name = player_name
	player.ucid = UCID
	insim.players = {PLID: player}
	for i in 3:  # Send via UCID, then via PLID, then /me via PLID
		var expected := message if i < 2 else "%s ^8%s" % [player_name, message]
		var mso := InSimMSOPacket.new()
		mso.ucid = UCID
		mso.plid = PLID if i > 0 else 0
		mso.msg = ("^7%s ^7: ^8%s" if i < 2 else "%s ^8%s") % [player_name, message]
		mso.text_start = 1 if i < 2 else 0
		var _test := assert_str(mso.msg.substr(LFSText.get_mso_start(mso, insim))) \
				.is_equal(expected)


#region unicode/LFS
@warning_ignore("unused_parameter")
func test_lfs_string_to_unicode(text: String, expected: String, test_parameters := [
	[
		"Test string, ASCII only.",
		"Test string, ASCII only.",
	],
	[
		"Other scripts and special characters^c ^J鏺陻質, ^^a^a^v^d.",
		"Other scripts and special characters: 日本語, ^^a*|\\.",
	],
	[
		"^Eì ^Cø ^JÏ",
		"ě ш ﾏ",
	],
	[
		"^72^45 ^7B2^4^JÏ ^1Ayoub",
		"^72^45 ^7B2^4ﾏ ^1Ayoub",
	],
	[
		"^405 ^J¢^7Ï§^4£ ^7TJ",
		"^405 ｢^7ﾏｧ^4｣ ^7TJ",
	],
	[
		"^8^1^7^2",
		"^8^1‹^7—^2›",
	],
]) -> void:
	var _test := assert_str(LFSText.lfs_string_to_unicode(text)).is_equal(expected)


@warning_ignore("unused_parameter")
func test_unicode_to_lfs_string(text: String, expected: String, test_parameters := [
	[
		"Test string, ASCII only.",
		"Test string, ASCII only.",
	],
	[
		# Do not convert escapable characters from unicode to LFS format as they work anyway.
		"Other scripts and special characters: 日本語, ^^a*|\\.",
		"Other scripts and special characters: ^J鏺陻質, ^^a*|\\.",
	],
	[
		"ě ш ﾏ",
		"^Eì ^Cø ^JÏ",
	],
	[
		"^72^45 ^7B2^4ﾏ ^1Ayoub",
		"^72^45 ^7B2^4^JÏ ^1Ayoub",
	],
	[
		"^405 ｢^7ﾏｧ^4｣ ^7TJ",
		"^405 ^J¢^7Ï§^4£ ^7TJ",
	],
	[
		"/command test",
		"/command test",
	],
	[
		"/command with a /slash",
		"/command with a /slash",
	],
	[
		"^8^1‹^7—^2›",
		"^9^1^7^2",
	],
]) -> void:
	var _test := assert_str(LFSText.unicode_to_lfs_string(text)).is_equal(expected)


func test_code_page_reset() -> void:
	# Color + code page reset ^8 should be replaced with simply color reset ^9.
	var _test := assert_str(
		LFSText.lfs_bytes_to_unicode(LFSText.unicode_to_lfs_bytes("夢^8夢"))
	).is_equal("夢^9夢")
#endregion


func test_replace_plid_with_name() -> void:
	var insim := auto_free(InSim.new()) as InSim
	var player_1 := Player.new()
	player_1.player_name = "Player ^71"
	var player_2 := Player.new()
	player_2.player_name = "Second ^^Player^^"
	var player_9 := Player.new()
	player_9.player_name = "Skipped ^1PLIDs"
	insim.players = {
		1: player_1,
		2: player_2,
		9: player_9,
	}
	var _test := assert_str(
		LFSText.replace_plid_with_name("Players: PLID 1, PLID 2, PLID 9", insim)
	).is_equal("Players: Player ^71, Second ^^Player^^, Skipped ^1PLIDs")


func test_replace_ucid_with_name() -> void:
	var insim := auto_free(InSim.new()) as InSim
	var connection_1 := Connection.new()
	connection_1.nickname = "Player ^71"
	connection_1.username = "SuperPlayer"
	var connection_2 := Connection.new()
	connection_2.nickname = "Second ^^Player^^"
	connection_2.username = "TestPlayer"
	var connection_9 := Connection.new()
	connection_9.nickname = "Skipped ^1PLIDs"
	connection_9.username = "AnotherPlayer"
	insim.connections = {
		1: connection_1,
		2: connection_2,
		9: connection_9,
	}
	var _test := assert_str(
		LFSText.replace_ucid_with_name("Connections: UCID 1, UCID 2, UCID 9", insim, false)
	).is_equal("Connections: Player ^71, Second ^^Player^^, Skipped ^1PLIDs")
	_test = assert_str(
		LFSText.replace_ucid_with_name("Connections: UCID 1, UCID 2, UCID 9", insim, true)
	).is_equal("Connections: Player ^71 (SuperPlayer), Second ^^Player^^ (TestPlayer), " \
			+ "Skipped ^1PLIDs (AnotherPlayer)")


@warning_ignore("unused_parameter")
func test_split_message(
	message: String, max_length: int, expected_first: String, expected_second: String,
	test_parameters := [
		[
			"123456  10  3456  20  3456  30",
			25,
			"123456  10  3456  20  34",
			"56  30",
		],
		[
			# Colors should be retained between messages
			"123456  10  3^56  20  3456  30",
			25,
			"123456  10  3^56  20  34",
			"^556  30",
		],
		[
			# Colors should be retained between messages
			"123456  10  3456  20  ^456  30",
			25,
			"123456  10  3456  20  ^4",
			"^456  30",
		],
		[
			# Color end (^9) should not appear in the second message
			"123456  10  3^56  ^9  3456  30",
			25,
			"123456  10  3^56  ^9  34",
			"56  30",
		],
		[
			# Single carets should not appear at the end of the first message
			"123456  10  3456  20  3^56  30",
			25,
			"123456  10  3456  20  3",
			"^56  30",
		],
		[
			# Characters from different code pages should safely move from first to second message
			"123456  10  3456  20  あいうえお 6  40",
			25,
			"123456  10  3456  20  ",
			"あいうえお 6  40",
		],
		[
			# Multi-byte characters should safely move from first to second message
			"123456  10  3456  20あいうえお  56  40",
			25,
			"123456  10  3456  20あ",
			"いうえお  56  40",
		],
	]
) -> void:
	var messages := LFSText.split_message(message, max_length)
	var _test := assert_str(messages[0]).is_equal(expected_first)
	_test = assert_str(messages[1]).is_equal(expected_second)
