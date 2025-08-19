class_name InSimAICPacket
extends InSimPacket
## AI Control packet
##
## This packet is sent to control an AI car.

const MAX_INPUTS := 20  ## Maximum number of inputs in the packet
const PACKET_MIN_SIZE := 4  ## Minimum packet size
const PACKET_MAX_SIZE := 4 + MAX_INPUTS * AIInputVal.STRUCT_SIZE  ## Maximum packet size
const PACKET_TYPE := InSim.Packet.ISP_AIC  ## The packet's type, see [enum InSim.Packet].

var plid := 0  ## Unique ID of AI player to control

var inputs: Array[AIInputVal] = []  ## Array of AI inputs


## Creates and returns a new [InSimAICPacket] from the given parameters.
static func create(car_plid: int, car_inputs: Array[AIInputVal] = []) -> InSimAICPacket:
	var packet := InSimAICPacket.new()
	packet.plid = car_plid
	packet.inputs = car_inputs.duplicate()
	return packet


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE
	sendable = true


func _fill_buffer() -> void:
	super()
	add_byte(plid)
	if inputs.size() > MAX_INPUTS:
		var _discard := inputs.resize(MAX_INPUTS)
	for input in inputs:
		add_byte(input.input)
		add_byte(input.time)
		add_word(input.value)
	resize_buffer(PACKET_MIN_SIZE + inputs.size() * AIInputVal.STRUCT_SIZE)


func _get_data_dictionary() -> Dictionary:
	var input_dicts: Array[Dictionary] = []
	for input in inputs:
		input_dicts.append(input.get_dictionary())
	return {
		"PLID": plid,
		"Inputs": input_dicts,
	}


func _get_pretty_text() -> String:
	var input_array: Array[String] = []
	for i in inputs.size():
		var input := inputs[i]
		input_array.append("%s (%d, %d ms)" % [
			InSim.AIControl.find_key(input.input), input.value, input.time * 10
		])
	return "PLID %d input: %s" % [plid, input_array]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["PLID", "Inputs"]):
		return
	plid = dict["PLID"]
	inputs.clear()
	for input_dict in dict["Inputs"] as Array[Dictionary]:
		var input := AIInputVal.new()
		input.set_from_dictionary(input_dict)
		inputs.append(input)
