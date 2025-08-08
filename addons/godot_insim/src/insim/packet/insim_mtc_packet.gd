class_name InSimMTCPacket
extends InSimPacket
## Msg To Connection packet - hosts only - send to a connection / a player / all
##
## This packet is sent by the host to display a message to a specific [Connection] or [Player],
## or to everyone.

const PACKET_MIN_SIZE := 12  ## Minimum packet size
const PACKET_MAX_SIZE := 136  ## Maximum packet size
const PACKET_TYPE := InSim.Packet.ISP_MTC  ## The packet's type, see [enum InSim.Packet].
## Maximum message length
const TEXT_MAX_LENGTH := 128  # last byte must be zero, actual length is one character shorter

var sound := InSim.MessageSound.SND_SILENT  ## Sound effect (see [enum InSim.MessageSound])

var ucid := 0  ## Connection's unique id (0 = host / 255 = all)
var plid := 0  ## Player's unique id (if zero, use [member ucid])

var text := ""  ## Message contents, up to 128 characters of text - last byte must be zero.


## Creates and returns a new [InSimMTCPacket] from the given parameters.
static func create(
	mtc_ucid: int, mtc_plid: int, mtc_text: String, mtc_sound := InSim.MessageSound.SND_SILENT
) -> InSimMTCPacket:
	var packet := InSimMTCPacket.new()
	packet.sound = mtc_sound
	packet.ucid = mtc_ucid
	packet.plid = mtc_plid
	packet.text = mtc_text
	return packet


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	if InSim.MessageSound.values().find(sound) == -1:
		sound = InSim.MessageSound.SND_SILENT
	add_byte(sound)
	add_byte(ucid)
	add_byte(plid)
	add_byte(0)  # sp2
	add_byte(0)  # sp3
	text = LFSText.lfs_bytes_to_unicode(add_string_variable_length(
			text, TEXT_MAX_LENGTH, INSIM_SIZE_MULTIPLIER))
	_trim_packet_size()


func _get_data_dictionary() -> Dictionary:
	return {
		"Sound": sound,
		"UCID": ucid,
		"PLID": plid,
		"Text": text,
	}


func _get_pretty_text() -> String:
	return "(%s)(%s) %s" % [
		("PLID %d" % [plid]) if plid != 0 else ("UCID %d" % [ucid]),
		str(InSim.MessageSound.keys()[InSim.MessageSound.values().find(sound)]) if (
			sound in InSim.MessageSound.values()
		) else "INVALID SOUND",
		text,
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["Sound", "UCID", "PLID", "Text"]):
		return
	sound = dict["Sound"]
	ucid = dict["UCID"]
	plid = dict["PLID"]
	text = dict["Text"]


func _trim_packet_size() -> void:
	for i in TEXT_MAX_LENGTH:
		if buffer[PACKET_MAX_SIZE - i - 1] != 0:
			size = PACKET_MAX_SIZE - i + 1  # + 1 to keep final zero
			resize_buffer(size)
			break
	if size == PACKET_MAX_SIZE and text.length() < 10:
		size = PACKET_MIN_SIZE
		resize_buffer(size)
