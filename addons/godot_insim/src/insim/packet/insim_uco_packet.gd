class_name InSimUCOPacket
extends InSimPacket


const PACKET_SIZE := 28
const PACKET_TYPE := InSim.Packet.ISP_UCO
var player_id := 0

var sp0 := 0
var uco_action := InSim.UCOAction.UCO_CIRCLE_ENTER
var sp2 := 0
var sp3 := 0

var time := 0
var object := CarContObj.new()
var info := ObjectInfo.new()


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
	sp0 = read_byte(packet)
	uco_action = read_byte(packet) as InSim.UCOAction
	sp2 = read_byte(packet)
	sp3 = read_byte(packet)
	time = read_word(packet)
	var struct_size := CarContObj.STRUCT_SIZE
	object.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size
	struct_size = ObjectInfo.STRUCT_SIZE
	object.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"Sp0": sp0,
		"UCOAction": uco_action,
		"Sp2": sp2,
		"Sp3": sp3,
		"Time": time,
		"C": object,
		"Info": info,
	}
