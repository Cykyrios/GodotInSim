class_name InSim
extends RefCounted


enum Packet {
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
enum Flag {
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
enum Tiny {
	TINY_NONE,
	TINY_VER,
	TINY_CLOSE,
	TINY_PING,
	TINY_REPLY,
	TINY_VTC,
	TINY_SCP,
	TINY_SST,
	TINY_GTH,
	TINY_MPE,
	TINY_ISM,
	TINY_REN,
	TINY_CLR,
	TINY_NCN,
	TINY_NPL,
	TINY_RES,
	TINY_NLP,
	TINY_MCI,
	TINY_REO,
	TINY_RST,
	TINY_AXI,
	TINY_AXC,
	TINY_RIP,
	TINY_NCI,
	TINY_ALC,
	TINY_AXM,
	TINY_SLC,
	TINY_MAL,
	TINY_PLH,
}
enum Small {
	SMALL_NONE,
	SMALL_SSP,
	SMALL_SSG,
	SMALL_VTA,
	SMALL_TMS,
	SMALL_STP,
	SMALL_RTP,
	SMALL_NLI,
	SMALL_ALC,
	SMALL_LCS,
	SMALL_LCL,
}
enum TTC {
	TTC_NONE,
	TTC_SEL,
	TTC_SEL_START,
	TTC_SEL_STOP,
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
	var initialization_packet := InSimISIPacket.new()
	fill_in_initialization_packet(initialization_packet)
	socket.put_packet(initialization_packet.buffer)
	wait_for_version_packet()


func fill_in_initialization_packet(initialization_packet: InSimISIPacket) -> void:
	# TODO: Add GUI options to fill buffer
	initialization_packet.fill_buffer()


func start_sending_gauges() -> void:
	if not socket:
		return
	var packet := PackedByteArray()
	packet.resize(8)
	packet.encode_u8(0, 2)
	packet.encode_u8(1, Packet.ISP_SMALL)
	packet.encode_u8(2, 0)
	packet.encode_u8(3, Small.SMALL_SSG)
	packet.encode_u32(4, 1)
	socket.put_packet(packet)


func close() -> void:
	if not socket:
		return
	var packet := PackedByteArray()
	packet.resize(4)
	packet.encode_u8(0, 1)
	packet.encode_u8(1, Packet.ISP_TINY)
	packet.encode_u8(2, 0)
	packet.encode_u8(3, Tiny.TINY_CLOSE)
	socket.put_packet(packet)


func wait_for_version_packet() -> void:
	var packet := PackedByteArray()
	var packet_type := Packet.ISP_NONE
	while packet_type != Packet.ISP_VER:
		while socket.get_available_packet_count() > 0:
			packet = socket.get_packet()
			packet_type = packet.decode_u8(1) as Packet
			if packet_type != Packet.ISP_NONE:
				print("Received %s packet:" % [Packet.keys()[packet_type]])
				print(packet)
	var version_packet := InSimVERPacket.new()
	version_packet.decode_packet(packet)
	if version_packet.insim_ver != VERSION:
		print("Host InSim version (%d) is different from local version (%d)." % \
				[version_packet.insim_ver, VERSION] + "\nClosing InSim connection.")
		close()
		return
	print("Host InSim version matches local version (%d)." % [VERSION])
