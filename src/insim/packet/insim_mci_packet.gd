class_name InSimMCIPacket
extends InSimPacket


const MAX_CARS := 16
const PACKET_MIN_SIZE := 4 + CompCar.STRUCT_SIZE
const PACKET_MAX_SIZE := 4 + MAX_CARS * CompCar.STRUCT_SIZE
const PACKET_TYPE := InSim.Packet.ISP_MCI

var num_cars := 0
var info: Array[CompCar] = []


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if (
		packet_size < PACKET_MIN_SIZE
		or packet_size > PACKET_MAX_SIZE
		or packet_size % SIZE_MULTIPLIER != 0
	):
		push_error("%s packet expected size [%d..%d step %d], got %d." % [InSim.Packet.keys()[type],
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
