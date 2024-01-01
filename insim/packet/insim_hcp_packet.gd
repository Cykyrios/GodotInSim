class_name InSimHCPPacket
extends InSimPacket


const PACKET_SIZE := 68
const PACKET_TYPE := InSim.Packet.ISP_HCP
var zero := 0

var car_hcp: Array[CarHCP] = []


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	car_hcp.resize(32)
	for i in car_hcp.size():
		car_hcp[i] = CarHCP.new()


func _get_data_dictionary() -> Dictionary:
	var data := {
		"Zero": zero,
		"CarHCP": car_hcp,
	}
	return data


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	for i in car_hcp.size():
		add_byte(car_hcp[i].h_mass)
		add_byte(car_hcp[i].h_tres)


class CarHCP extends RefCounted:
	const H_MASS_MAX := 200
	const H_TRES_MAX := 50
	var h_mass := 0:
		set(new_mass):
			h_mass = clampi(new_mass, 0, H_MASS_MAX)
	var h_tres := 0:
		set(new_tres):
			h_tres = clampi(new_tres, 0, H_TRES_MAX)

	func _to_string() -> String:
		return "(%dkg, %d%%)" % [h_mass, h_tres]
