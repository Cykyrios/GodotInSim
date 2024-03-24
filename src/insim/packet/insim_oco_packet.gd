class_name InSimOCOPacket
extends InSimPacket

## Object COntrol packet - currently used for switching start lights

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_OCO
var zero := 0

var oco_action := InSim.OCOAction.OCO_NUM  ## see [enum InSim.OCOAction]
var index := 0  ## see InSim documentation
var identifier := 0  ## identify particular start lights objects (0 to 63 or 255 = all)
var data := 0  ## see InSim documentation


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	zero = read_byte()
	oco_action = read_byte() as InSim.OCOAction
	index = read_byte()
	identifier = read_byte()
	data = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"OCOAction": oco_action,
		"Index": index,
		"Identifier": identifier,
		"Data": data,
	}
