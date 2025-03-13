class_name InSimSCCPacket
extends InSimPacket

## Set Car Camera packet - simplified camera packet (not Shift+U mode)

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_SCC
var zero := 0

var view_plid := 255  ## unique ID of player to view
var ingame_cam := InSim.View.VIEW_MAX  ## as reported in [InSimSTAPacket]
var sp2 := 0
var sp3 := 0


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
		"Zero": zero,
		"ViewPLID": view_plid,
		"InGameCam": ingame_cam,
		"Sp2": sp2,
		"Sp3": sp3,
	}


static func create(scc_plid: int, scc_cam: int) -> InSimSCCPacket:
	var packet := InSimSCCPacket.new()
	packet.view_plid = scc_plid
	packet.ingame_cam = scc_cam as InSim.View
	return packet
