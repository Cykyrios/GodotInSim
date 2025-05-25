class_name InSimSLCPacket
extends InSimPacket
## SeLected Car packet - sent when a connection selects a car (empty if no car)
##
## This packet is received when a player selects a vehicle.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_SLC  ## The packet's type, see [enum InSim.Packet].

var ucid := 0  ## Connection's unique id (0 = host)

var car_name := ""  ## Car name (skin ID)


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
	ucid = read_byte()
	car_name = read_car_name()


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"CName": car_name,
	}


func _get_pretty_text() -> String:
	return "UCID %d %s car: %s" % [ucid, "changed" if req_i == 0 else "current",
			car_name if car_name != "000000" else "nothing"]
