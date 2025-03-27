class_name InSimCSCPacket
extends InSimPacket

## Car State Changed packet - reports a change in a car's state (currentl start or stop)

const TIME_MULTIPLIER := 100.0

const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_CSC
var plid := 0  ## player's unique id

var sp0 := 0
var csc_action := InSim.CSCAction.CSC_START
var sp2 := 0
var sp3 := 0

var time := 0  ## hundredths of a second since start (as in [constant InSim.SMALL_RTP])
var object := CarContObj.new()

var gis_time := 0.0


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
	plid = read_byte()
	sp0 = read_byte()
	csc_action = read_byte() as InSim.CSCAction
	sp2 = read_byte()
	sp3 = read_byte()
	time = read_unsigned()
	var struct_size := CarContObj.STRUCT_SIZE
	object.set_from_buffer(packet.slice(data_offset, data_offset + struct_size))
	data_offset += struct_size


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"Sp0": sp0,
		"CSCAction": csc_action,
		"Sp2": sp2,
		"Sp3": sp3,
		"Time": time,
		"C": object,
	}


func _get_pretty_text() -> String:
	var action := "started" if csc_action == InSim.CSCAction.CSC_START else "stopped"
	return "PLID %d %s moving at %.1v" % [plid, action, object.gis_position]


func _update_gis_values() -> void:
	gis_time = time / TIME_MULTIPLIER
