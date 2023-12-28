extends MarginContainer


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

@export var address := "127.0.0.1"
@export var insim_port := 29_999
@export var outgauge_port := 29_998
@export var outsim_port := 29_997

var insim_version := 9

var insim_socket: PacketPeerUDP = null
var outgauge_socket: PacketPeerUDP = null
var outsim_socket: PacketPeerUDP = null

@onready var outgauge_label := %OutGaugeLabel
@onready var outsim_label := %OutSimLabel


func _ready() -> void:
	#initialize_insim()
	initialize_outgauge_socket()
	initialize_outsim_socket()
	#start_sending_gauges()
	#await get_tree().create_timer(10).timeout
	#close_insim()


func _process(_delta: float) -> void:
	update_outgauge()
	update_outsim()


func initialize_insim() -> void:
	insim_socket = PacketPeerUDP.new()
	var error := insim_socket.set_dest_address(address, insim_port)
	print(error)
	error = insim_socket.bind(insim_port, address)
	print(error)

	var insim_initialization_packet := PackedByteArray()
	insim_initialization_packet.resize(44)
	insim_initialization_packet.fill(0)

	insim_initialization_packet.encode_u8(0, 11)
	insim_initialization_packet.encode_u8(1, PacketIdentifier.ISP_ISI)
	insim_initialization_packet.encode_u8(2, 0)
	insim_initialization_packet.encode_u8(3, 0)

	insim_initialization_packet.encode_u16(4, 0)
	insim_initialization_packet.encode_u16(6, ISFFlag.ISF_LOCAL+ISFFlag.ISF_MSO_COLS+ISFFlag.ISF_MCI)

	var encode_string := func encode_string(text: String, offset: int, length: int) -> void:
		var buffer := text.to_utf8_buffer()
		buffer.resize(length)
		for i in buffer.size():
			insim_initialization_packet.encode_u8(offset + i, buffer[i])

	insim_initialization_packet.encode_u8(8, insim_version)
	encode_string.call("", 9, 1)
	insim_initialization_packet.encode_u16(10, 0)

	encode_string.call("password", 12, 16)
	encode_string.call("Super Test", 28, 16)

	print(insim_initialization_packet)
	insim_socket.put_packet(insim_initialization_packet)


func initialize_outgauge_socket() -> void:
	outgauge_socket = PacketPeerUDP.new()
	var error := outgauge_socket.bind(outgauge_port, address)
	if error != OK:
		push_error(error)


func initialize_outsim_socket() -> void:
	outsim_socket = PacketPeerUDP.new()
	var error := outsim_socket.bind(outsim_port, address)
	if error != OK:
		push_error(error)


func start_sending_gauges() -> void:
	if not insim_socket:
		return
	var packet := PackedByteArray()
	packet.resize(8)
	packet.encode_u8(0, 2)
	packet.encode_u8(1, PacketIdentifier.ISP_SMALL)
	packet.encode_u8(2, 0)
	packet.encode_u8(3, SmallPacket.SSG)
	packet.encode_u32(4, 1)
	insim_socket.put_packet(packet)


func close_insim() -> void:
	if not insim_socket:
		return
	var packet := PackedByteArray()
	packet.resize(4)
	packet.encode_u8(0, 1)
	packet.encode_u8(1, PacketIdentifier.ISP_TINY)
	packet.encode_u8(2, 0)
	packet.encode_u8(3, TinyPacket.CLOSE)
	insim_socket.put_packet(packet)


func update_outgauge() -> void:
	var packet := outgauge_socket.get_packet()
	if packet.is_empty():
		return
	var outgauge_packet := OutGaugePacket.new(packet)

	outgauge_label.text = ""
	outgauge_label.text += "%s: %s\n" % ["Time", outgauge_packet.time]
	outgauge_label.text += "%s: %s\n" % ["Car Name", outgauge_packet.car_name]
	outgauge_label.text += "%s: %s\n" % ["Flags", outgauge_packet.get_flags_array()]
	outgauge_label.text += "%s: %s\n" % ["Gear", outgauge_packet.gear]
	outgauge_label.text += "%s: %s\n" % ["Player ID", outgauge_packet.player_id]
	outgauge_label.text += "%s: %s\n" % ["Speed", outgauge_packet.speed]
	outgauge_label.text += "%s: %s\n" % ["RPM", outgauge_packet.rpm]
	outgauge_label.text += "%s: %s\n" % ["Turbo", outgauge_packet.turbo]
	outgauge_label.text += "%s: %s\n" % ["Engine Temperature", outgauge_packet.engine_temp]
	outgauge_label.text += "%s: %s\n" % ["Fuel", outgauge_packet.fuel]
	outgauge_label.text += "%s: %s\n" % ["Oil Pressure", outgauge_packet.oil_pres]
	outgauge_label.text += "%s: %s\n" % ["Oil Temperature", outgauge_packet.oil_temp]
	outgauge_label.text += "%s: %s\n" % ["Available Lights",
			outgauge_packet.get_lights_array(outgauge_packet.dash_lights)]
	outgauge_label.text += "%s: %s\n" % ["Active Lights",
			outgauge_packet.get_lights_array(outgauge_packet.show_lights)]
	outgauge_label.text += "%s: %s\n" % ["Throttle", outgauge_packet.throttle]
	outgauge_label.text += "%s: %s\n" % ["Brake", outgauge_packet.brake]
	outgauge_label.text += "%s: %s\n" % ["Clutch", outgauge_packet.clutch]
	outgauge_label.text += "%s: %s\n" % ["Display 1", outgauge_packet.display1]
	outgauge_label.text += "%s: %s\n" % ["Display 2", outgauge_packet.display2]
	outgauge_label.text += "%s: %s\n" % ["ID", outgauge_packet.id]


func update_outsim() -> void:
	var packet := outsim_socket.get_packet()
	if packet.is_empty():
		return
	var outsim_packet := OutSimPacket.new(packet)

	outsim_label.text = ""
	outsim_label.text += "%s: %s\n" % ["Time", outsim_packet.time]
	outsim_label.text += "%s: %s\n" % ["Angular Velocity", outsim_packet.ang_vel]
	outsim_label.text += "%s: %s\n" % ["Heading", outsim_packet.heading]
	outsim_label.text += "%s: %s\n" % ["Pitch", outsim_packet.pitch]
	outsim_label.text += "%s: %s\n" % ["Roll", outsim_packet.roll]
	outsim_label.text += "%s: %s\n" % ["Acceleration", outsim_packet.accel]
	outsim_label.text += "%s: %s\n" % ["Velocity", outsim_packet.vel]
	outsim_label.text += "%s: %s\n" % ["Position", outsim_packet.pos]
	outsim_label.text += "%s: %s\n" % ["ID", outsim_packet.id]
