class_name InSimHCPPacket
extends InSimPacket

## HandiCaPs packet

const MAX_CARS := 32

const PACKET_SIZE := 68
const PACKET_TYPE := InSim.Packet.ISP_HCP
var zero := 0

## h_mass and h_tres for each car: XF GTI = 0 / XR GT = 1 etc[br]
## Subtract 1 from the [enum InSim.Car] enum if using it for array index,
## e.g. [code]InSim.Car.CAR_FBM - 1[/code].
var car_hcp: Array[CarHandicap] = []


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
	return {
		"Zero": zero,
		"CarHCP": car_hcp,
	}


func _get_pretty_text() -> String:
	var handicaps: Array[String] = []
	for i in car_hcp.size():
		var hcp := car_hcp[i]
		handicaps.append("%s (%d/%d)" % [(InSim.Car.keys()[i + 1] as String).split("_")[-1],
				roundi(hcp.gis_mass), hcp.h_tres])
	return "Car handicaps (mass kg/intake %%): %s" % [handicaps]


static func create(hcp_array: Array[CarHandicap]) -> InSimHCPPacket:
	var packet := InSimHCPPacket.new()
	packet.car_hcp = hcp_array.duplicate()
	return packet
