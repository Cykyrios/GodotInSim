class_name UCIDMapping
extends RefCounted
## UCID mapping for [InSimMultiButton]
##
## This class contains button data associated with a UCID, for use with [InSimMultiButton],
## which can hold references to multiple UCIDs and the corresponding data with such mappings.

## The UCID this mapping is for.
var ucid := 0
## The click ID for the button associated to this [member ucid].
var click_id := 0
## The number of characters that can be typed in for the button associated to
## this [member ucid]. Note that color codes, code page changes, and multibyte
## characters consume "invisible" characters.
var type_in := 0
## The text displayed by the button associated to this [member ucid].
var text := ""
## The caption for the button associated to this [member ucid].
var caption := ""
## A dirty flag that is used to decide whether the button associated to this
## [member ucid] needs to be sent again.
var dirty_flag := true


## Returns a new [UCIDMapping] created from the data passed in the given parameters.
static func create(
	m_ucid: int, m_click_id: int, m_type_in: int, m_text: String, m_caption: String
) -> UCIDMapping:
	var mapping := UCIDMapping.new()
	mapping.ucid = m_ucid
	mapping.click_id = m_click_id
	mapping.type_in = m_type_in
	mapping.text = m_text
	mapping.caption = m_caption
	return mapping
