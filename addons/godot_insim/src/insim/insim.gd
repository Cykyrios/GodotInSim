class_name InSim
extends Node


signal packet_received(packet: InSimPacket)
signal isp_ver_received(packet: InSimVERPacket)
signal isp_tiny_received(packet: InSimTinyPacket)
signal isp_small_received(packet: InSimSmallPacket)
signal isp_sta_received(packet: InSimSTAPacket)
signal isp_cpp_received(packet: InSimCPPPacket)
signal isp_ism_received(packet: InSimISMPacket)
signal isp_mso_received(packet: InSimMSOPacket)
signal isp_iii_received(packet: InSimIIIPacket)
signal isp_vtn_received(packet: InSimVTNPacket)
signal isp_rst_received(packet: InSimRSTPacket)
signal isp_ncn_received(packet: InSimNCNPacket)
signal isp_cnl_received(packet: InSimCNLPacket)
signal isp_cpr_received(packet: InSimCPRPacket)
signal isp_npl_received(packet: InSimNPLPacket)
signal isp_plp_received(packet: InSimPLPPacket)
signal isp_pll_received(packet: InSimPLLPacket)
signal isp_lap_received(packet: InSimLAPPacket)
signal isp_spx_received(packet: InSimSPXPacket)
signal isp_pit_received(packet: InSimPITPacket)
signal isp_psf_received(packet: InSimPSFPacket)
signal isp_pla_received(packet: InSimPLAPacket)
signal isp_cch_received(packet: InSimCCHPacket)
signal isp_pen_received(packet: InSimPENPacket)
signal isp_toc_received(packet: InSimTOCPacket)
signal isp_flg_received(packet: InSimFLGPacket)
signal isp_pfl_received(packet: InSimPFLPacket)
signal isp_fin_received(packet: InSimFINPacket)
signal isp_res_received(packet: InSimRESPacket)
signal isp_reo_received(packet: InSimREOPacket)
signal isp_nlp_received(packet: InSimNLPPacket)
signal isp_mci_received(packet: InSimMCIPacket)
signal isp_crs_received(packet: InSimCRSPacket)
signal isp_bfn_received(packet: InSimBFNPacket)
signal isp_axi_received(packet: InSimAXIPacket)
signal isp_axo_received(packet: InSimAXOPacket)
signal isp_btc_received(packet: InSimBTCPacket)
signal isp_btt_received(packet: InSimBTTPacket)
signal isp_rip_received(packet: InSimRIPPacket)
signal isp_ssh_received(packet: InSimSSHPacket)
signal isp_con_received(packet: InSimCONPacket)
signal isp_obh_received(packet: InSimOBHPacket)
signal isp_hlv_received(packet: InSimHLVPacket)
signal isp_axm_received(packet: InSimAXMPacket)
signal isp_acr_received(packet: InSimACRPacket)
signal isp_nci_received(packet: InSimNCIPacket)
signal isp_uco_received(packet: InSimUCOPacket)
signal isp_slc_received(packet: InSimSLCPacket)
signal isp_csc_received(packet: InSimCSCPacket)
signal isp_cim_received(packet: InSimCIMPacket)
signal isp_mal_received(packet: InSimMALPacket)
signal isp_plh_received(packet: InSimPLHPacket)
signal small_vta_received(packet: InSimSmallPacket)
signal small_rtp_received(packet: InSimSmallPacket)
signal small_alc_received(packet: InSimSmallPacket)
signal tiny_reply_received(packet: InSimTinyPacket)
signal tiny_vtc_received(packet: InSimTinyPacket)
signal tiny_mpe_received(packet: InSimTinyPacket)
signal tiny_ren_received(packet: InSimTinyPacket)
signal tiny_clr_received(packet: InSimTinyPacket)
signal tiny_axc_received(packet: InSimTinyPacket)
signal packet_sent(packet: InSimPacket)

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

enum ButtonFunction {
	BFN_DEL_BTN,
	BFN_CLEAR,
	BFN_USER_CLEAR,
	BFN_REQUEST,
}
enum Car {
	CAR_NONE = 0,
	CAR_XFG = 1,
	CAR_XRG = 2,
	CAR_XRT = 4,
	CAR_RB4 = 8,
	CAR_FXO = 0x10,
	CAR_LX4 = 0x20,
	CAR_LX6 = 0x40,
	CAR_MRT = 0x80,
	CAR_UF1 = 0x100,
	CAR_RAC = 0x200,
	CAR_FZ5 = 0x400,
	CAR_FOX = 0x800,
	CAR_XFR = 0x1000,
	CAR_UFR = 0x2000,
	CAR_FO8 = 0x4000,
	CAR_FXR = 0x8000,
	CAR_XRR = 0x10000,
	CAR_FZR = 0x20000,
	CAR_BF1 = 0x40000,
	CAR_FBM = 0x80000,
	CAR_ALL = 0xffffffff
}
enum CSCAction {
	CSC_STOP,
	CSC_START,
}
enum DashLight {
	DL_SHIFT,
	DL_FULLBEAM,
	DL_HANDBRAKE,
	DL_PITSPEED,
	DL_TC,
	DL_SIGNAL_L,
	DL_SIGNAL_R,
	DL_SIGNAL_ANY,
	DL_OILWARN,
	DL_BATTERY,
	DL_ABS,
	DL_ENGINE,
	DL_FOG_REAR,
	DL_FOG_FRONT,
	DL_DIPPED,
	DL_FUELWARN,
	DL_SIDELIGHTS,
	DL_NEUTRAL,
	DL_18,
	DL_19,
	DL_20,
	DL_21,
	DL_22,
	DL_23,
	DL_NUM
}
enum InitFlag {
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
enum InterfaceMode {
	CIM_NORMAL,
	CIM_OPTIONS,
	CIM_HOST_OPTIONS,
	CIM_GARAGE,
	CIM_CAR_SELECT,
	CIM_TRACK_SELECT,
	CIM_SHIFTU,
	CIM_NUM
}
enum InterfaceNormal {
	NRM_NORMAL,
	NRM_WHEEL_TEMPS,
	NRM_WHEEL_DAMAGE,
	NRM_LIVE_SETTINGS,
	NRM_PIT_INSTRUCTIONS,
	NRM_NUM
}
enum InterfaceGarage {
	GRG_INFO,
	GRG_COLOURS,
	GRG_BRAKE_TC,
	GRG_SUSP,
	GRG_STEER,
	GRG_DRIVE,
	GRG_TYRES,
	GRG_AERO,
	GRG_PASS,
	GRG_NUM
}
enum InterfaceShiftU {
	FVM_PLAIN,
	FVM_BUTTONS,
	FVM_EDIT,
	FVM_NUM
}
enum JRRAction {
	JRR_REJECT,
	JRR_SPAWN,
	JRR_2,
	JRR_3,
	JRR_RESET,
	JRR_RESET_NO_REPAIR,
	JRR_6,
	JRR_7
}
enum Language {
	LFS_ENGLISH,
	LFS_DEUTSCH,
	LFS_PORTUGUESE,
	LFS_FRENCH,
	LFS_SUOMI,
	LFS_NORSK,
	LFS_NEDERLANDS,
	LFS_CATALAN,
	LFS_TURKISH,
	LFS_CASTELLANO,
	LFS_ITALIANO,
	LFS_DANSK,
	LFS_CZECH,
	LFS_RUSSIAN,
	LFS_ESTONIAN,
	LFS_SERBIAN,
	LFS_GREEK,
	LFS_POLSKI,
	LFS_CROATIAN,
	LFS_HUNGARIAN,
	LFS_BRAZILIAN,
	LFS_SWEDISH,
	LFS_SLOVAK,
	LFS_GALEGO,
	LFS_SLOVENSKI,
	LFS_BELARUSSIAN,
	LFS_LATVIAN,
	LFS_LITHUANIAN,
	LFS_TRADITIONAL_CHINESE,
	LFS_SIMPLIFIED_CHINESE,
	LFS_JAPANESE,
	LFS_KOREAN,
	LFS_BULGARIAN,
	LFS_LATINO,
	LFS_UKRAINIAN,
	LFS_INDONESIAN,
	LFS_ROMANIAN,
	LFS_NUM_LANG
}
enum LocalCarLights {
	LCL_SET_SIGNALS = 1,
	LCL_SPARE_2 = 2,
	LCL_SET_LIGHTS = 4,
	LCL_SPARE_8 = 8,
	LCL_SET_FOG_REAR = 0x10,
	LCL_SET_FOG_FRONT = 0x20,
	LCL_SET_EXTRA = 0x40,
}
enum LocalCarSwitches {
	LCS_SET_SIGNALS = 1,
	LCS_SET_FLASH = 2,
	LCS_SET_HEADLIGHTS = 4,
	LCS_SET_HORN = 8,
	LCS_SET_SIREN = 16,
}
enum LeaveReason {
	LEAVR_DISCO,
	LEAVR_TIMEOUT,
	LEAVR_LOSTCONN,
	LEAVR_KICKED,
	LEAVR_BANNED,
	LEAVR_SECURITY,
	LEAVR_CPW,
	LEAVR_OOS,
	LEAVR_JOOS,
	LEAVR_HACK,
	LEAVR_NUM
}
enum MessageUserValue {
	MSO_SYSTEM,
	MSO_USER,
	MSO_PREFIX,
	MSO_O,
	MSO_NUM
}
enum MessageSound {
	SND_SILENT,
	SND_MESSAGE,
	SND_SYSMESSAGE,
	SND_INVALIDKEY,
	SND_ERROR,
	SND_NUM
}
enum OCOAction {
	OCO_ZERO,
	OCO_1,
	OCO_2,
	OCO_3,
	OCO_LIGHTS_RESET,
	OCO_LIGHTS_SET,
	OCO_LIGHTS_UNSET,
	OCO_NUM
}
enum Penalty {
	PENALTY_NONE,
	PENALTY_DT,
	PENALTY_DT_VALID,
	PENALTY_SG,
	PENALTY_SG_VALID,
	PENALTY_30,
	PENALTY_45,
	PENALTY_NUM
}
enum PenaltyReason {
	PENR_UNKNOWN,
	PENR_ADMIN,
	PENR_WRONG_WAY,
	PENR_FALSE_START,
	PENR_SPEEDING,
	PENR_STOP_SHORT,
	PENR_STOP_LATE,
	PENR_NUM
}
enum PitLane {
	PITLANE_EXIT,
	PITLANE_ENTER,
	PITLANE_NO_PURPOSE,
	PITLANE_DT,
	PITLANE_SG,
	PITLANE_NUM
}
enum PitWork {
	PSE_NOTHING,
	PSE_STOP,
	PSE_FR_DAM,
	PSE_FR_WHL,
	PSE_LE_FR_DAM,
	PSE_LE_FR_WHL,
	PSE_RI_FR_DAM,
	PSE_RI_FR_WHL,
	PSE_RE_DAM,
	PSE_RE_WHL,
	PSE_LE_RE_DAM,
	PSE_LE_RE_WHL,
	PSE_RI_RE_DAM,
	PSE_RI_RE_WHL,
	PSE_BODY_MINOR,
	PSE_BODY_MAJOR,
	PSE_SETUP,
	PSE_REFUEL,
	PSE_NUM
}
enum PMOAction {
	PMO_LOADING_FILE,
	PMO_ADD_OBJECTS,
	PMO_DEL_OBJECTS,
	PMO_CLEAR_ALL,
	PMO_TINY_AXM,
	PMO_TTC_SEL,
	PMO_SELECTION,
	PMO_POSITION,
	PMO_GET_Z,
	PMO_NUM
}
enum Replay {
	RIP_OK,
	RIP_ALREADY,
	RIP_DEDICATED,
	RIP_WRONG_MODE,
	RIP_NOT_REPLAY,
	RIP_CORRUPTED,
	RIP_NOT_FOUND,
	RIP_UNLOADABLE,
	RIP_DEST_OOB,
	RIP_UNKNOWN,
	RIP_USER,
	RIP_OOS,
}
enum Screenshot {
	SSH_OK,
	SSH_DEDICATED,
	SSH_CORRUPTED,
	SSH_NO_SAVE,
}
enum State {
	ISS_GAME = 1,
	ISS_REPLAY = 2,
	ISS_PAUSED = 4,
	ISS_SHIFTU = 8,
	ISS_DIALOG = 16,
	ISS_SHIFTU_FOLLOW = 32,
	ISS_SHIFTU_NO_OPT = 64,
	ISS_SHOW_2D = 128,
	ISS_FRONT_END = 256,
	ISS_MULTI = 512,
	ISS_MPSPEEDUP = 1024,
	ISS_WINDOWED = 2048,
	ISS_SOUND_MUTE = 4096,
	ISS_VIEW_OVERRIDE = 8192,
	ISS_VISIBLE = 16384,
	ISS_TEXT_ENTRY = 32768,
}
enum Tyre {
	TYRE_R1,
	TYRE_R2,
	TYRE_R3,
	TYRE_R4,
	TYRE_ROAD_SUPER,
	TYRE_ROAD_NORMAL,
	TYRE_HYBRID,
	TYRE_KNOBBLY,
	TYRE_NUM
}
enum UCOAction {
	UCO_CIRCLE_ENTER,
	UCO_CIRCLE_LEAVE,
	UCO_CP_FWD,
	UCO_CP_REV,
}
enum View {
	VIEW_FOLLOW,
	VIEW_HELI,
	VIEW_CAM,
	VIEW_DRIVER,
	VIEW_CUSTOM,
	VIEW_MAX
}
enum Vote {
	VOTE_NONE,
	VOTE_END,
	VOTE_RESTART,
	VOTE_QUALIFY,
	VOTE_NUM
}

const VERSION := 9
const PACKET_READ_INTERVAL := 0.01

var address := "127.0.0.1"
var insim_port := 29_999

var socket: PacketPeerUDP = null
var packet_timer := 0.0


func _ready() -> void:
	socket = PacketPeerUDP.new()

	var _discard := packet_received.connect(_on_packet_received)
	_discard = isp_tiny_received.connect(_on_tiny_packet_received)
	_discard = isp_small_received.connect(_on_small_packet_received)


func _process(delta: float) -> void:
	packet_timer += delta
	if delta >= PACKET_READ_INTERVAL:
		packet_timer = 0
		read_incoming_packets()


func close() -> void:
	if not socket:
		return
	send_packet(InSimTinyPacket.new(0, Tiny.TINY_CLOSE))
	print("Closing InSim connection.")
	socket.close()


func initialize(initialization_data: InSimInitializationData) -> void:
	var error := socket.connect_to_host(address, insim_port)
	if error != OK:
		push_error(error)
	send_packet(create_initialization_packet(initialization_data))


func create_initialization_packet(initialization_data: InSimInitializationData) -> InSimISIPacket:
	var initialization_packet := InSimISIPacket.new()
	initialization_packet.udp_port = initialization_data.udp_port
	initialization_packet.flags = initialization_data.flags
	initialization_packet.prefix = initialization_data.prefix
	initialization_packet.interval = initialization_data.interval
	initialization_packet.admin = initialization_data.admin
	initialization_packet.i_name = initialization_data.i_name
	return initialization_packet


func read_incoming_packets() -> void:
	var packet_buffer := PackedByteArray()
	var packet_type := Packet.ISP_NONE
	while socket.get_available_packet_count() > 0:
		packet_buffer = socket.get_packet()
		var err := socket.get_packet_error()
		if err != OK:
			push_error("Error reading incoming packet: %s" % [err])
			continue
		packet_type = packet_buffer.decode_u8(1) as Packet
		if packet_type != Packet.ISP_NONE:
			var insim_packet := InSimPacket.create_packet_from_buffer(packet_buffer)
			packet_received.emit(insim_packet)


func read_version_packet(packet: InSimVERPacket) -> void:
	if packet.insim_ver != VERSION:
		print("Host InSim version (%d) is different from local version (%d)." % \
				[packet.insim_ver, VERSION])
		close()
		return
	print("Host InSim version matches local version (%d)." % [VERSION])


func send_autocross_info_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_AXI))


func send_autocross_layout_objects_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_AXM))


func send_autocross_editor_selection_request(ucid := 0) -> void:
	send_packet(InSimTTCPacket.new(1, TTC.TTC_SEL, ucid))


func send_camera_position_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_SCP))


func send_change_nlp_mci_rate(interval: int) -> void:
	send_packet(InSimSmallPacket.new(1, Small.SMALL_NLI, interval))


func send_connection_info_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_NCI))


func send_connection_list_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_NCN))


func send_current_time_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_GTH))


func send_get_allowed_cars() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_ALC))


func send_get_allowed_mods() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_MAL))


func send_grid_order_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_REO))


func send_insim_multi_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_ISM))


func send_keep_alive_packet() -> void:
	send_packet(InSimTinyPacket.new(0, Tiny.TINY_NONE))


func send_local_car_lights(lcl: CarLights) -> void:
	send_packet(InSimSmallPacket.new(0, Small.SMALL_LCL, lcl.get_value()))


func send_local_car_switches(lcs: CarSwitches) -> void:
	send_packet(InSimSmallPacket.new(0, Small.SMALL_LCS, lcs.get_value()))


func send_mci_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_MCI))


func send_nlp_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_NLP))


func send_outgauge_request(interval := 1) -> void:
	if not socket:
		return
	send_packet(InSimSmallPacket.new(0, Small.SMALL_SSG, interval))


func send_outsim_request(interval := 1) -> void:
	if not socket:
		return
	send_packet(InSimSmallPacket.new(0, Small.SMALL_SSP, interval))


func send_packet(packet: InSimPacket) -> void:
	packet.fill_buffer()
	var _discard := socket.put_packet(packet.buffer)
	packet_sent.emit(packet)


func send_ping() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_PING))


func send_player_handicaps_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_PLH))


func send_player_list_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_NPL))


func send_race_start_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_RST))


func send_result_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_RES))


func send_replay_information_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_RIP))


func send_selected_car_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_SLC))


func send_set_allowed_cars(allowed_cars: int) -> void:
	send_packet(InSimSmallPacket.new(0, Small.SMALL_ALC, allowed_cars))


func send_state_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_SST))


func send_time_step_request(step: int) -> void:
	send_packet(InSimSmallPacket.new(1, Small.SMALL_TMS, step))


func send_time_stop_request(stop: int) -> void:
	send_packet(InSimSmallPacket.new(1, Small.SMALL_TMS, stop))


func send_version_request() -> void:
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_VER))


func send_vote_cancel() -> void:
	send_packet(InSimTinyPacket.new(0, Tiny.TINY_VTC))


func _on_packet_received(packet: InSimPacket) -> void:
	match packet.type:
		Packet.ISP_VER:
			isp_ver_received.emit(packet)
		Packet.ISP_TINY:
			isp_tiny_received.emit(packet)
		Packet.ISP_SMALL:
			isp_small_received.emit(packet)
		Packet.ISP_STA:
			isp_sta_received.emit(packet)
		Packet.ISP_CPP:
			isp_cpp_received.emit(packet)
		Packet.ISP_ISM:
			isp_ism_received.emit(packet)
		Packet.ISP_MSO:
			isp_mso_received.emit(packet)
		Packet.ISP_III:
			isp_iii_received.emit(packet)
		Packet.ISP_VTN:
			isp_vtn_received.emit(packet)
		Packet.ISP_RST:
			isp_rst_received.emit(packet)
		Packet.ISP_NCN:
			isp_ncn_received.emit(packet)
		Packet.ISP_CNL:
			isp_cnl_received.emit(packet)
		Packet.ISP_CPR:
			isp_cpr_received.emit(packet)
		Packet.ISP_NPL:
			isp_npl_received.emit(packet)
		Packet.ISP_PLP:
			isp_plp_received.emit(packet)
		Packet.ISP_PLL:
			isp_pll_received.emit(packet)
		Packet.ISP_LAP:
			isp_lap_received.emit(packet)
		Packet.ISP_SPX:
			isp_spx_received.emit(packet)
		Packet.ISP_PIT:
			isp_pit_received.emit(packet)
		Packet.ISP_PSF:
			isp_psf_received.emit(packet)
		Packet.ISP_PLA:
			isp_pla_received.emit(packet)
		Packet.ISP_CCH:
			isp_cch_received.emit(packet)
		Packet.ISP_PEN:
			isp_pen_received.emit(packet)
		Packet.ISP_TOC:
			isp_toc_received.emit(packet)
		Packet.ISP_FLG:
			isp_flg_received.emit(packet)
		Packet.ISP_PFL:
			isp_pfl_received.emit(packet)
		Packet.ISP_FIN:
			isp_fin_received.emit(packet)
		Packet.ISP_RES:
			isp_res_received.emit(packet)
		Packet.ISP_REO:
			isp_reo_received.emit(packet)
		Packet.ISP_NLP:
			isp_nlp_received.emit(packet)
		Packet.ISP_MCI:
			isp_mci_received.emit(packet)
		Packet.ISP_CRS:
			isp_crs_received.emit(packet)
		Packet.ISP_BFN:
			isp_bfn_received.emit(packet)
		Packet.ISP_AXI:
			isp_axi_received.emit(packet)
		Packet.ISP_AXO:
			isp_axo_received.emit(packet)
		Packet.ISP_BTC:
			isp_btc_received.emit(packet)
		Packet.ISP_BTT:
			isp_btt_received.emit(packet)
		Packet.ISP_RIP:
			isp_rip_received.emit(packet)
		Packet.ISP_SSH:
			isp_ssh_received.emit(packet)
		Packet.ISP_CON:
			isp_con_received.emit(packet)
		Packet.ISP_OBH:
			isp_obh_received.emit(packet)
		Packet.ISP_HLV:
			isp_hlv_received.emit(packet)
		Packet.ISP_AXM:
			isp_axm_received.emit(packet)
		Packet.ISP_ACR:
			isp_acr_received.emit(packet)
		Packet.ISP_NCI:
			isp_nci_received.emit(packet)
		Packet.ISP_UCO:
			isp_uco_received.emit(packet)
		Packet.ISP_SLC:
			isp_slc_received.emit(packet)
		Packet.ISP_CSC:
			isp_csc_received.emit(packet)
		Packet.ISP_CIM:
			isp_cim_received.emit(packet)
		Packet.ISP_MAL:
			isp_mal_received.emit(packet)
		Packet.ISP_PLH:
			isp_plh_received.emit(packet)
		_:
			push_error("Packet type %s is not supported at this time." % [Packet.keys()[packet.type]])


func _on_small_packet_received(packet: InSimSmallPacket) -> void:
	match packet.sub_type:
		Small.SMALL_VTA:
			small_vta_received.emit(packet)
		Small.SMALL_RTP:
			small_rtp_received.emit(packet)
		Small.SMALL_ALC:
			small_alc_received.emit(packet)
		_:
			push_error("%s with subtype %s is not supported at this time." % \
					[Packet.keys()[packet.type], Small.keys()[packet.sub_type]])


func _on_tiny_packet_received(packet: InSimTinyPacket) -> void:
	match packet.sub_type:
		Tiny.TINY_NONE:
			send_keep_alive_packet()
		Tiny.TINY_REPLY:
			tiny_reply_received.emit(packet)
		Tiny.TINY_VTC:
			tiny_vtc_received.emit(packet)
		Tiny.TINY_MPE:
			tiny_mpe_received.emit(packet)
		Tiny.TINY_REN:
			tiny_ren_received.emit(packet)
		Tiny.TINY_CLR:
			tiny_clr_received.emit(packet)
		Tiny.TINY_AXC:
			tiny_axc_received.emit(packet)
		_:
			push_error("%s with subtype %s is not supported at this time." % \
					[Packet.keys()[packet.type], Tiny.keys()[packet.sub_type]])
