class_name InSimOBHPacket
extends InSimPacket


enum Flag {
	OBH_LAYOUT = 1,
	OBH_CAN_MOVE = 2,
	OBH_WAS_MOVING = 4,
	OBH_ON_SPOT = 8,
}

const PACKET_SIZE := 24
const PACKET_TYPE := InSim.Packet.ISP_OBH
var player_id := 0

var sp_close := 0
var time := 0

var object := CarContObj.new()

var x := 0
var y := 0

var z := 0
var sp1 := 0
var index := 0
var obh_flags := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte(packet)
	sp_close = read_word(packet)
	time = read_word(packet)
	var struct_size := CarContObj.STRUCT_SIZE
	object.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size
	x = read_short(packet)
	y = read_short(packet)
	z = read_byte(packet)
	sp1 = read_byte(packet)
	index = read_byte(packet)
	obh_flags = read_byte(packet)


func _get_data_dictionary() -> Dictionary:
	var data := {
		"PLID": player_id,
		"SpClose": sp_close,
		"Time": time,
		"C": object,
		"X": x,
		"Y": y,
		"Z": z,
		"Sp1": sp1,
		"Index": index,
		"OBHFlags": obh_flags,
	}
	return data
