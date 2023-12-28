class_name InSim
extends RefCounted


enum PacketIdentifier {
	ISP_NONE,
	ISP_ISI,
	ISP_VER,
	ISP_TINY,
	ISP_SMALL,
	ISP_STA,
	ISP_SCH,
	ISP_SFP,
	ISP_SCC,
	ISP_CPP,
	ISP_ISM,
	ISP_MSO,
	ISP_III,
	ISP_MST,
	ISP_MTC,
	ISP_MOD,
	ISP_VTN,
	ISP_RST,
	ISP_NCN,
	ISP_CNL,
	ISP_CPR,
	ISP_NPL,
	ISP_PLP,
	ISP_PLL,
	ISP_LAP,
	ISP_SPX,
	ISP_PIT,
	ISP_PSF,
	ISP_PLA,
	ISP_CCH,
	ISP_PEN,
	ISP_TOC,
	ISP_FLG,
	ISP_PFL,
	ISP_FIN,
	ISP_RES,
	ISP_REO,
	ISP_NLP,
	ISP_MCI,
	ISP_MSX,
	ISP_MSL,
	ISP_CRS,
	ISP_BFN,
	ISP_AXI,
	ISP_AXO,
	ISP_BTN,
	ISP_BTC,
	ISP_BTT,
	ISP_RIP,
	ISP_SSH,
	ISP_CON,
	ISP_OBH,
	ISP_HLV,
	ISP_PLC,
	ISP_AXM,
	ISP_ACR,
	ISP_HCP,
	ISP_NCI,
	ISP_JRR,
	ISP_UCO,
	ISP_OCO,
	ISP_TTC,
	ISP_SLC,
	ISP_CSC,
	ISP_CIM,
	ISP_MAL,
	ISP_PLH,
}
enum ISFFlag {
	ISF_RES_0 = 1,
	ISF_RES_1 = 2,
	ISF_LOCAL = 4,
	ISF_MSO_COLS = 8,
	ISF_NLP = 16,
	ISF_MCI = 32,
	ISF_CON = 64,
	ISF_OBH = 128,
	ISF_HLV = 256,
	ISF_AXM_LOAD = 512,
	ISF_AXM_EDIT = 1024,
	ISF_REQ_JOIN = 2048,
}
enum TinyPacket {
	NONE,
	VER,
	CLOSE,
	PING,
	REPLY,
	VTC,
	SCP,
	SST,
	GTH,
	MPE,
	ISM,
	REN,
	CLR,
	NCN,
	NPL,
	RES,
	NLP,
	MCI,
	REO,
	RST,
	AXI,
	AXC,
	RIP,
	NCI,
	ALC,
	AXM,
	SLC,
	MAL,
	PLH,
}
enum SmallPacket {
	NONE,
	SSP,
	SSG,
	VTA,
	TMS,
	STP,
	RTP,
	NLI,
	ALC,
	LCS,
	LCL,
}

const VERSION := 9

var address := "127.0.0.1"
var insim_port := 29_999

var socket: PacketPeerUDP = null


func initialize() -> void:
	socket = PacketPeerUDP.new()
	var error := socket.connect_to_host(address, insim_port)
	if error != OK:
		push_error(error)
	var initialization_packet := InSimISIPacket.new(VERSION)
	fill_in_initialization_packet(initialization_packet)
	socket.put_packet(initialization_packet.buffer)


func fill_in_initialization_packet(initialization_packet: InSimISIPacket) -> void:
	# TODO: Add GUI options to fill buffer
	initialization_packet.fill_buffer()


func start_sending_gauges() -> void:
	if not socket:
		return
	var packet := PackedByteArray()
	packet.resize(8)
	packet.encode_u8(0, 2)
	packet.encode_u8(1, PacketIdentifier.ISP_SMALL)
	packet.encode_u8(2, 0)
	packet.encode_u8(3, SmallPacket.SSG)
	packet.encode_u32(4, 1)
	socket.put_packet(packet)


func close() -> void:
	if not socket:
		return
	var packet := PackedByteArray()
	packet.resize(4)
	packet.encode_u8(0, 1)
	packet.encode_u8(1, PacketIdentifier.ISP_TINY)
	packet.encode_u8(2, 0)
	packet.encode_u8(3, TinyPacket.CLOSE)
	socket.put_packet(packet)
