class_name InSimCIMPacket
extends InSimPacket
## Conn Interface Mode packet
##
## This packet is received when a player goes through specific menus.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_CIM  ## The packet's type, see [enum InSim.Packet].
var ucid := 0  ## connection's unique id (0 = local)

var mode := InSim.InterfaceMode.CIM_NUM  ## mode identifier (see [enum InSim.InterfaceMode])
## submode identifier (see [enum InSim.InterfaceNormal], [enum InSim.InterfaceGarage],
## [enum InSim.InterfaceShiftU])
var submode := 0
var sel_type := 0  ## selected object type or zero if unselected, can be an AXO_x or MARSH_x
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
	var submode_filter: Array[InSim.InterfaceMode] = [
		InSim.InterfaceMode.CIM_NORMAL,
		InSim.InterfaceMode.CIM_GARAGE,
		InSim.InterfaceMode.CIM_SHIFTU,
	]
	var get_submode_string := func get_submode_string(
		packet_mode: InSim.InternalMode, packet_submode: int
	) -> String:
		var key_string := "?"
		if packet_mode not in submode_filter:
			return key_string
		var enum_keys := (
			InSim.InterfaceNormal.keys() if mode == InSim.InterfaceMode.CIM_NORMAL
			else InSim.InterfaceGarage.keys() if mode == InSim.InterfaceMode.CIM_GARAGE
			else InSim.InterfaceShiftU.keys()
		)
		var enum_values := (
			InSim.InterfaceNormal.values() if mode == InSim.InterfaceMode.CIM_NORMAL
			else InSim.InterfaceGarage.values() if mode == InSim.InterfaceMode.CIM_GARAGE
			else InSim.InterfaceShiftU.values()
		)
		var idx := enum_values.find(packet_submode)
		if idx != -1:
			key_string = enum_keys[idx]
		return key_string
	var get_selection := func get_selection(value: int) -> String:
		var idx := InSim.AXOIndex.values().find(value)
		return InSim.AXOIndex.keys()[idx] if idx != -1 else "no selection"

	var submode_string := " (%s%s)" % [
		get_submode_string.call(mode, submode),
		(", %s" % [get_selection.call(sel_type)]) if (
			mode == InSim.InterfaceMode.CIM_SHIFTU
			and submode == InSim.InterfaceShiftU.FVM_EDIT
		) else "",
	]
	return "UCID %d: %s%s" % [
		ucid,
		InSim.InterfaceMode.keys()[mode],
		submode_string if mode in submode_filter else "",
	]
