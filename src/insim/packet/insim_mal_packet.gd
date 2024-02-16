class_name InSimMALPacket
extends InSimPacket

## Mods ALlowed packet - variable size

const MAL_MAX_MODS := 120
const MAL_DATA_SIZE := 4

const PACKET_MIN_SIZE := 8
const PACKET_MAX_SIZE := 8 + MAL_MAX_MODS * MAL_DATA_SIZE
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
	num_mods = read_byte()
	skin_id.clear()
	for i in num_mods:
		skin_id.append(read_unsigned())


func _fill_buffer() -> void:
	super()
	update_req_i()
	add_byte(num_mods)
	add_byte(ucid)
	add_byte(flags)
	add_byte(sp2)
	add_byte(sp3)
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
