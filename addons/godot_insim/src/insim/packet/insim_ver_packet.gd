class_name InSimVERPacket
extends InSimPacket
## VERsion packet
##
## This packet is received upon request via [InSim.Tiny.TINY_VER], or as a reply to an
## [InSimISIPacket] with a non-zero request ID.

const VERSION_LENGTH := 8  ## Version text length
const PRODUCT_LENGTH := 6  ## Product text length

const PACKET_SIZE := 20  ## Packet size
const PACKET_TYPE := InSim.Packet.ISP_VER  ## The packet's type, see [enum InSim.Packet].

var zero := 0  ## Zero byte

var version := ""  ## LFS version, e.g. 0.3G
var product := ""  ## Product: DEMO / S1 / S2 / S3
var insim_ver := 0  ## InSim version
var spare := 0  ## Spare


func _init() -> void:
	size = PACKET_SIZE
	type = PACKET_TYPE
	receivable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if packet_size != PACKET_SIZE:
		push_error("%s packet expected size %d, got %d." % [get_type_string(), size, packet_size])
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


func _get_pretty_text() -> String:
	return "%s %s - InSim version %d" % [version, product, insim_ver]
