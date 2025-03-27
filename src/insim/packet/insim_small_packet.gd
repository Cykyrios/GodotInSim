class_name InSimSmallPacket
extends InSimPacket

## General purpose packet - IS_SMALL
##
## To avoid defining several packet structures that are exactly the same, and to avoid
## wasting the ISP_ enumeration, IS_SMALL is used at various times when no additional data
## other than SubT and an additional integer is required.[br]
## [br]
## See [enum InSim.Small] for the list of SMALL_ packets.

const RECEIVABLES := [
	InSim.Small.SMALL_VTA,
	InSim.Small.SMALL_RTP,
	InSim.Small.SMALL_ALC,
]
const SENDABLES := [
	InSim.Small.SMALL_SSP,
	InSim.Small.SMALL_SSG,
	InSim.Small.SMALL_TMS,
	InSim.Small.SMALL_STP,
	InSim.Small.SMALL_NLI,
	InSim.Small.SMALL_ALC,
	InSim.Small.SMALL_LCS,
	InSim.Small.SMALL_LCL,
	InSim.Small.SMALL_AII,
]

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_SMALL
var sub_type := InSim.Small.SMALL_NONE
var value := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	sub_type = read_byte() as InSim.Small
	value = read_unsigned()


func _fill_buffer() -> void:
	super()
	update_req_i()
	add_byte(sub_type)
	add_unsigned(value)


func _get_data_dictionary() -> Dictionary:
	return {
		"SubT": sub_type,
		"UVal": value,
	}


func _get_pretty_text() -> String:
	return "(ReqI %d) %s (Value %d)" % [req_i, InSim.Small.keys()[sub_type], value]


static func create(req := 0, subt := InSim.Small.SMALL_NONE, uval := 0) -> InSimSmallPacket:
	var packet := InSimSmallPacket.new()
	packet.req_i = req
	packet.sub_type = subt
	packet.value = uval
	if packet.sub_type in RECEIVABLES:
		packet.receivable = true
	if packet.sub_type in SENDABLES:
		packet.sendable = true
	return packet
