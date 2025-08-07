class_name InSimCSCPacket
extends InSimPacket
## Car State Changed packet - reports a change in a car's state (currently start or stop)
##
## This packet is received when a car starts or stops moving (with a 2-3 km/h tolerance).

## Conversion factor between standard units and LFS-encoded values.
const TIME_MULTIPLIER := 100.0

const PACKET_SIZE := 20  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_CSC  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## player's unique id

var csc_action := InSim.CSCAction.CSC_START  ## CSC action, see [enum InSim.CSCAction].

var time := 0  ## hundredths of a second since start (as in [constant InSim.Small.SMALL_RTP])
var object := CarContObj.new()  ## Car data when the action occurred.

var gis_time := 0.0  ## Time in seconds


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
	plid = read_byte()
	var _sp0 := read_byte()
	csc_action = read_byte() as InSim.CSCAction
	var _sp2 := read_byte()
	var _sp3 := read_byte()
	time = read_unsigned()
	var struct_size := CarContObj.STRUCT_SIZE
	object.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"CSCAction": csc_action,
		"Time": time,
		"C": object.get_dictionary(),
	}


func _get_pretty_text() -> String:
	var action := "started" if csc_action == InSim.CSCAction.CSC_START else "stopped"
	return "PLID %d %s moving at %.1v" % [plid, action, object.gis_position]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "CSCAction", "Time", "C"]):
		return
	plid = dict["PLID"]
	csc_action = dict["CSCAction"]
	time = dict["Time"]
	object.set_from_dictionary(dict["C"] as Dictionary)


func _update_gis_values() -> void:
	gis_time = time / TIME_MULTIPLIER
