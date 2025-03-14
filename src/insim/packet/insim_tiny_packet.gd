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


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
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
	return "(ReqI %d) %s" % [req_i, InSim.Tiny.keys()[sub_type]]


static func create(req := 0, subt := InSim.Tiny.TINY_NONE) -> InSimTinyPacket:
	var packet := InSimTinyPacket.new()
	packet.size = PACKET_SIZE
	packet.type = PACKET_TYPE
	packet.req_i = req
	packet.sub_type = subt
	if packet.sub_type in RECEIVABLES:
		packet.receivable = true
	if packet.sub_type in SENDABLES:
		packet.sendable = true
	return packet
