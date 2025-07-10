class_name InSimMCIPacket
extends InSimPacket
## Multi Car Info packet - if more than [constant MAX_CARS] in race then more than one is sent
##
## This packet is received upon request from a [constant InSim.Tiny.TINY_MCI] or at regular
## intervals if set during InSim initialization or via [constant InSim.Small.SMALL_NLI].

const MAX_CARS := 16  ## Maximum number of car per packet
const PACKET_MIN_SIZE := 4 + CompCar.STRUCT_SIZE  ## Minimum packet size
const PACKET_MAX_SIZE := 4 + MAX_CARS * CompCar.STRUCT_SIZE  ## Maximum packet size
const PACKET_TYPE := InSim.Packet.ISP_MCI  ## The packet's type, see [enum InSim.Packet].

var num_cars := 0  ## Number of valid CompCar structs in this packet
var info: Array[CompCar] = []  ## Car info for each player, 1 to [constant MAX_CARS]


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if (
		packet_size < PACKET_MIN_SIZE
		or packet_size > PACKET_MAX_SIZE
		or packet_size % SIZE_MULTIPLIER != 0
	):
		push_error("%s packet expected size [%d..%d step %d], got %d." % [
			get_type_string(), PACKET_MIN_SIZE, PACKET_MAX_SIZE, SIZE_MULTIPLIER, packet_size
		])
		return
	super(packet)
	num_cars = read_byte()
	info.clear()
	var struct_size := CompCar.STRUCT_SIZE
	for i in num_cars:
		var car_info := CompCar.new()
		car_info.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
		data_offset += struct_size
		info.append(car_info)


func _get_data_dictionary() -> Dictionary:
	var info_dicts: Array[Dictionary] = []
	for comp_car in info:
		info_dicts.append(comp_car.get_dictionary())
	return {
		"NumC": num_cars,
		"Info": info_dicts,
	}


func _get_pretty_text() -> String:
	var text := ""
	for i in info.size():
		var info_string := "PLID %d (P%d, lap %d, node %d)" % [
			info[i].plid, info[i].position, info[i].lap, info[i].node
		]
		text += "%s%s" % ["" if i == 0 else ", ", info_string]
	return text


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["NumC", "Info"]):
		return
	num_cars = dict["NumC"]
	info.clear()
	for info_dict in dict["Info"] as Array[Dictionary]:
		var comp_car := CompCar.new()
		comp_car.set_from_dictionary(info_dict)
		info.append(comp_car)
