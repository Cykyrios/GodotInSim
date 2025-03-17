class_name InSimCIMPacket
extends InSimPacket

## Conn Interface Mode packet

const MARSH_IS_CP := 252  ## insim checkpoint
const MARSH_IS_AREA := 253  ## insim circle
const MARSH_MARSHAL := 254  ## restricted area
const MARSH_ROUTE := 255  ## route checker

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_CIM
var ucid := 0  ## connection's unique id (0 = local)

var mode := InSim.InterfaceMode.CIM_NUM  ## mode identifier (see [enum InSim.InterfaceMode])
## submode identifier (see [enum InSim.InterfaceNormal], [enum InSim.InterfaceGarage],
## [enum InSim.InterfaceShiftU])
var submode := 0
var sel_type := 0  ## selected object type or zero if unselected, can be an AXO_x or MARSH_x
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
	mode = read_byte() as InSim.InterfaceMode
	submode = read_byte()
	sel_type = read_byte()
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"Mode": mode,
		"SubMode": submode,
		"SelType": sel_type,
		"Sp3": sp3,
	}


func _get_pretty_text() -> String:
	var submode_filter: Array[InSim.InterfaceMode] = [InSim.InterfaceMode.CIM_NORMAL,
			InSim.InterfaceMode.CIM_GARAGE, InSim.InterfaceMode.CIM_SHIFTU]
	var submode_string := (" (%s)" % [InSim.InterfaceNormal.keys()[submode] \
			if mode == InSim.InterfaceMode.CIM_NORMAL else InSim.InterfaceGarage.keys()[submode] \
			if mode == InSim.InterfaceMode.CIM_GARAGE else InSim.InterfaceShiftU.keys()[submode] \
			if mode == InSim.InterfaceMode.CIM_SHIFTU else "?"]) if mode in submode_filter \
			else ""
	return "UCID %d: %s%s" % [ucid, InSim.InterfaceMode.keys()[mode],
			submode_string if mode in submode_filter else ""]
