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
