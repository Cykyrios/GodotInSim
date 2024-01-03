class_name InSimCSCPacket
extends InSimPacket


const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_CSC
var player_id := 0

var sp0 := 0
var csc_action := InSim.CSCAction.CSC_START
var sp2 := 0
var sp3 := 0

var time := 0
var object := CarContObj.new()


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
	csc_action = read_byte(packet) as InSim.CSCAction
	sp2 = read_byte(packet)
	sp3 = read_byte(packet)
	time = read_word(packet)
	var struct_size := CarContObj.STRUCT_SIZE
	object.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size


func _get_data_dictionary() -> Dictionary:
	var data := {
		"PLID": player_id,
		"Sp0": sp0,
		"CSCAction": csc_action,
		"Sp2": sp2,
		"Sp3": sp3,
		"Time": time,
		"C": object,
	}
	return data
