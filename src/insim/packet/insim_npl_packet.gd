class_name InSimNPLPacket
extends InSimPacket

## New PLayer joining race packet (if [member player_id] already exists, then leaving pits)

const MAX_TYRES := 4

const PLAYER_NAME_MAX_LENGTH := 24
const PLATE_MAX_LENGTH := 8
const SKIN_NAME_MAX_LENGTH := 16

const PACKET_SIZE := 76
const PACKET_TYPE := InSim.Packet.ISP_NPL
var player_id := 0  ## player's newly assigned unique id

var ucid := 0  ## connection's unique id
var player_type := 0  ## bit 0: female / bit 1: AI / bit 2: remote
var flags := 0  ## player flags (see [enum InSim.Player])

var player_name := ""  ## nickname
var plate := ""  ## number plate - NO ZERO AT END!

var car_name := ""  ## car name
var skin_name := ""  ## skin name - [constant SKIN_NAME_MAX_LENGTH]
var tyres: Array[InSim.Tyre] = []  ## tyre compounds

var h_mass := 0  ## added mass (kg)
var h_tres := 0  ## intake restriction
var model := 0  ## driver model
var passengers := 0  ## passengers byte

var rw_adjust := 0  ## low 4 bits: tyre width reduction (rear)
var fw_adjust := 0  ## low 4 bits: tyre width reduction (front)
var sp2 := 0
var sp3 := 0

var setup_flags := 0  ## setup flags (see [enum InSim.Setup])
var num_players := 0  ## number in race - ZERO if this is a join request
var config := 0  ## configuration (0 = DEFAULT, 1 = OPEN ROOF for UF1/LX4/LX6, ALTERNATE for GTR, etc)
var fuel := 0  ## /showfuel yes: fuel percent / no: 255


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte()
	ucid = read_byte()
	player_type = read_byte()
	flags = read_word()
	player_name = read_string(PLAYER_NAME_MAX_LENGTH)
	plate = read_string(PLATE_MAX_LENGTH)
	car_name = read_car_name()
	skin_name = read_string(SKIN_NAME_MAX_LENGTH)
	tyres.clear()
	for i in MAX_TYRES:
		tyres.append(read_byte())
	h_mass = read_byte()
	h_tres = read_byte()
	model = read_byte()
	passengers = read_byte()
	rw_adjust = read_byte()
	fw_adjust = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()
	setup_flags = read_byte()
	num_players = read_byte()
	config = read_byte()
	fuel = read_byte()


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
