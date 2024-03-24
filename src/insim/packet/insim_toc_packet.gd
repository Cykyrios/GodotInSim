class_name InSimTOCPacket
extends InSimPacket

## Take Over Car packet

const PACKET_SIZE := 8
const PACKET_TYPE := InSim.Packet.ISP_TOC
var player_id := 0  ## player's unique id

var old_ucid := 0  ## old connection's unique id
var new_ucid := 0  ## new connection's unique id
var sp2 := 0
var sp3 := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	player_id = read_byte()
	old_ucid = read_byte()
	new_ucid = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": player_id,
		"OldUCID": old_ucid,
		"NewUCID": new_ucid,
		"Sp2": sp2,
		"Sp3": sp3,
	}
