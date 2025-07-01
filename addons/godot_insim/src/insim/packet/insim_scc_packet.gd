class_name InSimSCCPacket
extends InSimPacket
## Set Car Camera packet - simplified camera packet (not Shift+U mode)
##
## This packet is sent to set the camera

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_SCC  ## The packet's type, see [enum InSim.Packet].

var zero := 0  ## Zero byte

var view_plid := 255  ## Unique ID of player to view
var ingame_cam := InSim.View.VIEW_MAX  ## As reported in [InSimSTAPacket]
var sp2 := 0  ## Spare
var sp3 := 0  ## Spare


## Creates and returns a new [InSimSCCPacket] from the given parameters.
static func create(scc_plid: int, scc_cam: int) -> InSimSCCPacket:
	var packet := InSimSCCPacket.new()
	packet.view_plid = scc_plid
	packet.ingame_cam = scc_cam as InSim.View
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_byte(view_plid)
	add_byte(ingame_cam)
	add_byte(sp2)
	add_byte(sp3)


func _get_data_dictionary() -> Dictionary:
	return {
		"ViewPLID": view_plid,
		"InGameCam": ingame_cam,
	}


func _get_pretty_text() -> String:
	return "PLID %d set camera to %s" % [
		view_plid,
		str(InSim.View.keys()[ingame_cam]) if ingame_cam in InSim.View.values() else "INVALID VIEW",
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["ViewPLID", "InGameCam"]):
		return
	view_plid = dict["ViewPLID"]
	ingame_cam = dict["InGameCam"]
