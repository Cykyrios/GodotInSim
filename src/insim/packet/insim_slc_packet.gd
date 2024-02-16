class_name InSimSLCPacket
extends InSimPacket

## SeLected Car packet - sent when a connection selects a car (empty if no car)

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_SLC
var ucid := 0  ## connection's unique id (0 = host)

var car_name := ""  ## car name


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	ucid = read_byte()
	car_name = read_car_name()


func _get_data_dictionary() -> Dictionary:
	return {
		"UCID": ucid,
		"CName": car_name,
	}
