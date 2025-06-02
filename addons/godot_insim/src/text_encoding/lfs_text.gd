class_name LFSText
extends RefCounted
## Text encoding utility functions
##
## This class handles text encoding and color conversion from UTF8 to LFS and vice versa.
## Most functions are for internal use only and are called automatically in [InSimPacket] functions.
## [method unicode_to_lfs_string] can be used to get an "intermediate representation", where
## everything is converted, but characters are encoded in UTF16 instead of proper LFS format
## (which removes intermediate zeros).

## The list of color codes used by LFS; also includes the reset code, which resets the cod page
## in addition to the color.
enum ColorCode {
	BLACK,  ## 0
	RED,  ## 1
	GREEN,  ## 2
	YELLOW,  ## 3
	BLUE,  ## 4
	MAGENTA,  ## 5
	CYAN,  ## 6
	WHITE,  ## 7
	RESET,  ## 8 - also resets code page
	DEFAULT,  ## 9 - default color (context-dependent in LFS, gray here)
}
## The color format to use or replace in text strings.
enum ColorType {
	LFS,  ## Use LFS colors (^0 to ^9)
	BBCODE,  ## Use bbcode tags
	ANSI,  ## Use ANSI escape sequences
	STRIP,  ## Remove colors
}

## The list of code pages and their corresponding names.
const CODE_PAGES: Dictionary[String, String] = {
	"^L": "CP1252",
	"^G": "CP1253",
	"^C": "CP1251",
	"^E": "CP1250",
	"^T": "CP1254",
	"^B": "CP1257",
	"^J": "shift-jis",
	"^H": "big5",
	"^S": "gbk",
	"^K": "euc-kr",
	"^8": "CP1252",
}
## The list of escaped characters in LFS strings.
const SPECIAL_CHARACTERS: Dictionary[String, String] = {
	"^a": "*",
	"^c": ":",
	"^d": "\\",
	"^h": "#",
	"^l": "<",
	"^q": "?",
	"^r": ">",
	"^s": "/",
	"^t": '"',
	"^v": "|",
	"^^": "^^",  # parses carets but keeps them, dedoubling occurs separately
}
## The list of colors in LFS text strings.
const COLORS: Array[Color] = [
	Color(0, 0, 0),  ## 0
	Color(1, 0, 0),  ## 1
	Color(0, 1, 0),  ## 2
	Color(1, 1, 0),  ## 3
	Color(0, 0, 1),  ## 4
	Color(1, 0, 1),  ## 5
	Color(0, 1, 1),  ## 6
	Color(1, 1, 1),  ## 7
	Color(0.58, 0.58, 0.58),  ## 8 - also resets code page
	Color(0.58, 0.58, 0.58),  ## 9 - default color (context-dependent in LFS, gray here)
]
## The character used to replace broken characters: �
const FALLBACK_CHARACTER := "\ufffd"

## The list of code page keys, concatenated from [constant CODE_PAGES] and with the leading
## circumflex characters removed.
static var code_pages := "".join(CODE_PAGES.keys()).replace("^", "")
## The list of special characters, concatenated from [constant SPECIAL_CHARACTERS] keys with the
## leading circumflex characters removed.
static var specials := "".join(SPECIAL_CHARACTERS.keys()).replace("^", "")


## Returns the 4-character (maximum) short name corresponding to the mod's [param full_name].
## The logic is custom-made and based on observations from LFS behavior: spaces and underscores
## act as word separators, we take the first letter of each word, and if the name is shorter
## than 4 characters, we add letters from the first word as available, then second word, etc.
## If there are not enough letters, separators are kept (the minimum name length for mods is
## 4 characters, so there will always be 4 characters in the result).
static func car_get_short_name(full_name: String) -> String:
	const LENGTH := 4
	const STRIPPED := "_-"
	if full_name.length() <= LENGTH:
		# Official LFS car (3 chars), 4-char mod name, or an invalid name - returned as is.
		return full_name
	for separator in [" ", "_"] as Array[String]:
		if separator == "_" and full_name.contains(" "):
			continue
		var short_name := ""
		var split_name := full_name.split(separator, false)
		for w in split_name.size():
			var word := split_name[w].lstrip(STRIPPED)
			if word.is_empty():
				continue
			short_name += word[0]
			if short_name.length() >= LENGTH:
				return short_name.left(LENGTH)
		var added_letters := 0
		for w in split_name.size():
			var word := split_name[w].lstrip(STRIPPED)
			for i in word.length():
				if i == 0 or word[i] in STRIPPED:
					continue
				added_letters += 1
				short_name = short_name.insert(w + added_letters, word[i])
				if short_name.length() == LENGTH:
					return short_name
	return full_name.left(LENGTH)


## Converts an LFS-encoded car name to a readable text string, in the 3-letter format for
## official cars (e.g. FBM), or the 6-character hexadecimal code for mods (e.g. DBF12E).
static func car_name_from_lfs_bytes(buffer: PackedByteArray) -> String:
	var is_alphanumeric := func is_alphanumeric(character: int) -> bool:
		var string := String.chr(character)
		if (
			string >= "0" and string <= "9"
			or string >= "A" and string <= "Z"
			or string >= "a" and string <= "z"
		):
			return true
		return false
	var car_name := ""
	if (
		buffer[-1] == 0
		and is_alphanumeric.call(buffer[0])
		and is_alphanumeric.call(buffer[1])
		and is_alphanumeric.call(buffer[2])
	):
		car_name = buffer.get_string_from_utf8()
	else:
		var _discard := buffer.resize(3)
		buffer.reverse()
		car_name = buffer.hex_encode().to_upper()
	return car_name


## Converts a 3-letter car name (e.g. FBM) or a mod's 6-character hexadecimal code
## to the LFS-encoded format.
static func car_name_to_lfs_bytes(car_name: String) -> PackedByteArray:
	var buffer := PackedByteArray([0, 0, 0, 0])
	if car_name.length() not in [3, 6]:
		return buffer
	if car_name.length() == 3:
		for i in car_name.length():
			var utf := car_name[i].to_utf8_buffer()
			buffer[i] = utf[0]
		return buffer
	for i in 3:
		var byte := car_name[2 * i] + car_name[2 * i + 1]
		buffer[2 - i] = byte.hex_to_int()
	return buffer


## Converts ANSI escape sequences to BBCode color tags.
static func colors_ansi_to_bbcode(text: String) -> String:
	var color_is_active := false
	var regex := get_regex_color_ansi()
	var offset := 0
	var output := text
	for result in regex.search_all(output):
		if (
			result.strings[0].ends_with("[39m")
			or result.strings[0].ends_with("[0m")
			or result.strings[0].ends_with("[m")
		):
			var replacement := "[/color]"
			output = regex.sub(output, replacement, false, result.get_start() + offset)
			offset += replacement.length() - result.strings[0].length()
			color_is_active = false
		else:
			var color := COLORS[ColorCode.DEFAULT]
			var group := result.strings[1]
			if group.length() <= 2:
				match result.strings[1]:
					"30":
						color = Color.BLACK
					"31", "91":
						color = Color.RED
					"32", "92":
						color = Color.GREEN
					"33", "93":
						color = Color.YELLOW
					"34", "94":
						color = Color.BLUE
					"35", "95":
						color = Color.MAGENTA
					"36", "96":
						color = Color.CYAN
					"37", "97":
						color = Color.WHITE
			elif group.begins_with("38;2"):
				var components := group.split(";")
				color = Color(
					components[2].to_int() / 255.0,
					components[3].to_int() / 255.0,
					components[4].to_int() / 255.0
				)
			var replacement := "%s[color=#%s]" % [
				"[/color]" if color_is_active else "",
				color.to_html(false),
			]
			output = regex.sub(output, replacement, false, result.get_start() + offset)
			offset += replacement.length() - result.strings[0].length()
			color_is_active = true
	if color_is_active:
		output += "[/color]"
	return output


## Converts BBCode color tags to ANSI escape sequences.
static func colors_bbcode_to_ansi(text: String) -> String:
	var output := text.replace("[/color][color=", "[color=")
	output = output.replace("[/color]", "\u001b[39m")
	var regex := RegEx.create_from_string(r"\[color=#([\dA-Fa-f]{6})\]")
	for result in regex.search_all(output):
		var rgb := Vector3i(
			result.strings[1].substr(0, 2).hex_to_int(),
			result.strings[1].substr(2, 2).hex_to_int(),
			result.strings[1].substr(4, 2).hex_to_int()
		)
		output = regex.sub(output, "\u001b[38;2;%d;%d;%dm" % [rgb.x, rgb.y, rgb.z])
	return output


## Converts BBCode color tags to LFS colors (only works for LFS preset colors, see [enum ColorCode].
static func colors_bbcode_to_lfs(text: String) -> String:
	var output := text.replace("[/color][color=", "[color=")
	output = output.replace("[/color]", "^9")
	var get_color_index := func get_color_index(hex_color: String) -> int:
		for index in COLORS.size():
			if COLORS[index].to_html(false) == hex_color:
				return index
		return 9
	var regex := RegEx.create_from_string(r"\[color=#([A-Fa-f\d]{6})\]")
	var regex_match := regex.search(output)
	while regex_match:
		var color_index := get_color_index.call(regex_match.strings[1]) as int
		output = regex.sub(output, "^%d" % [color_index])
		regex_match = regex.search(output)
	output = output.trim_suffix("^8")
	return output


## Converts LFS colors to BBCode color tags, for displaying text in [RichTextLabel] or html pages.
static func colors_lfs_to_bbcode(text: String) -> String:
	var colored_text := text
	var color_regex := get_regex_color_lfs()
	var regex_match := color_regex.search(colored_text)
	var colors_found := false
	var offset := 0
	while regex_match:
		var replacement := ""
		if regex_match.strings[1] == "^":
			replacement = regex_match.strings[0]
		else:
			var color_index := regex_match.strings[1].to_int()
			if color_index >= 8:
				replacement = "[/color]" if colors_found else ""
				colors_found = false
			else:
				replacement = "%s[color=#%s]" % [
					"[/color]" if colors_found else "",
					COLORS[color_index].to_html(false)
				]
				colors_found = true
			colored_text = color_regex.sub(colored_text, replacement, false, offset)
		offset = regex_match.get_start() + replacement.length()
		regex_match = color_regex.search(colored_text, offset)
	if colors_found:
		colored_text += "[/color]"
	return colored_text


## Converts colors in the given [param text] string to the [param to] color type. If [param to]
## is [constant ColorType.LFS], [method strip_colors] is called instead.
static func convert_colors(text: String, to: ColorType, from := ColorType.LFS) -> String:
	if from == ColorType.STRIP:
		push_warning("LFSText cannot convert colors from no colors!")
		return text
	if to == ColorType.STRIP:
		return strip_colors(text)
	if to == ColorType.ANSI:
		if from == ColorType.ANSI:
			return text
		if from == ColorType.BBCODE:
			return colors_bbcode_to_ansi(text)
		if from == ColorType.LFS:
			return colors_bbcode_to_ansi(colors_lfs_to_bbcode(text))
	elif to == ColorType.BBCODE:
		if from == ColorType.BBCODE:
			return text
		if from == ColorType.ANSI:
			return colors_ansi_to_bbcode(text)
		if from == ColorType.LFS:
			return colors_lfs_to_bbcode(text)
	elif to == ColorType.LFS:
		if from == ColorType.LFS:
			return text
		if from == ColorType.ANSI:
			return colors_bbcode_to_lfs(colors_ansi_to_bbcode(text))
		if from == ColorType.BBCODE:
			return colors_bbcode_to_lfs(text)
	return ""


## Returns a color code string (^0 to ^9).
static func get_color_code(color: ColorCode) -> String:
	return "^%d" % [color]


## Returns the display string version of [param text], with color codes converted to the target
## [param colors] (from LFS colors) and double carets escaped. For instance:
## [codeblock skip-lint]
## LFSText.get_display_string("^^1test ^1red^^")
## # returns "^1test [color=#ff0000]red^[/color]"
## [/codeblock]
static func get_display_string(text: String, colors := ColorType.BBCODE) -> String:
	var output := convert_colors(text, colors)
	return remove_double_carets(output)


## Returns the contents of the message contained in the given [param mso_packet].
static func get_mso_message(mso_packet: InSimMSOPacket, insim: InSim) -> String:
	return mso_packet.msg.substr(get_mso_start(mso_packet, insim))


## Returns the name of the sender of the message contained in the given [param mso_packet].
static func get_mso_sender(mso_packet: InSimMSOPacket, insim: InSim) -> String:
	var sender := "%s %d" % [
		"PLID" if mso_packet.plid else "UCID",
		mso_packet.plid if mso_packet.plid > 0 else mso_packet.ucid
	]
	sender = replace_plid_with_name(
		"PLID %d" % [mso_packet.plid], insim, false
	) if mso_packet.plid else replace_ucid_with_name(
		"UCID %d" % [mso_packet.ucid], insim, false, false
	)
	sender = sender.trim_suffix("^9")
	if not (insim.initialization_data.flags & InSim.InitFlag.ISF_MSO_COLS):
		sender = strip_colors(sender)
	return sender


## Returns the start position of the actual message, since [member InSimMSOPacket.text_start]
## is unreliable when code pages and multi-byte characters appear in the connection/player name
## (LFS issue). [code]/me[/code] messages return [code]0[/code], as the name is part of
## the message for those (same behavior as LFS).
static func get_mso_start(mso_packet: InSimMSOPacket, insim: InSim) -> int:
	if mso_packet.text_start == 0:
		# /me message, always returns 0
		return 0
	var colored_mso := insim.initialization_data.flags & InSim.InitFlag.ISF_MSO_COLS as bool
	var formatting_length := 9 if colored_mso else 3  # length of LFS formatting: "^7 ^7: ^8"
	var sender := get_mso_sender(mso_packet, insim)
	return sender.length() + formatting_length


## Returns a regular expression matching ANSI escape sequences for foreground color.
static func get_regex_color_ansi() -> RegEx:
	return RegEx.create_from_string("\u001b" + r"\[(3\d|9[0-7]|(?:\d|;)*)m")


## Returns a regular expression matching bbcode color tags.
static func get_regex_color_bbcode() -> RegEx:
	return RegEx.create_from_string(r"\[color=#([A-Fa-f\d]+)\](.+?)\[/color\]")


## Returns a regular expression matching LFS color codes ([code]^0[/code] through [code]^9[/code]).
## [br][b]Note:[/b] The expression also matches [code]^^[/code] to prevent false positives
## such as [code]^^1[/code], so results should be filtered accordingly.
static func get_regex_color_lfs() -> RegEx:
	return RegEx.create_from_string(r"\^(\^|\d)")


## Returns a regular expression matching [code]PLID x[/code] where x is a PLID number.
static func get_regex_plid() -> RegEx:
	return RegEx.create_from_string(r"PLID (\d+)")


## Returns a regular expression matching [code]UCID x[/code] where x is a UCID number.
static func get_regex_ucid() -> RegEx:
	return RegEx.create_from_string(r"UCID (\d+)")


## Converts a text string in binary LFS format to a UTF8 string. If [param zero_terminated]
## is true, a zero is appended to the buffer if needed. Double carets [code]^^[/code] do not
## get converted to a single [code]^[/code], which allows to unambiguously make the difference
## between actual caret characters and color escape sequences, but requires futher processing
## for display; you can call [method remove_double_carets] for this purpose.
static func lfs_bytes_to_unicode(bytes: PackedByteArray, zero_terminated := true) -> String:
	# Largely based on Sim Broadcasts' code: https://github.com/simbroadcasts/parse-lfs-message
	var buffer := bytes.duplicate()
	if not zero_terminated or zero_terminated and bytes[-1] != 0:
		var _discard := buffer.append(0)

	var current_code_page := "^L"
	var message := ""
	var block_start := 0
	var block_end := 0

	var skip_next := false
	for i in buffer.size():
		if skip_next:
			skip_next = false
			if i == buffer.size() - 1 and block_start < block_end:
				message += _get_string_from_bytes(buffer.slice(block_start, block_end),
						current_code_page)
			continue
		if buffer[i] == 0:
			if block_start < block_end:
				message += _get_string_from_bytes(buffer.slice(block_start, block_end),
						current_code_page)
			break
		elif _is_multibyte(current_code_page, buffer[i]):
			block_end += 2
			skip_next = true
		elif buffer[i] == 0x5e:  # Found "^"
			var code_page_check := "^%s" % [char(buffer[i + 1])]
			if CODE_PAGES.has(code_page_check):
				if block_start < block_end:
					message += _get_string_from_bytes(buffer.slice(block_start, block_end),
							current_code_page)
				current_code_page = code_page_check
				if buffer[i + 1] == 0x38:
					block_start = i
				else:
					block_start = i + 2
				block_end = i + 2
				skip_next = true
			else:
				block_end += 2
				skip_next = true
		else:
			block_end += 1
	var regex_specials := RegEx.create_from_string(r"\^(.)")
	var results_specials := regex_specials.search_all(message)
	for i in results_specials.size():
		var result := results_specials[results_specials.size() - 1 - i]
		if SPECIAL_CHARACTERS.has(result.strings[0]):
			message = regex_specials.sub(message, SPECIAL_CHARACTERS[result.strings[0]],
					false, result.get_start())
	return message


## Convert the intermediate string representation of LFS text to UTF8. You should only need
## to use [method lfs_bytes_to_unicode] or [method unicode_to_lfs_bytes] for text conversion.
static func lfs_string_to_unicode(text: String) -> String:
	var buffer := text.to_utf16_buffer()
	var _discard := buffer.append(0)
	var buffer_size := buffer.size()
	var i := 0
	while i < buffer_size - (0 if (buffer_size % 2 == 0) else 1):
		var value_1 := buffer[i]
		var value_2 := buffer[i + 1]
		if value_1 != 0 and value_2 != 0:
			buffer[i] = value_2
			buffer[i + 1] = value_1
		i += 2
	buffer = _remove_inner_zeros(buffer)
	return lfs_bytes_to_unicode(buffer)


## Replaces double carets [code]^^[/code] with a single one. This is meant as a final cleanup step
## before displaying a string converted from LFS as obtained from [method lfs_bytes_to_unicode],
## which keeps double carets to avoid ambiguity between caret characters and color escape codes.
static func remove_double_carets(text: String) -> String:
	var regex := RegEx.create_from_string(r"\^\^")
	return regex.sub(text, "^", true)


## Replaces all occurrences, in the given [param text], of [code]PLID #[/code],
## where [code]#[/code] is a number, with the corresponding player names.
## If [param reset_color] is [code]true[/code], [code]^9[/code] is appended to the names.
static func replace_plid_with_name(text: String, insim: InSim, reset_color := true) -> String:
	var output := text
	var regex := LFSText.get_regex_plid()
	var results := regex.search_all(text)
	for i in results.size():
		var result := results[results.size() - 1 - i]
		var plid := result.strings[1] as int
		var player_found := insim.players.has(plid)
		if not player_found:
			push_error("Failed to convert PLID %d, list is %s" % [plid, insim.players.keys()])
		var player_name := (
			(insim.players[plid].player_name + get_color_code(ColorCode.DEFAULT)) if player_found \
			else ("^%d%s%s" % [
				LFSText.ColorCode.RED,
				result.strings[0],
				get_color_code(ColorCode.DEFAULT) if reset_color else "",
			])
		)
		output = regex.sub(output, player_name, false, result.get_start())
	return output


## Replaces all occurrences, in the given [param text], of [code]UCID #[/code],
## where [code]#[/code] is a number, with the corresponding connection names.
## If [param reset_color] is [code]true[/code], [code]^9[/code] is appended to the names.
static func replace_ucid_with_name(
	text: String, insim: InSim, include_username := false, reset_color := true
) -> String:
	var output := text
	var regex := LFSText.get_regex_ucid()
	var results := regex.search_all(text)
	for i in results.size():
		var result := results[results.size() - 1 - i]
		var ucid := result.strings[1] as int
		var connection: Connection = insim.connections[ucid] if insim.connections.has(ucid) \
				else null
		if not connection:
			push_error("Failed to convert UCID %d, list is %s" % [ucid, insim.connections.keys()])
		var nickname := (
			(connection.nickname + (get_color_code(ColorCode.DEFAULT) if reset_color else "")) \
			if connection else ("^%d%s%s" % [
				LFSText.COLORS[LFSText.ColorCode.RED],
				result.strings[0],
				get_color_code(ColorCode.DEFAULT) if reset_color else "",
			])
		)
		output = regex.sub(output, "%s%s" % [
			nickname,
			"" if connection.username.is_empty() or not include_username \
			else " (%s)" % [connection.username]
		], false, result.get_start())
	return output


## Splits the given [param message] and returns an array of 2 strings, with the first one
## being trimmed to [param max_length] ([PackedByteArray] length after converting to LFS bytes)
## and moving characters broken by the trim to the second string, which contains the rest
## of the [param message], with the last used color code prepended to it.
static func split_message(message: String, max_length: int) -> Array[String]:
	var message_buffer := LFSText.unicode_to_lfs_bytes(message)
	var first_buffer := message_buffer.slice(0, max_length - 1)
	var first_message := LFSText.lfs_bytes_to_unicode(first_buffer)
	if (
		first_buffer[-1] == 94
		and first_buffer[-2] != 94
		and first_message.ends_with("^")
	):
		first_message = first_message.trim_suffix("^")
	var size := first_message.find(LFSText.FALLBACK_CHARACTER)
	if size != -1:
		first_message = first_message.left(size)
	var second_message := message.right(
		message.length() - (first_message.length() if size == -1 else size)
	)
	if not(
		second_message[0] == "^"
		and char(second_message.unicode_at(1)) >= "0"
		and char(second_message.unicode_at(1)) <= "9"
	):
		var last_color := ""
		var color_results := LFSText.get_regex_color_lfs().search_all(first_message)
		if not color_results.is_empty():
			for i in color_results.size():
				if color_results[i].strings[0] != "^^":
					last_color = color_results[-1].strings[0]
					second_message = last_color + second_message
					break
	second_message = second_message.trim_prefix("^8").trim_prefix("^9")
	return [first_message, second_message]


## Removes all colors from [param text], including LFS colors, BBCode tags and ANSI sequences.
static func strip_colors(text: String) -> String:
	var result := text
	var regex := get_regex_color_lfs()
	var regex_match := regex.search(result)
	var offset := 0
	while regex_match:
		if regex_match.strings[0].substr(1, 1) == "^":
			offset = regex_match.get_start() + regex_match.strings[0].length()
			regex_match = regex.search(result, offset)
			continue
		result = regex.sub(result, "", false, offset)
		offset = regex_match.get_start()
		regex_match = regex.search(result, offset)
	regex = get_regex_color_bbcode()
	regex_match = regex.search(result)
	while regex_match:
		result = regex.sub(result, regex_match.strings[2])
		regex_match = regex.search(result)
	regex = get_regex_color_ansi()
	regex_match = regex.search(result)
	while regex_match:
		result = regex.sub(result, "")
		regex_match = regex.search(result)
	return result


## Converts [param text] from UTF8 to LFS encoding as a [PackedByteArray]. If [param keep_utf16] is
## true, the array can be converted back to text as UTF16.[br]
## Invalid escape sequences replace the single caret with 2 (LFS displays a single ^).
## For instance, if [param text] is [code]^b[/code], it will be read as [code]^^b[/code] and the
## resulting buffer will be [code][94, 94, 98][/code].
static func unicode_to_lfs_bytes(text: String, keep_utf16 := false) -> PackedByteArray:
	# Largely based on Sim Broadcasts' code: https://github.com/simbroadcasts/unicode-to-lfs
	var page := "L"
	var message := _escape_circumflex(text)
	# The color + code page reset (^8) should not be sent from unicode, so we replace it with ^9,
	# which also resets color. Code page changes are handled purely based on found characters.
	message = message.replace("^8", "^9")
	var buffer := PackedByteArray()
	for i in message.length():
		if message.unicode_at(i) < 128:
			buffer.append_array(message[i].to_utf16_buffer())
			continue
		var temp_bytes := _get_bytes_from_string(message.unicode_at(i), page, keep_utf16)
		if not temp_bytes.is_empty():
			buffer.append_array(temp_bytes)
		else:
			var code_page_found := false
			for code_page: String in CODE_PAGES.keys():
				temp_bytes = _get_bytes_from_string(message.unicode_at(i), code_page.substr(1, 1),
						keep_utf16)
				if not temp_bytes.is_empty():
					code_page_found = true
					page = code_page.substr(1, 1)
					buffer.append_array(code_page.to_utf16_buffer())
					buffer.append_array(temp_bytes)
					break
			if not code_page_found:
				buffer.append_array(_translate_specials(FALLBACK_CHARACTER).to_utf16_buffer())
	if not keep_utf16:
		buffer = _remove_inner_zeros(buffer)
	if buffer.is_empty():
		buffer = [0]
	return buffer


## Returns an intermediate representation of [param text] in UTF16, ready to be converted to LFS
## format by removing intermediate zeros.
static func unicode_to_lfs_string(text: String) -> String:
	return unicode_to_lfs_bytes(text, true).get_string_from_utf16()


static func _escape_circumflex(text: String) -> String:
	var regex := RegEx.create_from_string(r"(?<!\^)\^(?![\d%s\^])" % [specials])
	return regex.sub(text, "^^", true)


static func _get_bytes_from_string(
	code: int, code_page: String, keep_utf16: bool
) -> PackedByteArray:
	if not LFSCodePages.CODE_PAGE_TABLES.has(code_page):
		return []
	for key: String in LFSCodePages.CODE_PAGE_TABLES.keys():
		if key.begins_with(code_page):
			var page_table := LFSCodePages.CODE_PAGE_TABLES[key] as Dictionary
			for i in page_table.values().size():
				if page_table.values()[i] == code:
					var encoded_code := page_table.keys()[i] as int
					var high_byte := encoded_code >> 8
					var low_byte := encoded_code - (high_byte << 8)
					if keep_utf16:
						return PackedByteArray([low_byte, high_byte])
					if high_byte == 0:
						return PackedByteArray([low_byte])
					return PackedByteArray([high_byte, low_byte])
	return []


static func _get_string_from_bytes(buffer: PackedByteArray, code_page: String) -> String:
	var text := ""
	var page := code_page
	# Workaround for ^8 implying ^L (both represent CP1252)
	if page == "^8":
		page = "^L"
	if page.length() > 1:
		page = page.substr(1, 1)

	var skip_next := false
	for i in buffer.size():
		if skip_next:
			skip_next = false
			continue
		if buffer[i] < 128:
			text += char(buffer[i])
			continue
		if LFSCodePages.CODE_PAGE_TABLES.has(page):
			var page_dict := LFSCodePages.CODE_PAGE_TABLES[page] as Dictionary
			if page_dict.has(buffer[i]):
				text += char(page_dict[buffer[i]] as int)
				continue
		var sub_page := "%s%d" % [page, buffer[i]]
		if LFSCodePages.CODE_PAGE_TABLES.has(sub_page) and i < buffer.size() - 1:
			var sub_code := (buffer[i] << 8) + buffer[i + 1]
			if (LFSCodePages.CODE_PAGE_TABLES[sub_page] as Dictionary).has(sub_code):
				text += char(LFSCodePages.CODE_PAGE_TABLES[sub_page][sub_code] as int)
				skip_next = true
			else:
				text += FALLBACK_CHARACTER
		else:
			text += FALLBACK_CHARACTER
	return text


static func _is_multibyte(code_page: String, character: int) -> bool:
	match code_page:
		"^L", "^8", "^G", "^C", "^E", "^T", "^B":
			return false
		"^J":
			return (
				character > 0x80 and character < 0xa0
				or character >= 0xe0 and character < 0xfd
			)
		"^H", "^S", "^K":
			return character > 0x80 and character < 0xff
		_:
			push_error("Code page unknown: %s" % [character])
	return false


static func _remove_inner_zeros(buffer: PackedByteArray) -> PackedByteArray:
	var cleaned_buffer := buffer.duplicate()
	var idx := 0
	while idx < cleaned_buffer.size():
		if cleaned_buffer[-1 - idx] == 0:
			cleaned_buffer.remove_at(cleaned_buffer.size() - 1 - idx)
		idx += 1
	return cleaned_buffer


static func _translate_specials(text: String) -> String:
	var message := text
	for i in SPECIAL_CHARACTERS.size():
		message = message.replace(str(SPECIAL_CHARACTERS.values()[i]),
				str(SPECIAL_CHARACTERS.keys()[i]))
	return message
