class_name InSimAIIPacket
extends InSimPacket

## AI Info packet

const PACKET_SIZE := 96
const PACKET_TYPE := InSim.Packet.ISP_AII

var plid := 0

var outsim_data := OutSimMain.new()

var flags := 0  ## Value to set
var gear := 0  ## Reverse:0, Neutral:1, First:2...
var sp2 := 0
var sp3 := 0

var rpm := 0.0
var spf0 := 0.0
var spf1 := 0.0

var show_lights := 0  ## Dash lights currently switched on (see [OutGaugePacket.DLFlags])
var spu1 := 0
var spu2 := 0
var spu3 := 0


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
	var data_offset_end := InSimPacket.HEADER_SIZE + OutSimMain.STRUCT_SIZE
	outsim_data.set_from_buffer(packet.slice(InSimPacket.HEADER_SIZE, data_offset_end))
	data_offset += OutSimMain.STRUCT_SIZE
	flags = read_byte()
	gear = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()
	rpm = read_float()
	spf0 = read_float()
	spf1 = read_float()
	show_lights = read_unsigned()
	spu1 = read_unsigned()
	spu2 = read_unsigned()
	spu3 = read_unsigned()


func _get_data_dictionary() -> Dictionary:
	return {
		"PLID": plid,
		"OSData": outsim_data,
		"Flags": flags,
		"Gear": gear,
		"Sp2": sp2,
		"Sp3": sp3,
		"RPM": rpm,
		"SpF0": spf0,
		"SpF1": spf1,
		"ShowLights": show_lights,
		"SPU1": spu1,
		"SPU2": spu2,
		"SPU3": spu3,
	}


func _get_pretty_text() -> String:
	var gear_string := "R" if gear == 0 else "N" if gear == 1 else "%d" % [gear + 1]
	return "PLID %d: gear=%s, rpm=%d, flags=%d" % [plid, gear_string, roundi(rpm), flags]
