class_name InSimBTCPacket
extends InSimPacket

## BuTton Click packet - sent back when user clicks a button

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_BTC
var ucid := 0  ## connection that clicked the button (zero if local)

var click_id := 0  ## button identifier originally sent in IS_BTN
var inst := 0  ## used internally by InSim
var click_flags := 0  ## button click flags - see [enum Insim.ButtonClick]
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
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


func _get_pretty_text() -> String:
	var flags_string: Array[String] = []
	for i in InSim.ButtonClick.size():
		if click_flags & InSim.ButtonClick.values()[i]:
			flags_string.append(InSim.ButtonClick.keys()[i])
	return "Button clicked: %s, ID %d, %s" % ["local" if ucid == 0 else "UCID %d" % [ucid],
			click_id, flags_string]
