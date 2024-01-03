class_name InSimPacket
extends RefCounted


const SIZE_MULTIPLIER := 4
const HEADER_SIZE := 4

var buffer := PackedByteArray()
var size := HEADER_SIZE
var type := InSim.Packet.ISP_NONE
var req_i := 0
var data_offset := 0


func _init() -> void:
	pass


func _to_string() -> String:
	return "%s: %s" % [InSim.Packet.keys()[type], buffer]


func _get_data_dictionary() -> Dictionary:
	return {}


func get_dictionary() -> Dictionary:
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
		_:
			push_error("%s packets are not supported at this time." % [InSim.Packet.keys()[packet_type]])
			return packet
	packet.buffer = packet_buffer
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
	size = read_byte(packet_buffer) * SIZE_MULTIPLIER
	type = read_byte(packet_buffer) as InSim.Packet
	req_i = read_byte(packet_buffer)


func write_header() -> void:
	resize_buffer(size)
	data_offset = 0
	@warning_ignore("integer_division")
	add_byte(size / SIZE_MULTIPLIER)
	add_byte(type)
	add_byte(req_i)
	add_byte(0)
	data_offset = HEADER_SIZE - 1


func add_char(data: String) -> void:
	add_string(1, data)


func add_string(length: int, data: String) -> void:
	var temp_buffer := data.to_utf8_buffer()
	temp_buffer.resize(length)
	for i in length:
		buffer.encode_u8(data_offset, temp_buffer[i])
		data_offset += 1


func add_byte(data: int) -> void:
	if data > 0xFF:
		push_error("Data too large for unsigned byte, max 255, got %d." % [data])
		return
	if data < 0:
		push_error("Data cannot be negative, got %d." % [data])
		return
	buffer.encode_u8(data_offset, data)
	data_offset += 1


func add_word(data: int) -> void:
	var min_value := 0
	var max_value := 0xFFFF
	if data > max_value:
		push_error("Data too large for unsigned word, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data cannot be negative, got %d." % [data])
		return
	buffer.encode_u16(data_offset, data)
	data_offset += 2


func add_short(data: int) -> void:
	var min_value := -0x1000
	var max_value := 0xFFF
	if data > max_value:
		push_error("Data too large for short integer, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data too small for short integer, min %d, got %d." % [min_value, data])
		return
	buffer.encode_s16(data_offset, data)
	data_offset += 2


func add_unsigned(data: int) -> void:
	var min_value := 0
	var max_value := 0xFFFF_FFFF
	if data > max_value:
		push_error("Data too large for unsigned integer, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data cannot be negative, got %d." % [data])
		return
	buffer.encode_u32(data_offset, data)
	data_offset += 4


func add_int(data: int) -> void:
	var min_value := -0x1000_0000
	var max_value := 0xFFF_FFFF
	if data > max_value:
		push_error("Data too large for signed integer, max %d, got %d." % [max_value, data])
		return
	if data < min_value:
		push_error("Data too small for signed integer, min %d, got %d." % [min_value, data])
		return
	buffer.encode_s32(data_offset, data)
	data_offset += 4


func add_float(data: float) -> void:
	buffer.encode_float(data_offset, data)
	data_offset += 4


func update_req_i() -> void:
	buffer.encode_u8(2, req_i)


func read_char(packet: PackedByteArray) -> String:
	return read_string(packet, 1)


func read_string(packet: PackedByteArray, length: int) -> String:
	var temp_buffer := packet.slice(data_offset, data_offset + length)
	var result := temp_buffer.get_string_from_utf8()
	data_offset += length
	return result


func read_byte(packet: PackedByteArray) -> int:
	var result := packet.decode_u8(data_offset)
	data_offset += 1
	return result


func read_word(packet: PackedByteArray) -> int:
	var result := packet.decode_u16(data_offset)
	data_offset += 2
	return result


func read_short(packet: PackedByteArray) -> int:
	var result := packet.decode_s16(data_offset)
	data_offset += 2
	return result


func read_unsigned(packet: PackedByteArray) -> int:
	var result := packet.decode_u32(data_offset)
	data_offset += 4
	return result


func read_int(packet: PackedByteArray) -> int:
	var result := packet.decode_s32(data_offset)
	data_offset += 4
	return result


func read_float(packet: PackedByteArray) -> float:
	var result := packet.decode_float(data_offset)
	data_offset += 4
	return result


func resize_buffer(new_size: int) -> void:
	size = new_size
	_adjust_packet_size()
	buffer.resize(size)
	@warning_ignore("integer_division")
	buffer.encode_u8(0, size / SIZE_MULTIPLIER)


# All packets have a size equal to a multiple of 4
func _adjust_packet_size() -> void:
	var remainder := size % SIZE_MULTIPLIER
	size += remainder


func fill_buffer() -> void:
	_fill_buffer()


func _fill_buffer() -> void:
	write_header()


func decode_packet(packet_buffer: PackedByteArray) -> void:
	_decode_packet(packet_buffer)


func _decode_packet(packet_buffer: PackedByteArray) -> void:
	decode_header(packet_buffer)
