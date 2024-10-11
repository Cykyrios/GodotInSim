extends GutTest


func test_lfs_to_unicode() -> void:
	assert_eq(LFSText.lfs_string_to_unicode("Test string, ASCII only."), "Test string, ASCII only.")
	assert_eq(LFSText.lfs_string_to_unicode("Other scripts and special characters^c ^J鏺陻質, ^^a^a^v^d."),
			"Other scripts and special characters: 日本語, ^a*|\\.")
	assert_eq(LFSText.lfs_string_to_unicode("^Eì ^Cø ^JÏ"), "ě ш ﾏ")
	assert_eq(LFSText.lfs_string_to_unicode("^72^45 ^7B2^4^JÏ ^1Ayoub"), "^72^45 ^7B2^4ﾏ ^1Ayoub")
	assert_eq(LFSText.lfs_string_to_unicode("^405 ^J¢^7Ï§^4£ ^7TJ"), "^405 ｢^7ﾏｧ^4｣ ^7TJ")
	assert_eq(LFSText.lfs_string_to_unicode("^8^1^7^2"), "^8^1‹^7—^2›")


func test_unicode_to_lfs() -> void:
	assert_eq(LFSText.unicode_to_lfs_string("Test string, ASCII only."), "Test string, ASCII only.")
	assert_eq(LFSText.unicode_to_lfs_string("Other scripts and special characters: 日本語, ^a*|\\."),
			"Other scripts and special characters^c ^J鏺陻質, ^^a^a^v^d.")
	assert_eq(LFSText.unicode_to_lfs_string("ě ш ﾏ"), "^Eì ^Cø ^JÏ")
	assert_eq(LFSText.unicode_to_lfs_string("^72^45 ^7B2^4ﾏ ^1Ayoub"), "^72^45 ^7B2^4^JÏ ^1Ayoub")
	assert_eq(LFSText.unicode_to_lfs_string("^405 ｢^7ﾏｧ^4｣ ^7TJ"), "^405 ^J¢^7Ï§^4£ ^7TJ")
	assert_eq(LFSText.unicode_to_lfs_string("/command test"), "/command test")
	assert_eq(LFSText.unicode_to_lfs_string("/command with a /slash"), "/command with a ^sslash")
	assert_eq(LFSText.unicode_to_lfs_string("^8^1‹^7—^2›"), "^8^1^7^2")
