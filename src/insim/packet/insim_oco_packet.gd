class_name InSimOCOPacket
extends InSimPacket

## Object COntrol packet - currently used for switching start lights

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_OCO
var zero := 0

var action := InSim.OCOAction.OCO_NUM  ## see [enum InSim.OCOAction]
var index := 0  ## see InSim documentation
var identifier := 0  ## identify particular start lights objects (0 to 63 or 255 = all)
var data := 0  ## see InSim documentation


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(zero)
	add_byte(action)
	add_byte(index)
	add_byte(identifier)
	add_byte(data)


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"OCOAction": action,
		"Index": index,
		"Identifier": identifier,
		"Data": data,
	}


static func create(
	oco_action: InSim.OCOAction, oco_index: int, oco_id: int, oco_data: int
) -> InSimOCOPacket:
	var packet := InSimOCOPacket.new()
	packet.action = oco_action
	packet.index = oco_index
	packet.identifier = oco_id
	packet.data = oco_data
	return packet
