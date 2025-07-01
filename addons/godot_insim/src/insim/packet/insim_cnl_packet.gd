class_name InSimCNLPacket
extends InSimPacket
## ConN Leave packet
##
## This packet is received when a player disconnects from the server.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_CNL  ## The packet's type, see [enum InSim.Packet].
var ucid := 0  ## unique id of the connection which left

var reason := InSim.LeaveReason.LEAVR_NUM  ## leave reason (see [enum InSim.LeaveReason])
var total := 0  ## number of connections including host
var sp2 := 0  ## Spare
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
	reason = read_byte() as InSim.LeaveReason
	total = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"Reason": reason,
		"Total": total,
	}


func _get_pretty_text() -> String:
	return "%s disconnected" % ["host" if ucid == 0 else "UCID %d" % [ucid]]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["UCID", "Reason", "Total"]):
		return
	ucid = dict["UCID"]
	reason = dict["Reason"]
	total = dict["Total"]
