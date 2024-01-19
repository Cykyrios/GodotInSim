class_name InSimCIMPacket
extends InSimPacket


const MARSH_IS_CP := 252
const MARSH_IS_AREA := 253
const MARSH_MARSHAL := 254
const MARSH_ROUTE := 255

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_CIM
var ucid := 0

var mode := InSim.InterfaceMode.CIM_NUM
var submode := 0
var sel_type := 0
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
	mode = read_byte(packet) as InSim.InterfaceMode
	submode = read_byte(packet)
	sel_type = read_byte(packet)
	sp3 = read_byte(packet)


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"Mode": mode,
		"SubMode": submode,
		"SelType": sel_type,
		"Sp3": sp3,
	}
