class_name InSimHCPPacket
extends InSimPacket


const MAX_CARS := 32

const PACKET_SIZE := 68
const PACKET_TYPE := InSim.Packet.ISP_HCP
var zero := 0

var car_hcp: Array[CarHandicap] = []


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	var _discard := car_hcp.resize(MAX_CARS)
	for i in car_hcp.size():
		car_hcp[i] = CarHandicap.new()


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
