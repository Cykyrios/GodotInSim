class_name InSimISMPacket
extends InSimPacket

## InSim Multi packet

const PACKET_SIZE := 40
const PACKET_TYPE := InSim.Packet.ISP_ISM
var zero := 0

var host := 0  ## 0 = guest / 1 = host
var sp1 := 0
var sp2 := 0
var sp3 := 0

var h_name := ""  ## the name of the host joined or started


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	zero = read_byte()
	host = read_byte()
	sp1 = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()
	h_name = read_string(32)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"Host": host,
		"Sp1": sp1,
		"Sp2": sp2,
		"Sp3": sp3,
		"HName": h_name,
	}
