class_name InSimACRPacket
extends InSimPacket
## Admin Command Report packet
##
## This packet is received when a user types an admin command.

const PACKET_MIN_SIZE := 12  ## Minimum packet size
const PACKET_MAX_SIZE := 72  ## Maximum packet size
const PACKET_TYPE := InSim.Packet.ISP_ACR  ## The packet's type, see [enum InSim.Packet].
const MSG_MAX_LENGTH := 64  ## Maximum message length

var ucid := 0  ## connection's unique id (0 = host)
var admin := 0  ## set if user is an admin
var result := 0  ## 1 - processed / 2 - rejected / 3 - unknown command

var text := ""  ## 4, 8, 12... 64 characters - last byte is zero


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
	admin = read_byte()
	result = read_byte()
	var _sp3 := read_byte()
	text = read_string(packet_size - data_offset)


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"Admin": admin,
		"Result": result,
		"Text": text,
	}


func _get_pretty_text() -> String:
	var result_string := "Processed" if result == 1 else "Rejected" if result == 2 else "Unknown"
	return "%s admin command from UCID %d (%sadmin): %s" % [
		result_string, ucid, "not " if admin == 0 else "", text
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["UCID", "Admin", "Result", "Text"]):
		return
	ucid = dict["UCID"]
	admin = dict["Admin"]
	result = dict["Result"]
	text = dict["Text"]
