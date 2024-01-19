class_name InSimCNLPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_CNL
var ucid := 0

var reason := InSim.LeaveReason.LEAVR_NUM
var total := 0
var sp2 := 0
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	ucid = read_byte(packet)
	reason = read_byte(packet) as InSim.LeaveReason
	total = read_byte(packet)
	sp2 = read_byte(packet)
	sp3 = read_byte(packet)


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"Reason": reason,
		"Total": total,
		"Sp2": sp2,
		"Sp3": sp3,
	}
