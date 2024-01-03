class_name InSimAXIPacket
extends InSimPacket


const PACKET_SIZE := 40
const PACKET_TYPE := InSim.Packet.ISP_AXI
var zero := 0

var ax_start := 0
var num_checkpoints := 0
var num_objects := 0

var layout_name := ""


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	zero = read_byte(packet)
	ax_start = read_byte(packet)
	num_checkpoints = read_byte(packet)
	num_objects = read_word(packet)
	layout_name = read_string(packet, 32)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"AXStart": ax_start,
		"NumCP": num_checkpoints,
		"NumO": num_objects,
		"LName": layout_name,
	}
