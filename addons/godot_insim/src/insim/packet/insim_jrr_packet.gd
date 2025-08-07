class_name InSimJRRPacket
extends InSimPacket
## Join Request Reply packet - send one of these back to LFS in response to a join request
##
## This packet can be sent in response to a join request ([InSimNPLPacket] with
## [member InSimNPLPacket.num_players] equal to [code]0[/code]), or at any time to teleport
## a player.

const PACKET_SIZE := 16  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_JRR  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## ZERO when this is a reply to a join request - SET to move a car

var ucid := 0  ## set when this is a reply to a join request - ignored when moving a car
var action := 0  ## 1 - allow / 0 - reject (should send message to user)

var start_pos := ObjectInfo.new()  ## 0: use default start point / Flags = 0x80: set start point


## Creates and returns a new [InSimJRRPacket] from the given parameters.
static func create(
	jrr_plid: int, jrr_ucid: int, jrr_action: InSim.JRRAction, jrr_pos := ObjectInfo.new()
) -> InSimJRRPacket:
	var packet := InSimJRRPacket.new()
	packet.plid = jrr_plid
	packet.ucid = jrr_ucid
	packet.action = jrr_action
	packet.start_pos = jrr_pos
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(plid)
	add_byte(ucid)
	add_byte(action)
	add_byte(0)  # sp2
	add_byte(0)  # sp3
	var start_pos_buffer := start_pos.get_buffer()
	for byte in start_pos_buffer:
		add_byte(byte)


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"UCID": ucid,
		"Action": action,
		"StartPos": start_pos.get_dictionary(),
	}


func _get_pretty_text() -> String:
	return ("UCID %d: %s" % [
		ucid,
		"join request rejected" if action == InSim.JRRAction.JRR_REJECT
		else "join request accepted",
	]) if plid == 0 else ("PLID %d: car reset (%s, %s)" % [
		plid,
		"repaired" if action == InSim.JRRAction.JRR_RESET else "no repair",
		("%.1v" % [start_pos.gis_position]) if (start_pos.flags & 0x80) else "in place"
	])


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "UCID", "Action", "StartPos"]):
		return
	plid = dict["PLID"]
	ucid = dict["UCID"]
	action = dict["Action"]
	start_pos.set_from_dictionary(dict["StartPos"] as Dictionary)
