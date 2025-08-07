class_name InSimVTNPacket
extends InSimPacket
## VoTe Notify packet
##
## This packet is received when a vote in completed or cancelled.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_VTN  ## The packet's type, see [enum InSim.Packet].

var ucid := 0  ## Connection's unique id
var action := 0  ## Vote action, see [enum InSim.Vote].


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
	ucid = read_byte()
	action = read_byte()
	var _spare2 := read_byte()
	var _spare3 := read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"Action": action,
	}


func _get_pretty_text() -> String:
	return "UCID %d voted %s" % [ucid, InSim.Vote.keys()[action]]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["UCID", "Action"]):
		return
	ucid = dict["UCID"]
	action = dict["Action"]
