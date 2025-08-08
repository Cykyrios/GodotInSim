class_name InSimPacket
extends LFSPacket
## Base InSim packet
##
## This class is generally not intended to be used directly, except when expecting packets
## as arguments without knowing their types in advance. For other cases, using specific packet
## classes is recommended.[br]
## Some parameters listed below are inherited from [LFSPacket].[br]
## [br]
## Insim doc excerpt: All InSim packets use a four byte header[br]
## Size: total packet size - a multiple of 4[br]
## Type: packet identifier from the ISP_ enum (see below)[br]
## ReqI: non zero if the packet is a packet request or a reply to a request[br]
## Data: the first data byte[br]
## Spare bytes and Zero bytes must be filled with ZERO.

const INSIM_SIZE_MULTIPLIER := 4  ## Packet size multiplier
const HEADER_SIZE := 4  ## Header size

var size_multiplier := INSIM_SIZE_MULTIPLIER  ## Packet size multiplier

var receivable := false  ## Whether the packet is receivable
var sendable := false  ## Whether the packet is sendable

var type := InSim.Packet.ISP_NONE  ## The packet's type, see [enum InSim.Packet].
var req_i := 0  ## The packet's request ID, used to identify who sent a packet.


## Creates and returns a new [InSimPacket] from the given [param packet_buffer]. The appropriate
## packet subclass is returned.
static func create_packet_from_buffer(packet_buffer: PackedByteArray) -> InSimPacket:
	var packet_type := InSimPacket.decode_packet_type(packet_buffer)
	var packet := create_packet_from_type(packet_type)
	if packet.type not in InSim.Packet.values():
		push_error("%s packets are not supported at this time." % [packet.get_type_string()])
		return packet
	packet.decode_packet(packet_buffer)
	return packet


## Creates and returns a new [InSimPacket] from the given [param dict]. The appropriate
## packet subclass is returned. If the dictionary is invalid, an empty packet is returned.
static func create_packet_from_dictionary(dict: Dictionary) -> InSimPacket:
	if not dict.has("Type"):
		push_error("Cannot create packet from dictionary: unknown or missing type")
		return InSimPacket.new()
	var packet := create_packet_from_type(dict["Type"] as InSim.Packet)
	packet._set_from_dictionary(dict)
	return packet


## Creates and returns a default [InSimPacket] of the given [param packet_type].
## The appropriate packet subclass is returned.
static func create_packet_from_type(packet_type: InSim.Packet) -> InSimPacket:
	var packet := InSimPacket.new()
	match packet_type:
		InSim.Packet.ISP_ACR:
			packet = InSimACRPacket.new()
		InSim.Packet.ISP_AIC:
			packet = InSimAICPacket.new()
		InSim.Packet.ISP_AII:
			packet = InSimAIIPacket.new()
		InSim.Packet.ISP_AXI:
			packet = InSimAXIPacket.new()
		InSim.Packet.ISP_AXM:
			packet = InSimAXMPacket.new()
		InSim.Packet.ISP_AXO:
			packet = InSimAXOPacket.new()
		InSim.Packet.ISP_BFN:
			packet = InSimBFNPacket.new()
		InSim.Packet.ISP_BTC:
			packet = InSimBTCPacket.new()
		InSim.Packet.ISP_BTN:
			packet = InSimBTNPacket.new()
		InSim.Packet.ISP_BTT:
			packet = InSimBTTPacket.new()
		InSim.Packet.ISP_CCH:
			packet = InSimCCHPacket.new()
		InSim.Packet.ISP_CIM:
			packet = InSimCIMPacket.new()
		InSim.Packet.ISP_CNL:
			packet = InSimCNLPacket.new()
		InSim.Packet.ISP_CON:
			packet = InSimCONPacket.new()
		InSim.Packet.ISP_CPP:
			packet = InSimCPPPacket.new()
		InSim.Packet.ISP_CPR:
			packet = InSimCPRPacket.new()
		InSim.Packet.ISP_CRS:
			packet = InSimCRSPacket.new()
		InSim.Packet.ISP_CSC:
			packet = InSimCSCPacket.new()
		InSim.Packet.ISP_FIN:
			packet = InSimFINPacket.new()
		InSim.Packet.ISP_FLG:
			packet = InSimFLGPacket.new()
		InSim.Packet.ISP_HLV:
			packet = InSimHLVPacket.new()
		InSim.Packet.ISP_III:
			packet = InSimIIIPacket.new()
		InSim.Packet.ISP_IPB:
			packet = InSimIPBPacket.new()
		InSim.Packet.ISP_ISI:
			packet = InSimISIPacket.new()
		InSim.Packet.ISP_ISM:
			packet = InSimISMPacket.new()
		InSim.Packet.ISP_JRR:
			packet = InSimJRRPacket.new()
		InSim.Packet.ISP_LAP:
			packet = InSimLAPPacket.new()
		InSim.Packet.ISP_MAL:
			packet = InSimMALPacket.new()
		InSim.Packet.ISP_MCI:
			packet = InSimMCIPacket.new()
		InSim.Packet.ISP_MOD:
			packet = InSimMODPacket.new()
		InSim.Packet.ISP_MSO:
			packet = InSimMSOPacket.new()
		InSim.Packet.ISP_NCI:
			packet = InSimNCIPacket.new()
		InSim.Packet.ISP_NCN:
			packet = InSimNCNPacket.new()
		InSim.Packet.ISP_NLP:
			packet = InSimNLPPacket.new()
		InSim.Packet.ISP_NONE:
			packet = InSimPacket.new()
		InSim.Packet.ISP_NPL:
			packet = InSimNPLPacket.new()
		InSim.Packet.ISP_OBH:
			packet = InSimOBHPacket.new()
		InSim.Packet.ISP_OCO:
			packet = InSimOCOPacket.new()
		InSim.Packet.ISP_PEN:
			packet = InSimPENPacket.new()
		InSim.Packet.ISP_PFL:
			packet = InSimPFLPacket.new()
		InSim.Packet.ISP_PIT:
			packet = InSimPITPacket.new()
		InSim.Packet.ISP_PLA:
			packet = InSimPLAPacket.new()
		InSim.Packet.ISP_PLH:
			packet = InSimPLHPacket.new()
		InSim.Packet.ISP_PLL:
			packet = InSimPLLPacket.new()
		InSim.Packet.ISP_PLP:
			packet = InSimPLPPacket.new()
		InSim.Packet.ISP_PSF:
			packet = InSimPSFPacket.new()
		InSim.Packet.ISP_REO:
			packet = InSimREOPacket.new()
		InSim.Packet.ISP_RES:
			packet = InSimRESPacket.new()
		InSim.Packet.ISP_RIP:
			packet = InSimRIPPacket.new()
		InSim.Packet.ISP_RST:
			packet = InSimRSTPacket.new()
		InSim.Packet.ISP_SCC:
			packet = InSimSCCPacket.new()
		InSim.Packet.ISP_SFP:
			packet = InSimSFPPacket.new()
		InSim.Packet.ISP_SLC:
			packet = InSimSLCPacket.new()
		InSim.Packet.ISP_SMALL:
			packet = InSimSmallPacket.new()
		InSim.Packet.ISP_SPX:
			packet = InSimSPXPacket.new()
		InSim.Packet.ISP_SSH:
			packet = InSimSSHPacket.new()
		InSim.Packet.ISP_STA:
			packet = InSimSTAPacket.new()
		InSim.Packet.ISP_TINY:
			packet = InSimTinyPacket.new()
		InSim.Packet.ISP_TTC:
			packet = InSimTTCPacket.new()
		InSim.Packet.ISP_TOC:
			packet = InSimTOCPacket.new()
		InSim.Packet.ISP_UCO:
			packet = InSimUCOPacket.new()
		InSim.Packet.ISP_VER:
			packet = InSimVERPacket.new()
		InSim.Packet.ISP_VTN:
			packet = InSimVTNPacket.new()
		InSim.Packet.IRP_ARP:
			packet = RelayARPPacket.new()
		InSim.Packet.IRP_ARQ:
			packet = RelayARQPacket.new()
		InSim.Packet.IRP_ERR:
			packet = RelayERRPacket.new()
		InSim.Packet.IRP_HLR:
			packet = RelayHLRPacket.new()
		InSim.Packet.IRP_HOS:
			packet = RelayHOSPacket.new()
		InSim.Packet.IRP_SEL:
			packet = RelaySELPacket.new()
	return packet


## Returns the packet type corresponding to the given [param packet_buffer] data, or
## [constant InSim.Packet.ISP_NONE] is the type cannot be determined.
static func decode_packet_type(packet_buffer: PackedByteArray) -> InSim.Packet:
	if packet_buffer.size() < HEADER_SIZE:
		push_error("Packet is smaller than InSim packet header.")
		return InSim.Packet.ISP_NONE
	return packet_buffer.decode_u8(1) as InSim.Packet


func _init() -> void:
	size = HEADER_SIZE


func _to_string() -> String:
	return "%s: %s" % [get_type_string(), buffer]


## Virtual method overridden by packets. Packets should call [code]super[/code] before doing
## any decoding.
func _decode_packet(packet_buffer: PackedByteArray) -> void:
	super(packet_buffer)
	decode_header(packet_buffer)


## Virtual method overridden by packets. Packets should call [code]super[/code] before filling
## data, as this calls [method write_header].
func _fill_buffer() -> void:
	write_header()


## Override to define packet behavior. This should return all non-header data from the packet.
func _get_data_dictionary() -> Dictionary:
	return {}


func _get_dictionary() -> Dictionary:
	var dict := {
		"Size": size,
		"Type": type,
		"ReqI": req_i,
	}
	dict.merge(_get_data_dictionary())
	return dict


## Override to define packet behavior. This should perform the inverse operation to
## [method _get_data_dictionary], and set the values from the given [param dict].
## Care should be taken to verify keys.
@warning_ignore("unused_parameter")
func _set_data_from_dictionary(dict: Dictionary) -> void:
	pass


func _set_from_dictionary(dict: Dictionary) -> void:
	if dict.has_all(["Size", "ReqI"]):
		size = dict["Size"]
		req_i = dict["ReqI"]
	_set_data_from_dictionary(dict)
	update_gis_values()
	fill_buffer()


## Decodes the header of the given [param packet_buffer].
func decode_header(packet_buffer: PackedByteArray) -> void:
	if packet_buffer.size() < HEADER_SIZE:
		push_error("Buffer is smaller than InSim packet header.")
		return
	data_offset = 0
	size = read_byte() * size_multiplier
	type = read_byte() as InSim.Packet
	req_i = read_byte()


## Returns the packet's type (from [enum InSim.Packet]) as a [String], or [code]UNKNOWN[/code]
## if the type cannot be found.
func get_type_string() -> String:
	var index := InSim.Packet.values().find(type)
	if index == -1:
		return "UNKNOWN"
	return InSim.Packet.keys()[index]


## Resizes the packet's [member LFSPacket.buffer].
func resize_buffer(new_size: int) -> void:
	size = new_size
	_adjust_packet_size()
	var _discard := buffer.resize(size)
	buffer.encode_u8(0, int(size / float(size_multiplier)))


## Encodes the packet's [member req_i] in the [member LFSPacket.buffer].
func update_req_i() -> void:
	buffer.encode_u8(2, req_i)


## Writes the packet's header.
func write_header() -> void:
	resize_buffer(size)
	data_offset = 0
	add_byte(int(size / float(INSIM_SIZE_MULTIPLIER)))
	add_byte(type)
	add_byte(req_i)
	add_byte(0)
	data_offset = HEADER_SIZE - 1


# All packets have a size equal to a multiple of 4
func _adjust_packet_size() -> void:
	var remainder := size % INSIM_SIZE_MULTIPLIER
	if remainder > 0:
		size += INSIM_SIZE_MULTIPLIER - remainder


# For use in _set_data_from_dictionary()
func _check_dictionary_keys(dict: Dictionary, keys: Array[String]) -> bool:
	if not dict.has_all(keys):
		push_error("Cannot set data from dictionary: missing keys")
		return false
	return true
