class_name InSimMCIPacket
extends InSimPacket

## Multi Car Info packet - if more than [constant MAX_CARS] in race then more than one is sent

const MAX_CARS := 16
const PACKET_MIN_SIZE := 4 + CompCar.STRUCT_SIZE
const PACKET_MAX_SIZE := 4 + MAX_CARS * CompCar.STRUCT_SIZE
const PACKET_TYPE := InSim.Packet.ISP_MCI

var num_cars := 0  ## number of valid CompCar structs in this packet
var info: Array[CompCar] = []  ## car info for each player, 1 to [constant MAX_CARS]


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
		push_error("%s packet expected size [%d..%d step %d], got %d." % [get_type_string(),
				PACKET_MIN_SIZE, PACKET_MAX_SIZE, SIZE_MULTIPLIER, packet_size])
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
	return {
		"NumC": num_cars,
		"Info": info,
	}


func _get_pretty_text() -> String:
	var text := ""
	for i in info.size():
		var info_string := "PLID %d (P%d, lap %d, node %d)" % [info[i].plid, info[i].position,
				info[i].lap, info[i].node]
		text += "%s%s" % ["" if i == 0 else ", ", info_string]
	return text
