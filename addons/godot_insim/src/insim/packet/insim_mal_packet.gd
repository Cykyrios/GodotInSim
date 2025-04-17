class_name InSimMALPacket
extends InSimPacket

## Mods ALlowed packet - variable size

const MAL_MAX_MODS := 120
const MAL_DATA_SIZE := 4

const PACKET_MIN_SIZE := 8
const PACKET_MAX_SIZE := PACKET_MIN_SIZE + MAL_MAX_MODS * MAL_DATA_SIZE
const PACKET_TYPE := InSim.Packet.ISP_MAL
var num_mods := 0  ## number of mods in this packet

var ucid := 0  ## unique id of the connection that updated the list
var flags := 0  ## zero (for now)
var sp2 := 0
var sp3 := 0

var skin_id: Array[int] = []  ## skin id of each mod in compressed format, 0 to [constant MAL_MAX_MODS]


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
	num_mods = read_byte()
	ucid = read_byte()
	flags = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()
	skin_id.clear()
	for i in num_mods:
		skin_id.append(read_unsigned())


func _fill_buffer() -> void:
	super()
	update_req_i()
	num_mods = mini(num_mods, skin_id.size())
	add_byte(num_mods)
	add_byte(ucid)
	add_byte(flags)
	add_byte(sp2)
	add_byte(sp3)
	resize_buffer(PACKET_MIN_SIZE + num_mods * MAL_DATA_SIZE)
	for i in num_mods:
		add_unsigned(skin_id[i])


func _get_data_dictionary() -> Dictionary:
	return {
		"NumM": num_mods,
		"UCID": ucid,
		"Flags": flags,
		"Sp2": sp2,
		"Sp3": sp3,
		"SkinID": skin_id,
	}


func _get_pretty_text() -> String:
	var mods := ""
	for i in skin_id.size():
		var id := skin_id[i]
		var id_bytes := PackedByteArray()
		var _resize := id_bytes.resize(4)
		id_bytes.encode_u32(0, id)
		mods += ("" if i == 0 else ", ") + LFSText.car_name_from_lfs_bytes(id_bytes)
	return "Allowed mods: %s" % ["ALL/NONE" if num_mods == 0 else mods]


static func create(
	mal_num: int, mal_ucid: int, mal_flags: int, mal_skin: Array[int]
) -> InSimMALPacket:
	var packet := InSimMALPacket.new()
	packet.num_mods = mal_num
	packet.ucid = mal_ucid
	packet.flags = mal_flags
	packet.skin_id = mal_skin.duplicate()
	return packet
