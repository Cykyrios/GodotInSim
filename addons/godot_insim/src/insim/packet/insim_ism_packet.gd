class_name InSimISMPacket
extends InSimPacket

## InSim Multi packet

const HOST_NAME_LENGTH := 32

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
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
		return
	super(packet)
	zero = read_byte()
	host = read_byte()
	sp1 = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()
	h_name = read_string(HOST_NAME_LENGTH)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"Host": host,
		"Sp1": sp1,
		"Sp2": sp2,
		"Sp3": sp3,
		"HName": h_name,
	}


func _get_pretty_text() -> String:
	return "%s host %s (%s)" % [
		"Current" if req_i != 0 else "Created" if host == 1 else "Joined",
		h_name,
		"host" if host == 1 else "guest"
	]
