class_name InSimPacket
extends LFSPacket

## Base InSim packet
##
## This class is generally not intended to be used directly, except when expecting packets
## as arguments without knowing their types in advance. For other cases, using specific packet
## classes is recommended.[br]
## Some parameters listed below are inherited from [LFSPacket].[br]
## [br]
## All InSim packets use a four byte header[br]
## [br]
## [param Size]: total packet size - a multiple of 4[br]
## [param Type]: packet identifier from the ISP_ enum (see below)[br]
## [param ReqI]: non zero if the packet is a packet request or a reply to a request[br]
## [param Data]: the first data byte[br]
## [br]
## Spare bytes and Zero bytes must be filled with ZERO.

const SIZE_MULTIPLIER := 4
const HEADER_SIZE := 4

var receivable := false
var sendable := false

var type := InSim.Packet.ISP_NONE
var req_i := 0


func _init() -> void:
	size = HEADER_SIZE


func _to_string() -> String:
	return "%s: %s" % [InSim.Packet.keys()[type], buffer]


func _get_data_dictionary() -> Dictionary:
	return {}


func _get_dictionary() -> Dictionary:
	var data := _get_data_dictionary()
	var dict := {
		"Size": size,
		"Type": type,
		"ReqI": req_i,
	}
	dict.merge(data)
	return dict


static func create_packet_from_buffer(packet_buffer: PackedByteArray) -> InSimPacket:
	var packet_type := InSimPacket.decode_packet_type(packet_buffer)
	var packet := InSimPacket.new()
	match packet_type:
		InSim.Packet.ISP_NONE:
			packet = InSimPacket.new()
		InSim.Packet.ISP_ISI:
			packet = InSimISIPacket.new()
		InSim.Packet.ISP_VER:
			packet = InSimVERPacket.new()
		InSim.Packet.ISP_TINY:
			packet = InSimTinyPacket.new()
		InSim.Packet.ISP_SMALL:
			packet = InSimSmallPacket.new()
		InSim.Packet.ISP_STA:
			packet = InSimSTAPacket.new()
		InSim.Packet.ISP_SFP:
			packet = InSimSFPPacket.new()
		InSim.Packet.ISP_MOD:
			packet = InSimMODPacket.new()
		InSim.Packet.ISP_MSO:
			packet = InSimMSOPacket.new()
		InSim.Packet.ISP_III:
			packet = InSimIIIPacket.new()
		InSim.Packet.ISP_ACR:
			packet = InSimACRPacket.new()
		InSim.Packet.ISP_TTC:
			packet = InSimTTCPacket.new()
		InSim.Packet.ISP_ISM:
			packet = InSimISMPacket.new()
		InSim.Packet.ISP_PLH:
			packet = InSimPLHPacket.new()
		InSim.Packet.ISP_VTN:
			packet = InSimVTNPacket.new()
		InSim.Packet.ISP_NCN:
			packet = InSimNCNPacket.new()
		InSim.Packet.ISP_NCI:
			packet = InSimNCIPacket.new()
		InSim.Packet.ISP_RST:
			packet = InSimRSTPacket.new()
		InSim.Packet.ISP_SLC:
			packet = InSimSLCPacket.new()
		InSim.Packet.ISP_MAL:
			packet = InSimMALPacket.new()
		InSim.Packet.ISP_CIM:
			packet = InSimCIMPacket.new()
		InSim.Packet.ISP_CNL:
			packet = InSimCNLPacket.new()
		InSim.Packet.ISP_CPR:
			packet = InSimCPRPacket.new()
		InSim.Packet.ISP_NPL:
			packet = InSimNPLPacket.new()
		InSim.Packet.ISP_PLP:
			packet = InSimPLPPacket.new()
		InSim.Packet.ISP_PLL:
			packet = InSimPLLPacket.new()
		InSim.Packet.ISP_CRS:
			packet = InSimCRSPacket.new()
		InSim.Packet.ISP_LAP:
			packet = InSimLAPPacket.new()
		InSim.Packet.ISP_SPX:
			packet = InSimSPXPacket.new()
		InSim.Packet.ISP_PIT:
			packet = InSimPITPacket.new()
		InSim.Packet.ISP_PSF:
			packet = InSimPSFPacket.new()
		InSim.Packet.ISP_PLA:
			packet = InSimPLAPacket.new()
		InSim.Packet.ISP_CCH:
			packet = InSimCCHPacket.new()
		InSim.Packet.ISP_PEN:
			packet = InSimPENPacket.new()
		InSim.Packet.ISP_TOC:
			packet = InSimTOCPacket.new()
		InSim.Packet.ISP_FLG:
			packet = InSimFLGPacket.new()
		InSim.Packet.ISP_PFL:
			packet = InSimPFLPacket.new()
		InSim.Packet.ISP_FIN:
			packet = InSimFINPacket.new()
		InSim.Packet.ISP_RES:
			packet = InSimRESPacket.new()
		InSim.Packet.ISP_REO:
			packet = InSimREOPacket.new()
		InSim.Packet.ISP_AXI:
			packet = InSimAXIPacket.new()
		InSim.Packet.ISP_AXO:
			packet = InSimAXOPacket.new()
		InSim.Packet.ISP_CON:
			packet = InSimCONPacket.new()
		InSim.Packet.ISP_CSC:
			packet = InSimCSCPacket.new()
		InSim.Packet.ISP_HLV:
			packet = InSimHLVPacket.new()
		InSim.Packet.ISP_JRR:
			packet = InSimJRRPacket.new()
		InSim.Packet.ISP_MCI:
			packet = InSimMCIPacket.new()
		InSim.Packet.ISP_NLP:
			packet = InSimNLPPacket.new()
		InSim.Packet.ISP_OBH:
			packet = InSimOBHPacket.new()
		InSim.Packet.ISP_OCO:
			packet = InSimOCOPacket.new()
		InSim.Packet.ISP_UCO:
			packet = InSimUCOPacket.new()
		InSim.Packet.ISP_AXM:
			packet = InSimAXMPacket.new()
		InSim.Packet.ISP_BFN:
			packet = InSimBFNPacket.new()
		InSim.Packet.ISP_BTC:
			packet = InSimBTCPacket.new()
		InSim.Packet.ISP_BTN:
			packet = InSimBTNPacket.new()
		InSim.Packet.ISP_BTT:
			packet = InSimBTTPacket.new()
		InSim.Packet.ISP_CPP:
			packet = InSimCPPPacket.new()
		InSim.Packet.ISP_RIP:
			packet = InSimRIPPacket.new()
		InSim.Packet.ISP_SCC:
			packet = InSimSCCPacket.new()
		InSim.Packet.ISP_SSH:
			packet = InSimSSHPacket.new()
		_:
			push_error("%s packets are not supported at this time." % [InSim.Packet.keys()[packet_type]])
			return packet
	packet.decode_packet(packet_buffer)
	return packet


static func decode_packet_type(packet_buffer: PackedByteArray) -> InSim.Packet:
	var packet_type := InSim.Packet.ISP_NONE
	if packet_buffer.size() < HEADER_SIZE:
		push_error("Packet is smaller than InSim packet header.")
	packet_type = packet_buffer.decode_u8(1) as InSim.Packet
	return packet_type


func decode_header(packet_buffer: PackedByteArray) -> void:
	if packet_buffer.size() < HEADER_SIZE:
		push_error("Buffer is smaller than InSim packet header.")
		return
	data_offset = 0
	size = read_byte() * SIZE_MULTIPLIER
	type = read_byte() as InSim.Packet
	req_i = read_byte()


func write_header() -> void:
	resize_buffer(size)
	data_offset = 0
	@warning_ignore("integer_division")
	add_byte(size / SIZE_MULTIPLIER)
	add_byte(type)
	add_byte(req_i)
	add_byte(0)
	data_offset = HEADER_SIZE - 1


func update_req_i() -> void:
	buffer.encode_u8(2, req_i)


func resize_buffer(new_size: int) -> void:
	size = new_size
	_adjust_packet_size()
	var _discard := buffer.resize(size)
	@warning_ignore("integer_division")
	buffer.encode_u8(0, size / SIZE_MULTIPLIER)


# All packets have a size equal to a multiple of 4
func _adjust_packet_size() -> void:
	var remainder := size % SIZE_MULTIPLIER
	if remainder > 0:
		size += SIZE_MULTIPLIER - remainder


func _fill_buffer() -> void:
	write_header()


func _decode_packet(packet_buffer: PackedByteArray) -> void:
	super(packet_buffer)
	decode_header(packet_buffer)
