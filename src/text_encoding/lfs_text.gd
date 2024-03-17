class_name LFSText
extends RefCounted


enum ColorCode {BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE}

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

const COLORS := [
	Color(0, 0, 0),
	Color(1, 0, 0),
	Color(0, 1, 0),
	Color(1, 1, 0),
	Color(0, 0, 1),
	Color(1, 0, 1),
	Color(0, 1, 1),
	Color(1, 1, 1),
]

const FALLBACK_CHARACTER := "?"


static func is_multibyte(code_page: String, char: int) -> bool:
	match code_page:
		"^L", "^8", "^G", "^C", "^E", "^T", "^B":
			return false
		"^J":
			return (char > 0x80 and char < 0xa0) or (char >= 0xe0 and char < 0xfd)
		"^H", "^S", "^K":
			return char > 0x80 and char < 0xff
		_:
			push_error("Code page unknown: %s" % [char])
	return false


static func parse_lfs_message(buffer: PackedByteArray) -> String:
	var current_code_page := "^L"
	var message := ""
	var block_start := 0
	var block_end := 0

	for i in buffer.size():
		if buffer[i] == 0:
			if block_start < block_end:
				#message +=
				pass
			break
		elif is_multibyte(current_code_page, buffer[i]):
			block_end += 2
			i += 1  # WARNING: this may not work (for loop probably creates an array)
		elif buffer[i] == 0x5e:
			pass
		else:
			block_end += 1
	for special_character in SPECIAL_CHARACTERS:
		var regexp := RegEx.create_from_string("^%s" % [special_character])
		regexp.sub(message, SPECIAL_CHARACTERS[special_character], true)
	message = message.replace("^^", "^")
	return message


static func get_string_from_bytes(buffer: PackedByteArray, code_page: String) -> String:
	var text := ""
	var page := code_page
	if page.length() > 1:
		page = page.substr(1, 1)

	var skip_next := false
	for i in buffer.size():
		if skip_next:
			skip_next = false
			continue
		if buffer[i] < 128:
			text += String.chr(buffer[i])
			continue
		var sub_page := "%s%d" % [page, buffer[i]]
		if LFSCodePages.CODE_PAGE_TABLES.has(sub_page):
			if LFSCodePages.CODE_PAGE_TABLES[sub_page].has(buffer[i + 1]):
				text += String.chr(LFSCodePages.CODE_PAGE_TABLES[sub_page][buffer[i + 1]])
			else:
				text += "?"
		elif LFSCodePages.CODE_PAGE_TABLES.has(page):
			text += String.chr(LFSCodePages.CODE_PAGE_TABLES[page][buffer[i]])
		else:
			text += "?"
	return text


static func get_bytes_from_string(code: int, code_page: String) -> PackedByteArray:
	if not LFSCodePages.CODE_PAGE_TABLES.has(code_page):
		return []
	for key in LFSCodePages.CODE_PAGE_TABLES.keys():
		if (key as String).begins_with(code_page):
			var page_table := LFSCodePages.CODE_PAGE_TABLES[key] as Dictionary
			for i in page_table.values().size():
				if page_table.values()[i] == code:
					var encoded_code := page_table.keys()[i] as int
					var high_byte := encoded_code >> 8
					var low_byte := encoded_code - (high_byte << 8)
					return PackedByteArray([low_byte, high_byte])
	return []


static func lfs_bytes_to_unicode(buffer: PackedByteArray) -> String:
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
				message += get_string_from_bytes(buffer.slice(block_start, block_end), current_code_page)
			break
		elif is_multibyte(current_code_page, buffer[i]):
			block_end += 2
			skip_next = true
		elif buffer[i] == 0x5e:
			# Found "^"
			var code_page_check := "^%s" % [String.chr(buffer[i + 1])]
			if CODE_PAGES.has(code_page_check):
				if block_start < block_end:
					message += get_string_from_bytes(buffer.slice(block_start, block_end), current_code_page)
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
		var regexp := RegEx.create_from_string("\\%s" % [SPECIAL_CHARACTERS.keys()[i]])
		message = regexp.sub(message, SPECIAL_CHARACTERS.values()[i], true)
	message = message.replace("^^", "^")
	return message


static func translate_specials(text: String) -> String:
	var message := text
	for i in SPECIAL_CHARACTERS.size():
		message = message.replace(SPECIAL_CHARACTERS.values()[i], SPECIAL_CHARACTERS.keys()[i])
	return message


static func unicode_to_lfs_bytes(text: String) -> PackedByteArray:
	var page := "L"
	var message := translate_specials(text)
	var buffer := PackedByteArray()
	for i in message.length():
		if message.unicode_at(i) < 128:
			buffer.append_array(message[i].to_utf16_buffer())
			continue
		var temp_bytes := get_bytes_from_string(message.unicode_at(i), page)
		if not temp_bytes.is_empty():
			buffer.append_array(temp_bytes)
		else:
			var code_page_found := false
			for code_page: String in CODE_PAGES.keys():
				temp_bytes = get_bytes_from_string(message.unicode_at(i), code_page.substr(1, 1))
				if not temp_bytes.is_empty():
					code_page_found = true
					page = code_page.substr(1, 1)
					buffer.append_array(code_page.to_utf16_buffer())
					buffer.append_array(temp_bytes)
					break
			if not code_page_found:
				buffer.append_array(translate_specials(FALLBACK_CHARACTER).to_utf16_buffer())
	return buffer


static func unicode_to_lfs_string(text: String) -> String:
	return unicode_to_lfs_bytes(text).get_string_from_utf16()
