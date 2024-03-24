class_name InSimTTCPacket
extends InSimPacket

## General purpose packet - IS_TTC (Target To Connection)
##
## Similar to IS_SMALL but contains 4 bytes instead of a integer.[br]
## [br]
## See [enum InSim.TTC] for the list of TTC_ packets.

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_TTC
var sub_type := InSim.TTC.TTC_NONE

var ucid := 0
var b1 := 0
var b2 := 0
var b3 := 0


func _init(req := 0, subt := InSim.TTC.TTC_NONE, _ucid := 0, _b1 := 0, _b2 := 0, _b3 := 0) -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	req_i = req
	sub_type = subt
	ucid = _ucid
	b1 = _b1
	b2 = _b2
	b3 = _b3
	sendable = true


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
	add_unsigned(ucid)
	add_unsigned(b1)
	add_unsigned(b2)
	add_unsigned(b3)


func _get_data_dictionary() -> Dictionary:
	return {
		"SubT": sub_type,
		"UCID": ucid,
		"B1": b1,
		"B2": b2,
		"B3": b3,
	}
