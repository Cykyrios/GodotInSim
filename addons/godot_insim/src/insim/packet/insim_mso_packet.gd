class_name InSimMSOPacket
extends InSimPacket
## MSg Out packet - system messages and user messages - variable size
##
## This packet is received any time a message is displayed in game.

const PACKET_MIN_SIZE := 12  ## Minimum packet size
const PACKET_MAX_SIZE := 136  ## Maximum packet size
const PACKET_TYPE := InSim.Packet.ISP_MSO  ## The packet's type, see [enum InSim.Packet].
const MSG_MAX_LENGTH := 128  ## Maximum message length

var ucid := 0  ## Connection's unique id (0 = host)
var plid := 0  ## Player's unique id (if zero, use [member ucid])
## Message type, see [enum InSim.MessageUserValue]
var user_type := InSim.MessageUserValue.MSO_SYSTEM
## @experimental: This property is unreliable, use [method LFSText.get_mso_start] instead.
## First character of the actual text (after player name)[br]
## [b]Warning:[/b] If the sender's name contains non-latin or multi-byte characters, the count
## will be off.
var text_start := 0
var msg := ""  ## Message contents (4, 8, 12... 128 characters - last byte is zero)


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if (
		packet_size < PACKET_MIN_SIZE
		or packet_size > PACKET_MAX_SIZE
		or packet_size % INSIM_SIZE_MULTIPLIER != 0
	):
		push_error("%s packet expected size [%d..%d step %d], got %d." % [
			get_type_string(), PACKET_MIN_SIZE, PACKET_MAX_SIZE, INSIM_SIZE_MULTIPLIER, packet_size
		])
		return
	super(packet)
	var _zero := read_byte()
	ucid = read_byte()
	plid = read_byte()
	user_type = read_byte() as InSim.MessageUserValue
	text_start = read_byte()
	msg = read_string(packet_size - data_offset)


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"PLID": plid,
		"UserType": user_type,
		"TextStart": text_start,
		"Msg": msg,
	}


func _get_pretty_text() -> String:
	return "(%s) %s" % [InSim.MessageUserValue.keys()[user_type], msg]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["UCID", "PLID", "UserType", "TextStart", "Msg"]):
		return
	ucid = dict["UCID"]
	plid = dict["PLID"]
	user_type = dict["UserType"]
	text_start = dict["TextStart"]
	msg = dict["Msg"]
