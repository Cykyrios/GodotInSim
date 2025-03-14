class_name InSimCNLPacket
extends InSimPacket

## ConN Leave packet

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_CNL
var ucid := 0  ## unique id of the connection which left

var reason := InSim.LeaveReason.LEAVR_NUM  ## leave reason (see [enum InSim.LeaveReason])
var total := 0  ## number of connections including host
var sp2 := 0
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
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
		"Sp2": sp2,
		"Sp3": sp3,
	}


func _get_pretty_text() -> String:
	return "%s disconnected" % ["host" if ucid == 0 else "UCID %d" % [ucid]]
