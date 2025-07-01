class_name InSimCCHPacket
extends InSimPacket
## Camera CHange packet
##
## This packet is received when a player changes cameras.[br]
## InSim doc excerpt:[br]
## To track cameras you need to consider 3 points:[br]
## 1) The default camera: [constant InSim.View.VIEW_DRIVER][br]
## 2) Player flags: [constant InSim.PlayerFlag.PIF_CUSTOM_VIEW] means
## [constant InSim.View.VIEW_CUSTOM]
## at start or pit exit[br]
## 3) IS_CCH ([InSimCCHPacket]): sent when an existing driver changes camera

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_CCH  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## player's unique id

var camera := InSim.View.VIEW_MAX  ## view identifier (see [enum InSim.View])
var sp1 := 0  ## Spare
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
	plid = read_byte()
	camera = read_byte() as InSim.View
	sp1 = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"Camera": camera,
	}


func _get_pretty_text() -> String:
	return "PLID %d changed camera to %s" % [plid,
			InSim.View.keys()[InSim.View.values().find(camera)]]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "Camera"]):
		return
	plid = dict["PLID"]
	camera = dict["Camera"]
