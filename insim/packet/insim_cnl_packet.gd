class_name InSimCNLPacket
extends InSimPacket


enum LeaveReason {
	LEAVR_DISCO,
	LEAVR_TIMEOUT,
	LEAVR_LOSTCONN,
	LEAVR_KICKED,
	LEAVR_BANNED,
	LEAVR_SECURITY,
	LEAVR_CPW,
	LEAVR_OOS,
	LEAVR_JOOS,
	LEAVR_HACK,
	LEAVR_NUM
}

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_CNL
var ucid := 0

var reason := LeaveReason.LEAVR_NUM
var total := 0
var sp2 := 0
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _get_data_dictionary() -> Dictionary:
	var data := {
		"UCID": ucid,
		"Reason": reason,
		"Total": total,
		"Sp2": sp2,
		"Sp3": sp3,
	}
	return data


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	ucid = read_byte(packet)
	reason = read_byte(packet) as LeaveReason
	total = read_byte(packet)
	sp2 = read_byte(packet)
	sp3 = read_byte(packet)
