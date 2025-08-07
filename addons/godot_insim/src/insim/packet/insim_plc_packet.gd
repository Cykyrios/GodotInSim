class_name InSimPLCPacket
extends InSimPacket
## PLayer Cars packet
##
## This packet is sent to set the cars allowed for a given player.

const PACKET_SIZE := 12  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_PLC  ## The packet's type, see [enum InSim.Packet].

var ucid := 0  ## Connection's unique id (0 = host / 255 = all)

var cars := 0  ## Allowed cars - see [enum InSim.Car].


## Creates and returns a new [InSimPLCPacket] from the given parameters.
static func create(plc_ucid: int, plc_cars: int) -> InSimPLCPacket:
	var packet := InSimPLCPacket.new()
	packet.ucid = plc_ucid
	packet.cars = plc_cars
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(0)  # zero
	add_byte(ucid)
	add_byte(0)  # sp1
	add_byte(0)  # sp2
	add_byte(0)  # sp3
	add_unsigned(cars)


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"Cars": cars,
	}


func _get_pretty_text() -> String:
	var car_array: Array[String] = []
	for i in InSim.Car.size():
		if InSim.Car.values()[i] in [InSim.Car.CAR_NONE, InSim.Car.CAR_ALL]:
			continue
		if cars & InSim.Car.values()[i]:
			car_array.append((InSim.Car.keys()[i] as String).split("_")[-1])
	var car_list := (
		"NONE" if cars == InSim.Car.CAR_NONE
		else "ALL" if cars == InSim.Car.CAR_ALL
		else ""
	)
	if car_list.is_empty():
		for i in car_array.size():
			car_list += "%s%s" % [
				"" if i == 0 else ", ",
				car_array[i],
			]
	return "Allowed cars for %s: %s" % [
		"everyone" if ucid == InSim.UCID_ALL
		else "UCID %d" % [ucid],
		car_list,
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["UCID", "Cars"]):
		return
	ucid = dict["UCID"]
	cars = dict["Cars"]
