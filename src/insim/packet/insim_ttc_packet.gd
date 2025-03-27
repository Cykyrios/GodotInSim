class_name InSimTTCPacket
extends InSimPacket

## General purpose packet - IS_TTC (Target To Connection)
##
## Similar to IS_SMALL but contains 4 bytes instead of a integer.[br]
## [br]
## See [enum InSim.TTC] for the list of TTC_ packets.

const RECEIVABLES := []
const SENDABLES := [
	InSim.TTC.TTC_SEL,
	InSim.TTC.TTC_SEL_START,
	InSim.TTC.TTC_SEL_STOP,
]

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_TTC
var sub_type := InSim.TTC.TTC_NONE

var ucid := 0
var b1 := 0
var b2 := 0
var b3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	sub_type = read_byte() as InSim.TTC
	ucid = read_byte()
	b1 = read_byte()
	b2 = read_byte()
	b3 = read_byte()


func _fill_buffer() -> void:
	super()
	update_req_i()
	add_byte(sub_type)
	add_byte(ucid)
	add_byte(b1)
	add_byte(b2)
	add_byte(b3)


func _get_data_dictionary() -> Dictionary:
	return {
		"SubT": sub_type,
		"UCID": ucid,
		"B1": b1,
		"B2": b2,
		"B3": b3,
	}


func _get_pretty_text() -> String:
	return "(ReqI %d) %s (UCID %d B1=%d B2=%d B3=%d)" % [req_i, InSim.TTC.keys()[sub_type],
			ucid, b1, b2, b3]


static func create(
	req := 0, subt := InSim.TTC.TTC_NONE, ttc_ucid := 0, ttc_b1 := 0, ttc_b2 := 0, ttc_b3 := 0
) -> InSimTTCPacket:
	var packet := InSimTTCPacket.new()
	packet.req_i = req
	packet.sub_type = subt
	packet.ucid = ttc_ucid
	packet.b1 = ttc_b1
	packet.b2 = ttc_b2
	packet.b3 = ttc_b3
	if packet.sub_type in RECEIVABLES:
		packet.receivable = true
	if packet.sub_type in SENDABLES:
		packet.sendable = true
	return packet
