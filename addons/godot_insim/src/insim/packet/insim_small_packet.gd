class_name InSimSmallPacket
extends InSimPacket
## General purpose packet - IS_SMALL
##
## To avoid defining several packet structures that are exactly the same, and to avoid
## wasting the ISP_ enumeration, IS_SMALL is used at various times when no additional data
## other than SubT and an additional integer is required.[br]
## [br]
## See [enum InSim.Small] for the list of SMALL_ packets.

## List of receivable Small packets
const RECEIVABLES := [
	InSim.Small.SMALL_VTA,
	InSim.Small.SMALL_RTP,
	InSim.Small.SMALL_ALC,
]
## List of sendable Small packets
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

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_SMALL  ## The packet's type, see [enum InSim.Packet].
var sub_type := InSim.Small.SMALL_NONE  ## Packet subtype
var value := 0  ## Packet value


## Creates and returns a new [InSimSmallPacket] with the given parameters.
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


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
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
	var small_description := "ISP_SMALL"
	match sub_type:
		InSim.Small.SMALL_NONE:
			small_description = "not used"
		InSim.Small.SMALL_SSP:
			small_description = "start sending positions"
		InSim.Small.SMALL_SSG:
			small_description = "start sending gauges"
		InSim.Small.SMALL_VTA:
			small_description = "vote action"
		InSim.Small.SMALL_TMS:
			small_description = "time stop"
		InSim.Small.SMALL_STP:
			small_description = "time step"
		InSim.Small.SMALL_RTP:
			small_description = "session time"
		InSim.Small.SMALL_NLI:
			small_description = "set node lap interval"
		InSim.Small.SMALL_ALC:
			small_description = "get/set allowed cars"
		InSim.Small.SMALL_LCS:
			small_description = "set local car switches"
		InSim.Small.SMALL_LCL:
			small_description = "set local car lights"
		InSim.Small.SMALL_AII:
			small_description = "get local AI info"
	return "(ReqI %d) %s (Value %d) - %s" % [req_i, InSim.Small.keys()[sub_type],
			value, small_description]
