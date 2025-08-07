class_name InSimOCOPacket
extends InSimPacket
## Object COntrol packet - currently used for switching start lights
##
## This packet is sent to control lights.

const PACKET_SIZE := 8  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_OCO  ## The packet's type, see [enum InSim.Packet].

var action := InSim.OCOAction.OCO_NUM  ## OCO Action, see [enum InSim.OCOAction].
var index := 0  ## Object index, see InSim documentation.
## Light identifier, identifies particular start lights objects (0 to 63 or 255 = all).
var identifier := 0
var data := 0  ## Control data, see InSim documentation.


## Creates and returns a new [InSimOCOPacket] from the given parameters.
static func create(
	oco_action: InSim.OCOAction, oco_index: int, oco_id: int, oco_data: int
) -> InSimOCOPacket:
	var packet := InSimOCOPacket.new()
	packet.action = oco_action
	packet.index = oco_index
	packet.identifier = oco_id
	packet.data = oco_data
	return packet


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(0)  # zero
	add_byte(action)
	add_byte(index)
	add_byte(identifier)
	add_byte(data)


func _get_data_dictionary() -> Dictionary:
	return {
		"OCOAction": action,
		"Index": index,
		"Identifier": identifier,
		"Data": data,
	}


func _get_pretty_text() -> String:
	var details_actions: Array[InSim.OCOAction] = [InSim.OCOAction.OCO_LIGHTS_SET,
			InSim.OCOAction.OCO_LIGHTS_UNSET]
	var details_string := " (index=%d, identifier=%d, data=%d)" % [index, identifier, data]
	return "%s%s" % [
		str(InSim.OCOAction.keys()[action]) if (
			action in InSim.OCOAction.values()
		) else "INVALID ACTION",
		details_string if action in details_actions else ""
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["OCOAction", "Index", "Identifier", "Data"]):
		return
	action = dict["OCOAction"]
	index = dict["Index"]
	identifier = dict["Identifier"]
	data = dict["Data"]
