class_name InSimHCPPacket
extends InSimPacket
## HandiCaPs packet
##
## This packet is sent to set a player's handicaps.

const MAX_CARS := 32  ## Maximum number of player handicaps per packet.

const PACKET_SIZE := 68  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_HCP  ## The packet's type, see [enum InSim.Packet].

var zero := 0  ## Zero byte

## h_mass and h_tres for each car: XF GTI = 0 / XR GT = 1 etc[br]
## Subtract 1 from the [enum InSim.Car] enum if using it for array index,
## e.g. [code]InSim.Car.CAR_FBM - 1[/code].
var car_hcp: Array[CarHandicap] = []


## Creates and returns a new [InSimHCPPacket] from the given [param hcp_array].
static func create(hcp_array: Array[CarHandicap]) -> InSimHCPPacket:
	var packet := InSimHCPPacket.new()
	packet.car_hcp = hcp_array.duplicate()
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	var _discard := car_hcp.resize(MAX_CARS)
	for i in car_hcp.size():
		car_hcp[i] = CarHandicap.new()
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	for i in car_hcp.size():
		add_byte(car_hcp[i].h_mass)
		add_byte(car_hcp[i].h_tres)


func _get_data_dictionary() -> Dictionary:
	var hcp_dicts: Array[Dictionary] = []
	for hcp in car_hcp:
		hcp_dicts.append(hcp.get_dictionary())
	return {
		"CarHCP": hcp_dicts,
	}


func _get_pretty_text() -> String:
	var handicaps: Array[String] = []
	for i in car_hcp.size():
		var hcp := car_hcp[i]
		var car := InSim.Car.keys()[i + 1] as String
		if car == str(InSim.Car.keys()[InSim.Car.values().find(InSim.Car.CAR_ALL)]):
			break
		handicaps.append("%s (%d/%d)" % [(car as String).split("_")[-1],
				roundi(hcp.gis_mass), hcp.h_tres])
	return "Car handicaps (mass kg/intake %%): %s" % [handicaps]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["CarHCP"]):
		return
	car_hcp.clear()
	for hcp_dict in dict["CarHCP"] as Array[Dictionary]:
		var hcp := CarHandicap.new()
		hcp.set_from_dictionary(hcp_dict)
		car_hcp.append(hcp)
