class_name InSimNCNPacket
extends InSimPacket
## New ConN packet
##
## This packet is received when a player connects to the server.

const USER_NAME_MAX_LENGTH := 24  ## Maximum username length
const PLAYER_NAME_MAX_LENGTH := 24  ## Maximum player name length

const PACKET_SIZE := 56  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_NCN  ## The packet's type, see [enum InSim.Packet].
var ucid := 0  ## Connection's unique id (0 = host)

var user_name := ""  ## Username
var player_name := ""  ## Nickname

var admin := 0  ## Admin status; 1 if admin.
var total := 0  ## Number of connections including host
var flags := 0  ## Flags; bit 2: remote.
var sp3 := 0  ## Spare


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	ucid = read_byte()
	user_name = read_string(USER_NAME_MAX_LENGTH)
	player_name = read_string(PLAYER_NAME_MAX_LENGTH)
	admin = read_byte()
	total = read_byte()
	flags = read_byte()
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"UName": user_name,
		"PName": player_name,
		"Admin": admin,
		"Total": total,
		"Flags": flags,
	}


func _get_pretty_text() -> String:
	return "%s %s" % [
		"host" if ucid == 0 else "UCID %d" % [ucid],
		"connected" if req_i == 0 else "is online"
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["UCID", "UName", "PName", "Admin", "Total", "Flags"]):
		return
	ucid = dict["UCID"]
	user_name = dict["UName"]
	player_name = dict["PName"]
	admin = dict["Admin"]
	total = dict["Total"]
	flags = dict["Flags"]
