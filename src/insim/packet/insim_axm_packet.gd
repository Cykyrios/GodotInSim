class_name InSimAXMPacket
extends InSimPacket

## AutoX Multiple objects packet

const MIN_OBJECTS := 0
const MAX_OBJECTS := 60
const PACKET_BASE_SIZE := 8
const PACKET_MIN_SIZE := PACKET_BASE_SIZE + MIN_OBJECTS * ObjectInfo.STRUCT_SIZE
const PACKET_MAX_SIZE := PACKET_BASE_SIZE + MAX_OBJECTS * ObjectInfo.STRUCT_SIZE
const PACKET_TYPE := InSim.Packet.ISP_AXM

var num_objects := 0

var ucid := 0  ## unique id of the connection that sent the packet
var pmo_action := InSim.PMOAction.PMO_NUM  ## see [enum InSim.PMOAction]
var pmo_flags := 0  ## see [enum InSim.PMOFlags]
var sp3 := 0

var info: Array[ObjectInfo] = []


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE
	receivable = true
	sendable = true


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
	num_objects = read_byte()
	ucid = read_byte()
	pmo_action = read_byte() as InSim.PMOAction
	pmo_flags = read_byte()
	sp3 = read_byte()
	info.clear()
	var struct_size := ObjectInfo.STRUCT_SIZE
	for i in num_objects:
		var object_info := ObjectInfo.new()
		object_info.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
		data_offset += struct_size
		info.append(object_info)


func _fill_buffer() -> void:
	super()
	num_objects = mini(num_objects, info.size())
	add_byte(num_objects)
	add_byte(ucid)
	add_byte(pmo_action)
	add_byte(pmo_flags)
	add_byte(sp3)
	resize_buffer(PACKET_BASE_SIZE + num_objects * ObjectInfo.STRUCT_SIZE)
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


static func create(
	axm_num_objects: int, axm_ucid: int, axm_action: InSim.PMOAction, axm_flags: int,
	axm_info: Array[ObjectInfo]
) -> InSimAXMPacket:
	var packet := InSimAXMPacket.new()
	packet.num_objects = axm_num_objects
	packet.ucid = axm_ucid
	packet.pmo_action = axm_action
	packet.pmo_flags = axm_flags
	packet.info = axm_info.duplicate()
	return packet


func trim_packet_size() -> void:
	size = PACKET_BASE_SIZE + num_objects * ObjectInfo.STRUCT_SIZE
	resize_buffer(size)
