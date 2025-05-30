class_name InSimAXIPacket
extends InSimPacket

## AutoX Info packet

const LAYOUT_MAX_LENGTH := 32

const PACKET_SIZE := 40
const PACKET_TYPE := InSim.Packet.ISP_AXI
var zero := 0

var ax_start := 0  ## autocross start position
var num_checkpoints := 0  ## number of checkpoints
var num_objects := 0  ## number of objects

var layout_name := ""  ## the name of the layout last loaded (if loaded locally)


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
	ax_start = read_byte()
	num_checkpoints = read_byte()
	num_objects = read_word()
	layout_name = read_string(LAYOUT_MAX_LENGTH)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"AXStart": ax_start,
		"NumCP": num_checkpoints,
		"NumO": num_objects,
		"LName": layout_name,
	}


func _get_pretty_text() -> String:
	return "%s layout: %s (start %d, %d checkpoints, %d objects)" % [
		"Loaded" if req_i == 0 else "Current", layout_name, ax_start, num_checkpoints, num_objects
	]
