class_name InSimCIMPacket
extends InSimPacket


enum Mode {
	CIM_NORMAL,
	CIM_OPTIONS,
	CIM_HOST_OPTIONS,
	CIM_GARAGE,
	CIM_CAR_SELECT,
	CIM_TRACK_SELECT,
	CIM_SHIFTU,
	CIM_NUM
}
enum SubmodeNormal {
	NRM_NORMAL,
	NRM_WHEEL_TEMPS,
	NRM_WHEEL_DAMAGE,
	NRM_LIVE_SETTINGS,
	NRM_PIT_INSTRUCTIONS,
	NRM_NUM
}
enum SubmodeGarage {
	GRG_INFO,
	GRG_COLOURS,
	GRG_BRAKE_TC,
	GRG_SUSP,
	GRG_STEER,
	GRG_DRIVE,
	GRG_TYRES,
	GRG_AERO,
	GRG_PASS,
	GRG_NUM
}
enum SubmodeShiftU {
	FVM_PLAIN,
	FVM_BUTTONS,
	FVM_EDIT,
	FVM_NUM
}

const MARSH_IS_CP := 252
const MARSH_IS_AREA := 253
const MARSH_MARSHAL := 254
const MARSH_ROUTE := 255

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_CIM
var ucid := 0

var mode := 0
var submode := 0
var sel_type := 0
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _get_data_dictionary() -> Dictionary:
	var data := {
		"UCID": ucid,
		"Mode": mode,
		"SubMode": submode,
		"SelType": sel_type,
		"Sp3": sp3,
	}
	return data


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	ucid = read_byte(packet)
	mode = read_word(packet)
	submode = read_byte(packet)
	sel_type = read_byte(packet)
	sp3 = read_byte(packet)
