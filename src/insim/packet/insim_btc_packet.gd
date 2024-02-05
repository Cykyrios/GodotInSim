class_name InSimBTCPacket
extends InSimPacket


const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_BTC
var ucid := 0

var click_id := 0
var inst := 0
var click_flags := 0
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
	ucid = read_byte()
	click_id = read_byte()
	inst = read_byte()
	click_flags = read_byte()
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"ClickID": click_id,
		"Inst": inst,
		"CFlags": click_flags,
		"Sp3": sp3,
	}
