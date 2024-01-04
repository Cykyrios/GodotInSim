class_name InSimBFNPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_BFN
var subtype := InSim.ButtonFunction.BFN_USER_CLEAR

var ucid := 0
var click_id := 0
var click_max := 0
var inst := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	subtype = read_byte(packet) as InSim.ButtonFunction
	ucid = read_byte(packet)
	click_id = read_byte(packet)
	click_max = read_byte(packet)
	inst = read_byte(packet)


func _fill_buffer() -> void:
	super()
	add_byte(subtype)
	add_byte(ucid)
	add_byte(click_id)
	add_byte(click_max)
	add_byte(inst)


func _get_data_dictionary() -> Dictionary:
	return {
		"SubT": subtype,
		"UCID": ucid,
		"ClickID": click_id,
		"ClickMax": click_max,
		"Inst": inst,
	}
