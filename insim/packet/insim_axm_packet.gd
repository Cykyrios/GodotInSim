class_name InSimAXMPacket
extends InSimPacket


const MIN_OBJECTS := 0
const MAX_OBJECTS := 60
const PACKET_BASE_SIZE := 8
const PACKET_MIN_SIZE := PACKET_BASE_SIZE + MIN_OBJECTS * ObjectInfo.STRUCT_SIZE
const PACKET_MAX_SIZE := PACKET_BASE_SIZE + MAX_OBJECTS * ObjectInfo.STRUCT_SIZE
const PACKET_TYPE := InSim.Packet.ISP_AXM

var num_objects := 0

var ucid := 0
var pmo_action := InSim.PMOAction.PMO_NUM
var pmo_flags := 0
var sp3 := 0

var info: Array[ObjectInfo] = []


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
	num_objects = read_byte(packet)
	ucid = read_byte(packet)
	pmo_action = read_byte(packet) as InSim.PMOAction
	pmo_flags = read_byte(packet)
	sp3 = read_byte(packet)
	info.clear()
	var struct_size := ObjectInfo.STRUCT_SIZE
	for i in num_objects:
		var object_info := ObjectInfo.new()
		object_info.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
		data_offset += struct_size
		info.append(object_info)


func _fill_buffer() -> void:
	super()
	add_byte(num_objects)
	add_byte(ucid)
	add_byte(pmo_action)
	add_byte(pmo_flags)
	add_byte(sp3)
	for i in num_objects:
		var info_buffer := info[i].get_buffer()
		for byte in info_buffer:
			add_byte(byte)


func _get_data_dictionary() -> Dictionary:
	return {
		"NumO": num_objects,
		"UCID": ucid,
		"PMOAction": pmo_action,
		"PMOFlags": pmo_flags,
		"Sp3": sp3,
		"Info": info,
	}


func trim_packet_size() -> void:
	size = PACKET_BASE_SIZE + num_objects * ObjectInfo.STRUCT_SIZE
	resize_buffer(size)
