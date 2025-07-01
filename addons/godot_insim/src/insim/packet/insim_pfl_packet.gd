class_name InSimPFLPacket
extends InSimPacket
## Player FLags packet (help flags changed)
##
## This packet is received when a player's flags change.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_PFL  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## Player's unique id

var flags := 0  ## New player flags (see [enum InSim.PlayerFlag])
var spare := 0  ## Spare


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
	plid = read_byte()
	flags = read_word()
	spare = read_word()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"Flags": flags,
	}


func _get_pretty_text() -> String:
	return "PLID %d changed flags: %s" % [plid, flags]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "Flags"]):
		return
	plid = dict["PLID"]
	flags = dict["Flags"]
