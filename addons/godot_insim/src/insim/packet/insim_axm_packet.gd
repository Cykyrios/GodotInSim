class_name InSimAXMPacket
extends InSimPacket
## AutoX Multiple objects packet
##
## This packet is sent or received from various interactions with the layout editor.

const MIN_OBJECTS := 0  ## Minimum number of objects per packet
const MAX_OBJECTS := 60  ## Maximum number of objects per packet
const PACKET_BASE_SIZE := 8  ## Base packet size
## Minimum packet size
const PACKET_MIN_SIZE := PACKET_BASE_SIZE + MIN_OBJECTS * ObjectInfo.STRUCT_SIZE
## Maximum packet size
const PACKET_MAX_SIZE := PACKET_BASE_SIZE + MAX_OBJECTS * ObjectInfo.STRUCT_SIZE
const PACKET_TYPE := InSim.Packet.ISP_AXM  ## The packet's type, see [enum InSim.Packet].

var num_objects := 0  ## Number of objects in this packet

var ucid := 0  ## unique id of the connection that sent the packet
var pmo_action := InSim.PMOAction.PMO_NUM  ## see [enum InSim.PMOAction]
var pmo_flags := 0  ## see [enum InSim.PMOFlags]
var sp3 := 0  ## Spare

var info: Array[ObjectInfo] = []  ## Object info for all objects in this packet


## Creates and returns a new [InSimAXMPacket] from the given parameters.
static func create(
	axm_num_objects: int, axm_ucid: int, axm_action: InSim.PMOAction, axm_flags := 0,
	axm_info: Array[ObjectInfo] = []
) -> InSimAXMPacket:
	var packet := InSimAXMPacket.new()
	packet.num_objects = axm_num_objects
	packet.ucid = axm_ucid
	packet.pmo_action = axm_action
	packet.pmo_flags = axm_flags
	packet.info = axm_info.duplicate()
	packet._trim_packet_size()
	return packet


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
		push_error("%s packet expected size [%d..%d step %d], got %d." % [get_type_string(),
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
	_trim_packet_size()


func _get_data_dictionary() -> Dictionary:
	var info_dicts: Array[Dictionary] = []
	for object_info in info:
		info_dicts.append(object_info.get_dictionary())
	return {
		"NumO": num_objects,
		"UCID": ucid,
		"PMOAction": pmo_action,
		"PMOFlags": pmo_flags,
		"Info": info_dicts,
	}


func _get_pretty_text() -> String:
	var flags: Array[String] = []
	for i in InSim.PMOFlags.size():
		if pmo_flags & InSim.PMOFlags.values()[i]:
			flags.append(InSim.PMOFlags.keys()[i])
	return "UCID %d: %s for %d object%s%s" % [
		ucid,
		str(InSim.PMOAction.keys()[pmo_action]) if (
			pmo_action in InSim.PMOAction.values()
		) else "INVALID ACTION",
		num_objects,
		"" if num_objects < 2 else "s",
		"" if pmo_flags == 0 else " (%s)" % [flags],
	]


func _set_data_from_dictionary(dict: Dictionary) -> void:
	if not _check_dictionary_keys(dict, ["NumO", "UCID", "PMOAction", "PMOFlags", "Info"]):
		return
	num_objects = dict["NumO"]
	ucid = dict["UCID"]
	pmo_action = dict["PMOAction"]
	pmo_flags = dict["PMOFlags"]
	info.clear()
	for info_dict in dict["Info"] as Array[Dictionary]:
		var object_info := ObjectInfo.new()
		object_info.set_from_dictionary(info_dict)
		info.append(object_info)


func _trim_packet_size() -> void:
	size = PACKET_BASE_SIZE + mini(num_objects, info.size()) * ObjectInfo.STRUCT_SIZE
	resize_buffer(size)
