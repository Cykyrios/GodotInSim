class_name InSimAICPacket
extends InSimPacket

## AI Control packet

const MAX_INPUTS := 20
const PACKET_MIN_SIZE := 4
const PACKET_MAX_SIZE := 4 + MAX_INPUTS * AIInputVal.STRUCT_SIZE
const PACKET_TYPE := InSim.Packet.ISP_AIC

var plid := 0  ## Unique ID of AI player to control

var inputs: Array[AIInputVal] = []


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
	return {
		"PLID": plid,
		"Inputs": inputs,
	}


func _get_pretty_text() -> String:
	var input_array: Array[String] = []
	for i in inputs.size():
		var input := inputs[i]
		input_array.append("%s (%d, %d ms)" % [InSim.AIControl.keys().find(input.input),
				input.value, input.time * 10])
	return "PLID %d input: %s" % [plid, input_array]


static func create(car_plid: int, car_inputs: Array[AIInputVal]) -> InSimAICPacket:
	var packet := InSimAICPacket.new()
	packet.plid = car_plid
	packet.inputs = car_inputs.duplicate()
	return packet
