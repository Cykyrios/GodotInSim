class_name InSimVERPacket
extends InSimPacket


var version := ""
var product := ""
var insim_ver := 0
var spare := 0


func _init() -> void:
	size = 20
	type = InSim.Packet.ISP_VER
	super()


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != size:
		push_error("ISP_VER packet expected size %d, got %d." % [size, packet_size])
		return
	version = read_string(packet, 8)
	product = read_string(packet, 6)
	insim_ver = read_byte(packet)
	spare = read_byte(packet)
