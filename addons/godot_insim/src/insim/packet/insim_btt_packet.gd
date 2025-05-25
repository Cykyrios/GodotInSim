class_name InSimBTTPacket
extends InSimPacket
## BuTton Type packet - sent back when user types into a text entry button
##
## This packet is received when a player types text in an InSim button's typing area.

const PACKET_SIZE := 104  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_BTT  ## The packet's type, see [enum InSim.Packet].
const TEXT_MAX_LENGTH := 96  ## Maximum text length

var ucid := 0  ## connection that typed into the button (zero if local)

var click_id := 0  ## button identifier originally sent in IS_BTN ([class InSimBTNPacket])
var inst := 0  ## used internally by InSim
var type_in := 0  ## from original button specification
var sp3 := 0  ## Spare

var text := ""  ## typed text, zero to [member type_in] specified in IS_BTN ([class InSimBTNPacket])


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


func _get_pretty_text() -> String:
	return "Button type in (%s): ID %d, %s" % ["local" if ucid == 0 else "UCID %d" % [ucid],
			click_id, text]
