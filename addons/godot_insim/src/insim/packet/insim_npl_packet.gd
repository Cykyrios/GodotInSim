class_name InSimNPLPacket
extends InSimPacket
## New PLayer joining race packet (if [member plid] already exists, then leaving pits)
##
## This packet is received when a player joins the grid/race, tries to join (if the host handles
## join requests), or leaves the pits.

const _MAX_TYRES := 4

const PLAYER_NAME_MAX_LENGTH := 24  ## Player name max length
const PLATE_MAX_LENGTH := 8  ## Plate max length
const SKIN_NAME_MAX_LENGTH := 16  ## Skin name max length

const PACKET_SIZE := 76  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_NPL  ## The packet's type, see [enum InSim.Packet].
var plid := 0  ## Player's newly assigned unique id

var ucid := 0  ## Connection's unique id
var player_type := 0  ## Player type; bit 0: female / bit 1: AI / bit 2: remote.
var flags := 0  ## Player flags (see [enum InSim.PlayerFlag])

var player_name := ""  ## Nickname
var plate := ""  ## Number plate - NO ZERO AT END!

var car_name := ""  ## Car name (skin ID)
var skin_name := ""  ## Skin name
var tyres: Array[InSim.Tyre] = []  ## Tyre compounds

var h_mass := 0  ## Added mass (kg)
var h_tres := 0  ## Intake restriction
var model := 0  ## Driver model
var passengers := 0  ## Passengers byte

var rw_adjust := 0  ## Low 4 bits: tyre width reduction (rear)
var fw_adjust := 0  ## Low 4 bits: tyre width reduction (front)

var setup_flags := 0  ## Setup flags (see [enum InSim.Setup])
var num_players := 0  ## Number in race - ZERO if this is a join request
var config := 0  ## Configuration (0 = DEFAULT, 1 = OPEN ROOF for UF1, ALTERNATE for GTR, etc)
var fuel := 0  ## /showfuel yes: fuel percent / no: 255


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
	ucid = read_byte()
	player_type = read_byte()
	flags = read_word()
	player_name = read_string(PLAYER_NAME_MAX_LENGTH)
	plate = read_string(PLATE_MAX_LENGTH, false)
	car_name = read_car_name()
	skin_name = read_string(SKIN_NAME_MAX_LENGTH)
	tyres.clear()
	for i in _MAX_TYRES:
		tyres.append(read_byte())
	h_mass = read_byte()
	h_tres = read_byte()
	model = read_byte()
	passengers = read_byte()
	rw_adjust = read_byte()
	fw_adjust = read_byte()
	var _sp2 := read_byte()
	var _sp3 := read_byte()
	setup_flags = read_byte()
	num_players = read_byte()
	config = read_byte()
	fuel = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
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
		"SetF": setup_flags,
		"NumP": num_players,
		"Config": config,
		"Fuel": fuel,
	}


func _get_pretty_text() -> String:
	return "PLID %d %s" % [
		plid,
		"is in the pits" if car_name == "000000"
		else "%s (%s)" % [
			"left the pits" if req_i == 0
			else "is driving",
			car_name,
		]
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(
		dict,
		[
			"PLID", "UCID", "PType", "Flags", "PName", "Plate", "CName", "SName",
			"Tyres", "H_Mass", "H_TRes", "Model", "Pass", "RWAdj", "FWAdj", "SetF",
			"NumP", "Config", "Fuel",
		],
	):
		return
	plid = dict["PLID"]
	ucid = dict["UCID"]
	player_type = dict["PType"]
	flags = dict["Flags"]
	player_name = dict["PName"]
	plate = dict["Plate"]
	car_name = dict["CName"]
	skin_name = dict["SName"]
	tyres.assign(dict["Tyres"] as Array[int])
	h_mass = dict["H_Mass"]
	h_tres = dict["H_TRes"]
	model = dict["Model"]
	passengers = dict["Pass"]
	rw_adjust = dict["RWAdj"]
	fw_adjust = dict["FWAdj"]
	setup_flags = dict["SetF"]
	num_players = dict["NumP"]
	config = dict["Config"]
	fuel = dict["Fuel"]
