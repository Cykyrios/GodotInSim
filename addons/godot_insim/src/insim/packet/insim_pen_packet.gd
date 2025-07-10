class_name InSimPENPacket
extends InSimPacket
## PENalty packet (given or cleared)
##
## This packet is received when a player receives a penalty, or a penalty is cleared.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_PEN  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## Player's unique id

var old_penalty := InSim.Penalty.PENALTY_NONE  ## Old penalty value (see [enum InSim.Penalty])
var new_penalty := InSim.Penalty.PENALTY_NONE  ## New penalty value (see [enum InSim.Penalty])
var reason := InSim.PenaltyReason.PENR_NUM  ## Penalty reason (see [enum InSim.PenaltyReason])
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
	plid = read_byte()
	old_penalty = read_byte() as InSim.Penalty
	new_penalty = read_byte() as InSim.Penalty
	reason = read_byte() as InSim.PenaltyReason
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"OldPen": old_penalty,
		"NewPen": new_penalty,
		"Reason": reason,
	}


func _get_pretty_text() -> String:
	var penalty_string := "penalty cleared"
	match new_penalty:
		InSim.Penalty.PENALTY_DT:
			penalty_string = "drive-through penalty"
		InSim.Penalty.PENALTY_DT_VALID:
			penalty_string = "completed drive-through penalty"
		InSim.Penalty.PENALTY_SG:
			penalty_string = "stop-go penalty"
		InSim.Penalty.PENALTY_SG_VALID:
			penalty_string = "completed stop-go penalty"
		InSim.Penalty.PENALTY_30:
			penalty_string = "30s penalty"
		InSim.Penalty.PENALTY_45:
			penalty_string = "45s penalty"
	var reason_string := ""
	match reason:
		InSim.PenaltyReason.PENR_ADMIN:
			reason_string = "admin"
		InSim.PenaltyReason.PENR_WRONG_WAY:
			reason_string = "wrong way"
		InSim.PenaltyReason.PENR_FALSE_START:
			reason_string = "false start"
		InSim.PenaltyReason.PENR_SPEEDING:
			reason_string = "speeding"
		InSim.PenaltyReason.PENR_STOP_SHORT:
			reason_string = "stop too short"
		InSim.PenaltyReason.PENR_STOP_LATE:
			reason_string = "stop too late"
	return "PLID %d: %s" % [
		plid,
		"%s%s" % [
			penalty_string,
			"" if reason == InSim.PenaltyReason.PENR_UNKNOWN else " (%s)" % [reason_string],
		]
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "OldPen", "NewPen", "Reason"]):
		return
	plid = dict["PLID"]
	old_penalty = dict["OldPen"]
	new_penalty = dict["NewPen"]
	reason = dict["Reason"]
