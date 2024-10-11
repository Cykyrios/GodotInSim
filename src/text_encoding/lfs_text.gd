class_name LFSText
extends RefCounted

## Text encoding utility class
##
## This class handles text encoding and color conversion from UTF8 to LFS and vice versa.
## Most functions are for internal use only and are called automatically in [InSimPacket] functions.
## [method unicode_to_lfs_string] can be used to get an "intermediate representation", where
## everything is converted, but characters are encoded in UTF16 instead of proper LFS format
## (which removes intermediate zeros).

enum ColorCode {BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE, DEFAULT}

const CODE_PAGES := {
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
const SPECIAL_CHARACTERS := {
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
}
const COLORS: Array[Color] = [
	Color(0, 0, 0),
	Color(1, 0, 0),
	Color(0, 1, 0),
	Color(1, 1, 0),
	Color(0, 0, 1),
	Color(1, 0, 1),
	Color(0, 1, 1),
	Color(1, 1, 1),
	Color(0.58, 0.58, 0.58),
]
const FALLBACK_CHARACTER := "?"


## Converts BBCode color tags to LFS colors (only works for LFS preset colors, see [enum ColorCode].
static func bbcode_to_lfs_colors(text: String) -> String:
	var lfs_text := text
	var regex := RegEx.create_from_string(r"(?U)(?:\^[89])?\[color=#([A-Fa-f0-9]+)\](.+)\[/color\]")
	var regex_match := regex.search(lfs_text)
	var get_color_index := func get_color_index(hex_color: String) -> int:
		for index in COLORS.size():
			if COLORS[index].to_html(false) == hex_color:
				return index
		return COLORS.size()
	while regex_match:
		var color_index := get_color_index.call(regex_match.strings[1]) as int
		lfs_text = regex.sub(lfs_text, "^%d%s^8" % [color_index, regex_match.strings[2]])
		regex_match = regex.search(lfs_text)
	lfs_text = lfs_text.trim_suffix("^8")
	return lfs_text


## Converts a text string in binary LFS format to a UTF8 string.
static func lfs_bytes_to_unicode(bytes: PackedByteArray, zero_terminated := true) -> String:
	# Largely based on Sim Broadcasts' code: https://github.com/simbroadcasts/parse-lfs-message
	var buffer := bytes.duplicate()
	if not zero_terminated:
		var _discard := buffer.append(0)

	var current_code_page := "^L"
	var message := ""
	var block_start := 0
	var block_end := 0

	var skip_next := false
	for i in buffer.size():
		if skip_next:
			skip_next = false
			continue
		if buffer[i] == 0:
			if block_start < block_end:
				message += _get_string_from_bytes(buffer.slice(block_start, block_end), current_code_page)
			break
		elif _is_multibyte(current_code_page, buffer[i]):
			block_end += 2
			skip_next = true
		elif buffer[i] == 0x5e:
			# Found "^"
			var code_page_check := "^%s" % [char(buffer[i + 1])]
			if CODE_PAGES.has(code_page_check):
				if block_start < block_end:
					message += _get_string_from_bytes(buffer.slice(block_start, block_end), current_code_page)
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
	for i in SPECIAL_CHARACTERS.size():
		var regexp := RegEx.create_from_string(r"(?<!\^)\%s" % [SPECIAL_CHARACTERS.keys()[i]])
		message = regexp.sub(message, SPECIAL_CHARACTERS.values()[i] as String, true)
	message = message.replace("^^", "^")
	return message


## Converts LFS colors to BBCode color tags, for displaying text in [RichTextLabel] or html pages.
static func lfs_colors_to_bbcode(text: String) -> String:
	var colored_text := text
	var color_regex := RegEx.create_from_string(r"\^\d")
	var regex_match := color_regex.search(colored_text)
	var colors_found := false
	while regex_match:
		var color_index := regex_match.strings[0].right(1).to_int()
		if color_index >= 8:
			colored_text = color_regex.sub(colored_text, "[/color]" if colors_found else "")
			colors_found = false
		else:
			colored_text = color_regex.sub(colored_text,
					"%s[color=#%s]" % ["[/color]" if colors_found else "",
					COLORS[color_index].to_html(false)])
			colors_found = true
		regex_match = color_regex.search(colored_text)
	if colors_found:
		colored_text += "[/color]"
	return colored_text


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


## Removes all colors from [param text], including LFS colors and BBCode tags.
static func strip_colors(text: String) -> String:
	var result := text
	var regex := RegEx.create_from_string(r"\^\d")
	var regex_match := regex.search(result)
	while regex_match:
		var color_code := regex_match.strings[0].substr(1, 1).to_int()
		result = regex.sub(result, "^L" if color_code == 9 else "")
		regex_match = regex.search(result)
	regex = RegEx.create_from_string(r"(?U)\[color=#[A-Fa-f0-9]\](.+)\[/color\]")
	regex_match = regex.search(result)
	while regex_match:
		result = regex.sub(result, regex_match.strings[1])
		regex_match = regex.search(result)
	return result


## Converts [param text] from UTF8 to LFS encoding as a [PackedByteArray]. If [param keep_utf16] is
## true, the array can be converted back to text as UTF16.
static func unicode_to_lfs_bytes(text: String, keep_utf16 := false) -> PackedByteArray:
	# Largely based on Sim Broadcasts' code: https://github.com/simbroadcasts/unicode-to-lfs
	var page := "L"
	var message := _translate_specials(_escape_circumflex(text))
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
				temp_bytes = _get_bytes_from_string(message.unicode_at(i), code_page.substr(1, 1), keep_utf16)
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
	return buffer


## Returns an intermediate representation of [param text] in UTF16, ready to be converted to LFS
## format by removing intermediate zeros.
static func unicode_to_lfs_string(text: String) -> String:
	return unicode_to_lfs_bytes(text, true).get_string_from_utf16()


static func _escape_circumflex(text: String) -> String:
	var regex := RegEx.create_from_string(r"\^(?!\d)")
	return regex.sub(text, "^^", true)


static func _get_bytes_from_string(code: int, code_page: String, keep_utf16: bool) -> PackedByteArray:
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
			return (character > 0x80 and character < 0xa0) or (character >= 0xe0 and character < 0xfd)
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
	# Keep "basic" slash (U+2F) at beginning of message so it can be interpreted
	# as an LFS command instead of text. This should not affect text representation otherwise.
	if message.begins_with(str(SPECIAL_CHARACTERS.keys()[SPECIAL_CHARACTERS.values().find("/")])):
		message = "/" + message.substr(2)
	return message


static func _unescape_circumflex(text: String) -> String:
	var result := text
	return result
