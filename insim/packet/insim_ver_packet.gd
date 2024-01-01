class_name InSimVERPacket
extends InSimPacket


const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_VER
var zero := 0

var version := ""
var product := ""
var insim_ver := 0
var spare := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _get_data_dictionary() -> Dictionary:
	var data := {
		"Zero": zero,
		"Version": version,
		"Product": product,
		"InSimVer": insim_ver,
		"Spare": 0,
	}
	return data


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	zero = read_byte(packet)
	version = read_string(packet, 8)
	product = read_string(packet, 6)
	insim_ver = read_byte(packet)
	spare = read_byte(packet)