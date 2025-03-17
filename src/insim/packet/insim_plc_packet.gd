class_name InSimPLCPacket
extends InSimPacket

## PLayer Cars packet

const PACKET_SIZE := 12
const PACKET_TYPE := InSim.Packet.ISP_PLC
var zero := 0

var ucid := 0  ## connection's unique id (0 = host / 255 = all)
var sp1 := 0
var sp2 := 0
var sp3 := 0

var cars := 0  ## allowed cars - see [enum InSim.Car]


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_byte(ucid)
	add_byte(sp1)
	add_byte(sp2)
	add_byte(sp3)
	add_unsigned(cars)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"UCID": ucid,
		"Sp1": sp1,
		"Sp2": sp2,
		"Sp3": sp3,
		"Cars": cars,
	}


func _get_pretty_text() -> String:
	var car_array: Array[String] = []
	for i in InSim.Car.size():
		if InSim.Car.values()[i] in [InSim.Car.CAR_NONE, InSim.Car.CAR_ALL]:
			continue
		if cars & InSim.Car.values()[i]:
			car_array.append((InSim.Car.keys()[i] as String).split("_")[-1])
	var car_list := "NONE" if cars == InSim.Car.CAR_NONE else "ALL" if cars == InSim.Car.CAR_ALL \
			else ""
	if car_list.is_empty():
		for i in car_array.size():
			car_list += "%s%s" % ["" if i == 0 else ", ", car_array[i]]
	return "Allowed cars for %s: %s" % ["everyone" if ucid == 255 else "host" if ucid == 0 \
			else "UCID %d" % [ucid], car_list]


static func create(plc_ucid: int, plc_cars: int) -> InSimPLCPacket:
	var packet := InSimPLCPacket.new()
	packet.ucid = plc_ucid
	packet.cars = plc_cars
	return packet
