class_name InSimBFNPacket
extends InSimPacket
## Button FunctioN packet
##
## This packet is sent or received to manipulate InSim buttons.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_BFN  ## The packet's type, see [enum InSim.Packet].
var subtype := InSim.ButtonFunction.BFN_USER_CLEAR  ## subtype, see [enum InSim.ButtonFunction]

var ucid := 0  ## connection to send to or received from (0 = local / 255 = all)
var click_id := 0  ## if SubT is BFN_DEL_BTN: ID of single button to delete or first button in range
var click_max := 0  ## if SubT is BFN_DEL_BTN: ID of last button in range (if greater than ClickID)
var inst := 0  ## used internally by InSim


## Creates and returns a new [InSimBFNPacket] from the given parameters.
static func create(
	bfn_subtype: InSim.ButtonFunction, bfn_ucid: int, bfn_click_id: int, bfn_click_max: int
) -> InSimBFNPacket:
	var packet := InSimBFNPacket.new()
	packet.subtype = bfn_subtype
	packet.ucid = bfn_ucid
	packet.click_id = bfn_click_id
	packet.click_max = bfn_click_max
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true
	sendable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	subtype = read_byte() as InSim.ButtonFunction
	ucid = read_byte()
	click_id = read_byte()
	click_max = read_byte()
	inst = read_byte()


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


func _get_pretty_text() -> String:
	var bfn_type := ("button(s) deleted (%d/%D)" % [click_id, click_max]) \
			if subtype == InSim.ButtonFunction.BFN_DEL_BTN \
			else "buttons cleared by InSim" if subtype == InSim.ButtonFunction.BFN_CLEAR \
			else "buttons cleared by user" if subtype == InSim.ButtonFunction.BFN_USER_CLEAR \
			else "Shift+B or Shift+I"
	return "UCID %d: %s" % [ucid, bfn_type]
