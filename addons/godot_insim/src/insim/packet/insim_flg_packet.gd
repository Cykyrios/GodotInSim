class_name InSimFLGPacket
extends InSimPacket
## FLaG packet - yellow or blue flag changed
##
## This packet is received when a player causes a yellow/blue flag, or that flag is removed.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_FLG  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## player's unique id

var off_on := 0  ## 0 = off / 1 = on
var flag := 0  ## 1 = given blue / 2 = causing yellow
var car_behind := 0  ## unique id of obstructed player


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
	off_on = read_byte()
	flag = read_byte()
	car_behind = read_byte()
	var _sp3 := read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"OffOn": off_on,
		"Flag": flag,
		"CarBehind": car_behind,
	}


func _get_pretty_text() -> String:
	var flag_color := "Blue" if flag == 1 else "Yellow" if flag == 2 else "Unknown"
	var flag_string := " cleared for" if off_on == 0 else " caused by" if flag == 2 else " for"
	return "%s flag%s PLID %d" % [flag_color, flag_string, plid]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "OffOn", "Flag", "CarBehind"]):
		return
	plid = dict["PLID"]
	off_on = dict["OffOn"]
	flag = dict["Flag"]
	car_behind = dict["CarBehind"]
