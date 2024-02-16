class_name InSimPENPacket
extends InSimPacket

## PENalty packet (given or cleared)

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_PEN
var player_id := 0  ## player's unique id

var old_penalty := InSim.Penalty.PENALTY_NONE  ## old penalty value (see [enum InSim.Penalty])
var new_penalty := InSim.Penalty.PENALTY_NONE  ## new penalty value (see [enum InSim.Penalty])
var reason := InSim.PenaltyReason.PENR_NUM  ## penalty reason (see [enum InSim.PenaltyReason])
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
	player_id = read_byte()
	old_penalty = read_byte() as InSim.Penalty
	new_penalty = read_byte() as InSim.Penalty
	reason = read_byte() as InSim.PenaltyReason
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"OldPen": old_penalty,
		"NewPen": new_penalty,
		"Reason": reason,
		"Sp3": sp3,
	}
