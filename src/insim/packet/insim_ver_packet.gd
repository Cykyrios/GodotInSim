class_name InSimVERPacket
extends InSimPacket

## VERsion packet

const VERSION_LENGTH := 8
const PRODUCT_LENGTH := 6

const PACKET_SIZE := 20
const PACKET_TYPE := InSim.Packet.ISP_VER
var zero := 0

var version := ""  ## LFS version, e.g. 0.3G
var product := ""  ## Product: DEMO / S1 / S2 / S3
var insim_ver := 0  ## InSim version
var spare := 0


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [InSim.Packet.keys()[type], size, packet_size])
		return
	super(packet)
	zero = read_byte()
	version = read_string(VERSION_LENGTH)
	product = read_string(PRODUCT_LENGTH)
	insim_ver = read_byte()
	spare = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"Version": version,
		"Product": product,
		"InSimVer": insim_ver,
		"Spare": 0,
	}
