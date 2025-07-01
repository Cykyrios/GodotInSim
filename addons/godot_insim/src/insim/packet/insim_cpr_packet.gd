class_name InSimCPRPacket
extends InSimPacket
## Conn Player Rename packet
##
## This packet is received when a player changes their name or plate.

const PLAYER_NAME_MAX_LENGTH := 24  ## Maximum player name length
const PLATE_MAX_LENGTH := 8  ## Maximum plate text length

const PACKET_SIZE := 36  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_CPR  ## The packet's type, see [enum InSim.Packet].
var ucid := 0  ## unique id of the connection

var player_name := ""  ## new name
var plate := ""  ## number plate - NO ZERO AT END!


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
	player_name = read_string(PLAYER_NAME_MAX_LENGTH)
	plate = read_string(PLATE_MAX_LENGTH, false)


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"PName": player_name,
		"Plate": plate,
	}


func _get_pretty_text() -> String:
	return "UCID %d renamed to %s" % [ucid, player_name]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["UCID", "PName", "Plate"]):
		return
	ucid = dict["UCID"]
	player_name = dict["PName"]
	plate = dict["Plate"]
