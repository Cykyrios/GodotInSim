class_name InSimBTTPacket
extends InSimPacket


const PACKET_SIZE := 104
const PACKET_TYPE := InSim.Packet.ISP_BTT
const TEXT_MAX_LENGTH := 96

var ucid := 0

var click_id := 0
var inst := 0
var type_in := 0
var sp3 := 0

var text := ""


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
	type_in = read_byte()
	sp3 = read_byte()
	text = read_string(TEXT_MAX_LENGTH)


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"ClickID": click_id,
		"Inst": inst,
		"TypeIn": type_in,
		"Sp3": sp3,
		"Text": text,
	}
