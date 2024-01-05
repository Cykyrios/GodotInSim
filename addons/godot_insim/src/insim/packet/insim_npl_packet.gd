class_name InSimNPLPacket
extends InSimPacket


const SETF_SYMM_WHEELS := 1
const SETF_TC_ENABLE := 2
const SETF_ABS_ENABLE := 4

const MAX_TYRES := 4

const PACKET_SIZE := 76
const PACKET_TYPE := InSim.Packet.ISP_NPL
var player_id := 0

var ucid := 0
var player_type := 0
var flags := 0

var player_name := ""
var plate := ""

var car_name := ""
var skin_name := ""
var tyres: Array[InSim.Tyre] = []

var h_mass := 0
var h_tres := 0
var model := 0
var passengers := 0

var rw_adjust := 0
var fw_adjust := 0
var sp2 := 0
var sp3 := 0

var setup_flags := 0
var num_players := 0
var config := 0
var fuel := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte(packet)
	ucid = read_byte(packet)
	player_type = read_byte(packet)
	flags = read_word(packet)
	player_name = read_string(packet, 24)
	plate = read_string(packet, 8)
	car_name = read_car_name(packet)
	skin_name = read_string(packet, 16)
	tyres.clear()
	for i in MAX_TYRES:
		tyres.append(read_byte(packet))
	h_mass = read_byte(packet)
	h_tres = read_byte(packet)
	model = read_byte(packet)
	passengers = read_byte(packet)
	rw_adjust = read_byte(packet)
	fw_adjust = read_byte(packet)
	sp2 = read_byte(packet)
	sp3 = read_byte(packet)
	setup_flags = read_byte(packet)
	num_players = read_byte(packet)
	config = read_byte(packet)
	fuel = read_byte(packet)


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"UCID": ucid,
		"PType": player_type,
		"Flags": flags,
		"PName": player_name,
		"Plate": plate,
		"CName": car_name,
		"SName": skin_name,
		"Tyres": tyres,
		"H_Mass": h_mass,
		"H_TRes": h_tres,
		"Model": model,
		"Pass": passengers,
		"RWAdj": rw_adjust,
		"FWAdj": fw_adjust,
		"Sp2": sp2,
		"Sp3": sp3,
		"SetF": setup_flags,
		"NumP": num_players,
		"Config": config,
		"Fuel": fuel,
	}
