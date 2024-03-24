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
