class_name InSimTinyPacket
extends InSimPacket

## General purpose packet - IS_TINY
##
## To avoid defining several packet structures that are exactly the same, and to avoid
## wasting the ISP_ enumeration, IS_TINY is used at various times when no additional data
## other than SubT is required.[br]
## [br]
## See [enum InSim.Tiny] for the list of TINY_ packets.

const RECEIVABLES := [
	InSim.Tiny.TINY_NONE,
	InSim.Tiny.TINY_REPLY,
	InSim.Tiny.TINY_VTC,
	InSim.Tiny.TINY_MPE,
	InSim.Tiny.TINY_REN,
	InSim.Tiny.TINY_CLR,
	InSim.Tiny.TINY_AXC,
]
const SENDABLES := [
	InSim.Tiny.TINY_NONE,
	InSim.Tiny.TINY_VER,
	InSim.Tiny.TINY_CLOSE,
	InSim.Tiny.TINY_PING,
	InSim.Tiny.TINY_VTC,
	InSim.Tiny.TINY_SCP,
	InSim.Tiny.TINY_SST,
	InSim.Tiny.TINY_GTH,
	InSim.Tiny.TINY_ISM,
	InSim.Tiny.TINY_NCN,
	InSim.Tiny.TINY_NPL,
	InSim.Tiny.TINY_RES,
	InSim.Tiny.TINY_NLP,
	InSim.Tiny.TINY_MCI,
	InSim.Tiny.TINY_REO,
	InSim.Tiny.TINY_RST,
	InSim.Tiny.TINY_AXI,
	InSim.Tiny.TINY_RIP,
	InSim.Tiny.TINY_NCI,
	InSim.Tiny.TINY_ALC,
	InSim.Tiny.TINY_AXM,
	InSim.Tiny.TINY_SLC,
	InSim.Tiny.TINY_MAL,
	InSim.Tiny.TINY_PLH,
	InSim.Tiny.TINY_IPB,
]

const PACKET_SIZE := 4
const PACKET_TYPE := InSim.Packet.ISP_TINY
var sub_type := InSim.Tiny.TINY_NONE


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	sub_type = read_byte() as InSim.Tiny


func _fill_buffer() -> void:
	super()
	update_req_i()
	add_byte(sub_type)


func _get_data_dictionary() -> Dictionary:
	return {
		"SubT": sub_type,
	}


func _get_pretty_text() -> String:
	var tiny_description := "ISP_TINY"
	match sub_type:
		InSim.Tiny.TINY_NONE:
			tiny_description = "keep alive"
		InSim.Tiny.TINY_VER:
			tiny_description = "request version"
		InSim.Tiny.TINY_CLOSE:
			tiny_description = "close InSim"
		InSim.Tiny.TINY_PING:
			tiny_description = "ping"
		InSim.Tiny.TINY_REPLY:
			tiny_description = "ping reply"
		InSim.Tiny.TINY_VTC:
			tiny_description = "cancel vote"
		InSim.Tiny.TINY_SCP:
			tiny_description = "request camera packet"
		InSim.Tiny.TINY_SST:
			tiny_description = "request state packet"
		InSim.Tiny.TINY_GTH:
			tiny_description = "request time"
		InSim.Tiny.TINY_MPE:
			tiny_description = "multiplayer ended"
		InSim.Tiny.TINY_ISM:
			tiny_description = "request multiplayer info"
		InSim.Tiny.TINY_REN:
			tiny_description = "race ended"
		InSim.Tiny.TINY_CLR:
			tiny_description = "grid cleared"
		InSim.Tiny.TINY_NCN:
			tiny_description = "request connections"
		InSim.Tiny.TINY_NPL:
			tiny_description = "request players"
		InSim.Tiny.TINY_RES:
			tiny_description = "request results"
		InSim.Tiny.TINY_NLP:
			tiny_description = "request NLP"
		InSim.Tiny.TINY_MCI:
			tiny_description = "request MCI"
		InSim.Tiny.TINY_REO:
			tiny_description = "request start order"
		InSim.Tiny.TINY_RST:
			tiny_description = "request session info"
		InSim.Tiny.TINY_AXI:
			tiny_description = "request autocross info"
		InSim.Tiny.TINY_AXC:
			tiny_description = "autocross cleared"
		InSim.Tiny.TINY_RIP:
			tiny_description = "request replay info"
		InSim.Tiny.TINY_NCI:
			tiny_description = "request connection info"
		InSim.Tiny.TINY_ALC:
			tiny_description = "request allowed car list"
		InSim.Tiny.TINY_AXM:
			tiny_description = "request layout info"
		InSim.Tiny.TINY_SLC:
			tiny_description = "request selected cars"
		InSim.Tiny.TINY_MAL:
			tiny_description = "request allowed mod list"
		InSim.Tiny.TINY_PLH:
			tiny_description = "request player handicaps"
		InSim.Tiny.TINY_IPB:
			tiny_description = "request IP ban list"
	return "(ReqI %d) %s - %s" % [req_i, InSim.Tiny.keys()[sub_type], tiny_description]


static func create(req := 0, subt := InSim.Tiny.TINY_NONE) -> InSimTinyPacket:
	var packet := InSimTinyPacket.new()
	packet.req_i = req
	packet.sub_type = subt
	if packet.sub_type in RECEIVABLES:
		packet.receivable = true
	if packet.sub_type in SENDABLES:
		packet.sendable = true
	return packet
