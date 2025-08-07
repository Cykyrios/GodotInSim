class_name InSimISMPacket
extends InSimPacket
## InSim Multi packet
##
## This packet is received when starting or joining a multiplayer host (replays also trigger this).

const HOST_NAME_LENGTH := 32  ## Host name max length

const PACKET_SIZE := 40  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_ISM  ## The packet's type, see [enum InSim.Packet].

var host := 0  ## 0 = guest / 1 = host

var h_name := ""  ## the name of the host joined or started


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
	var _zero := read_byte()
	host = read_byte()
	var _sp1 := read_byte()
	var _sp2 := read_byte()
	var _sp3 := read_byte()
	h_name = read_string(HOST_NAME_LENGTH)


func _get_data_dictionary() -> Dictionary:
	return {
		"Host": host,
		"HName": h_name,
	}


func _get_pretty_text() -> String:
	return "%s host %s (%s)" % [
		"Current" if req_i != 0 else "Created" if host == 1 else "Joined",
		h_name,
		"host" if host == 1 else "guest"
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["Host", "HName"]):
		return
	host = dict["Host"]
	h_name = dict["HName"]
