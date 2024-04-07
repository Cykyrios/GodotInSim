class_name InSim
extends Node

## InSim for Live for Speed
##
## InSim Library to communicate between Godot and LFS. Most of the documentation is copied
## directly from LFS's InSim.txt documentation file and simply formatted for display here
## or in the appropriate class.[br]
## The full changelog is not included in this documentation.[br]
## [br]
## InSim allows communication between up to 8 external programs and LFS.[br]
## [br]
## TCP or UDP packets can be sent in both directions, LFS reporting various
## things about its state, and the external program requesting info and
## controlling LFS with special packets, text commands or keypresses.[br][br]
## [br]
## INITIALISING InSim[br]
## ==================[br]
## To initialise the InSim system, type into LFS: /insim xxxxx
## where xxxxx is the TCP and UDP port you want LFS to open.[br]
## OR start LFS with the command line option: LFS /insim=xxxxx
## This will make LFS listen for packets on that TCP and UDP port.


signal connected
signal disconnected
signal timeout

signal packet_received(packet: InSimPacket)
signal packet_sent(packet: InSimPacket)
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
signal irp_arp_received(packet: RelayARPPacket)
signal irp_hos_received(packet: RelayHOSPacket)
signal irp_err_received(packet: RelayERRPacket)

enum Packet {
	ISP_NONE,  ## 0: not used
	ISP_ISI,  ## 1 - instruction: insim initialise
	ISP_VER,  ## 2 - info: version info
	ISP_TINY,  ## 3 - both ways: multi purpose
	ISP_SMALL,  ## 4 - both ways: multi purpose
	ISP_STA,  ## 5 - info: state info
	ISP_SCH,  ## 6 - instruction: single character
	ISP_SFP,  ## 7 - instruction: state flags pack
	ISP_SCC,  ## 8 - instruction: set car camera
	ISP_CPP,  ## 9 - both ways: cam pos pack
	ISP_ISM,  ## 10 - info: start multiplayer
	ISP_MSO,  ## 11 - info: message out
	ISP_III,  ## 12 - info: hidden /i message
	ISP_MST,  ## 13 - instruction: type message or /command
	ISP_MTC,  ## 14 - instruction: message to a connection
	ISP_MOD,  ## 15 - instruction: set screen mode
	ISP_VTN,  ## 16 - info: vote notification
	ISP_RST,  ## 17 - info: race start
	ISP_NCN,  ## 18 - info: new connection
	ISP_CNL,  ## 19 - info: connection left
	ISP_CPR,  ## 20 - info: connection renamed
	ISP_NPL,  ## 21 - info: new player (joined race)
	ISP_PLP,  ## 22 - info: player pit (keeps slot in race)
	ISP_PLL,  ## 23 - info: player leave (spectate - loses slot)
	ISP_LAP,  ## 24 - info: lap time
	ISP_SPX,  ## 25 - info: split x time
	ISP_PIT,  ## 26 - info: pit stop start
	ISP_PSF,  ## 27 - info: pit stop finish
	ISP_PLA,  ## 28 - info: pit lane enter / leave
	ISP_CCH,  ## 29 - info: camera changed
	ISP_PEN,  ## 30 - info: penalty given or cleared
	ISP_TOC,  ## 31 - info: take over car
	ISP_FLG,  ## 32 - info: flag (yellow or blue)
	ISP_PFL,  ## 33 - info: player flags (help flags)
	ISP_FIN,  ## 34 - info: finished race
	ISP_RES,  ## 35 - info: result confirmed
	ISP_REO,  ## 36 - both ways: reorder (info or instruction)
	ISP_NLP,  ## 37 - info: node and lap packet
	ISP_MCI,  ## 38 - info: multi car info
	ISP_MSX,  ## 39 - instruction: type message
	ISP_MSL,  ## 40 - instruction: message to local computer
	ISP_CRS,  ## 41 - info: car reset
	ISP_BFN,  ## 42 - both ways: delete buttons / receive button requests
	ISP_AXI,  ## 43 - info: autocross layout information
	ISP_AXO,  ## 44 - info: hit an autocross object
	ISP_BTN,  ## 45 - instruction: show a button on local or remote screen
	ISP_BTC,  ## 46 - info: sent when a user clicks a button
	ISP_BTT,  ## 47 - info: sent after typing into a button
	ISP_RIP,  ## 48 - both ways: replay information packet
	ISP_SSH,  ## 49 - both ways: screenshot
	ISP_CON,  ## 50 - info: contact between cars (collision report)
	ISP_OBH,  ## 51 - info: contact car + object (collision report)
	ISP_HLV,  ## 52 - info: report incidents that would violate HLVC
	ISP_PLC,  ## 53 - instruction: player cars
	ISP_AXM,  ## 54 - both ways: autocross multiple objects
	ISP_ACR,  ## 55 - info: admin command report
	ISP_HCP,  ## 56 - instruction: car handicaps
	ISP_NCI,  ## 57 - info: new connection - extra info for host
	ISP_JRR,  ## 58 - instruction: reply to a join request (allow / disallow)
	ISP_UCO,  ## 59 - info: report InSim checkpoint / InSim circle
	ISP_OCO,  ## 60 - instruction: object control (currently used for lights)
	ISP_TTC,  ## 61 - instruction: multi purpose - target to connection
	ISP_SLC,  ## 62 - info: connection selected a car
	ISP_CSC,  ## 63 - info: car state changed
	ISP_CIM,  ## 64 - info: connection's interface mode
	ISP_MAL,  ## 65 - both ways: set mods allowed
	ISP_PLH,  ## 66 - both ways: set player handicaps
	IRP_ARQ = 250,  ## Send : request if we are host admin (after connecting to a host)
	IRP_ARP,  ## Receive : replies if you are admin (after connecting to a host)
	IRP_HLR,  ## Send : To request a hostlist
	IRP_HOS,  ## Receive : Hostlist info
	IRP_SEL,  ## Send : To select a host
	IRP_ERR,  ## Receive : An error number
}
enum Tiny {
	TINY_NONE,  ## 0 - keep alive: see "maintaining the connection"
	TINY_VER,  ## 1 - info request: get version
	TINY_CLOSE,  ## 2 - instruction: close insim
	TINY_PING,  ## 3 - ping request: external progam requesting a reply
	TINY_REPLY,  ## 4 - ping reply: reply to a ping request
	TINY_VTC,  ## 5 - both ways: game vote cancel (info or request)
	TINY_SCP,  ## 6 - info request: send camera pos
	TINY_SST,  ## 7 - info request: send state info
	TINY_GTH,  ## 8 - info request: get time in hundredths (i.e. SMALL_RTP)
	TINY_MPE,  ## 9 - info: multi player end
	TINY_ISM,  ## 10 - info request: get multiplayer info (i.e. ISP_ISM)
	TINY_REN,  ## 11 - info: race end (return to race setup screen)
	TINY_CLR,  ## 12 - info: all players cleared from race
	TINY_NCN,  ## 13 - info request: get NCN for all connections
	TINY_NPL,  ## 14 - info request: get all players
	TINY_RES,  ## 15 - info request: get all results
	TINY_NLP,  ## 16 - info request: send an IS_NLP
	TINY_MCI,  ## 17 - info request: send an IS_MCI
	TINY_REO,  ## 18 - info request: send an IS_REO
	TINY_RST,  ## 19 - info request: send an IS_RST
	TINY_AXI,  ## 20 - info request: send an IS_AXI - AutoX Info
	TINY_AXC,  ## 21 - info: autocross cleared
	TINY_RIP,  ## 22 - info request: send an IS_RIP - Replay Information Packet
	TINY_NCI,  ## 23 - info request: get NCI for all guests (on host only)
	TINY_ALC,  ## 24 - info request: send a SMALL_ALC (allowed cars)
	TINY_AXM,  ## 25 - info request: send IS_AXM packets for the entire layout
	TINY_SLC,  ## 26 - info request: send IS_SLC packets for all connections
	TINY_MAL,  ## 27 - info request: send IS_MAL listing the currently allowed mods
	TINY_PLH,  ## 28 - info request: send IS_PLH listing player handicaps
}
enum Small {
	SMALL_NONE,  ## 0: not used
	SMALL_SSP,  ## 1 - instruction: start sending positions
	SMALL_SSG,  ## 2 - instruction: start sending gauges
	SMALL_VTA,  ## 3 - report: vote action
	SMALL_TMS,  ## 4 - instruction: time stop
	SMALL_STP,  ## 5 - instruction: time step
	SMALL_RTP,  ## 6 - info: race time packet (reply to GTH)
	SMALL_NLI,  ## 7 - instruction: set node lap interval
	SMALL_ALC,  ## 8 - both ways: set or get allowed cars (TINY_ALC)
	SMALL_LCS,  ## 9 - instruction: set local car switches (flash, horn, siren)
	SMALL_LCL,  ## 10 - instruction: set local car lights
}
enum TTC {
	TTC_NONE,  ## 0: not used
	TTC_SEL,  ## 1 - info request: send IS_AXM for a layout editor selection
	TTC_SEL_START,  ## 2 - info request: send IS_AXM every time the selection changes
	TTC_SEL_STOP,  ## 3 - instruction: switch off IS_AXM requested by TTC_SEL_START
}
enum RelayError {
	IR_ERR_PACKET = 1,  ## Invalid packet sent by client (wrong structure / length)
	IR_ERR_PACKET2,  ## Invalid packet sent by client (packet was not allowed to be forwarded to host)
	IR_ERR_HOSTNAME,  ## Wrong hostname given by client
	IR_ERR_ADMIN,  ## Wrong admin pass given by client
	IR_ERR_SPEC,  ## Wrong spec pass given by client
	IR_ERR_NOSPEC,  ## Spectator pass required, but none given
}
enum RelayFlag {
	HOS_SPECPASS = 1,  ## Host requires a spectator password
	HOS_LICENSED = 2,  ## Bit is set if host is licensed
	HOS_S1 = 4,  ## Bit is set if host is S1
	HOS_S2 = 8,  ## Bit is set if host is S2
	HOS_CRUISE = 32,  ## Bit is set if host is Cruise
	HOS_FIRST = 64,  ## Indicates the first host in the list
	HOS_LAST = 128,  ## Indicates the last host in the list
}

enum AutoCrossObject {
	AXO_START_LIGHTS1 = 149,
	AXO_START_LIGHTS2 = 150,
	AXO_START_LIGHTS3 = 151,
}
enum ButtonClick {
	ISB_LMB = 1,  ## left click
	ISB_RMB = 2,  ## right click
	ISB_CTRL = 4,  ## ctrl + click
	ISB_SHIFT = 8,  ## shift + click
}
enum ButtonFunction {
	BFN_DEL_BTN,  ## 0 - instruction: delete one button or range of buttons (must set ClickID)
	BFN_CLEAR,  ## 1 - instruction: clear all buttons made by this insim instance
	BFN_USER_CLEAR,  ## 2 - info: user cleared this insim instance's buttons
	BFN_REQUEST,  ## 3 - user request: SHIFT+B or SHIFT+I - request for buttons
}
enum ButtonPosition {
	X_MIN = 0,
	X_MAX = 110,
	Y_MIN = 0,
	Y_MAX = 170,
}
enum ButtonStyle {
	ISB_C1 = 1,
	ISB_C2 = 2,
	ISB_C4 = 4,
	ISB_CLICK = 8,
	ISB_LIGHT = 16,
	ISB_DARK = 32,
	ISB_LEFT = 64,
	ISB_RIGHT = 128,
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
enum CompCarInfo {
	CCI_BLUE = 1,
	CCI_YELLOW = 2,
	CCI_LAG = 32,
	CCI_FIRST = 64,
	CCI_LAST = 128,
}
enum Confirmation {
	CONF_MENTIONED = 1,
	CONF_CONFIRMED = 2,
	CONF_PENALTY_DT = 4,
	CONF_PENALTY_SG = 8,
	CONF_PENALTY_30 = 16,
	CONF_PENALTY_45 = 32,
	CONF_DID_NOT_PIT = 64,
	CONF_DISQ = (CONF_PENALTY_DT | CONF_PENALTY_SG | CONF_DID_NOT_PIT),
	CONF_TIME = (CONF_PENALTY_30 | CONF_PENALTY_45),
}
enum CSCAction {
	CSC_STOP,
	CSC_START,
}
enum HostFlag {
	HOSTF_CAN_VOTE = 1,
	HOSTF_CAN_SELECT = 2,
	HOSTF_MID_RACE = 32,
	HOSTF_MUST_PIT = 64,
	HOSTF_CAN_RESET = 128,
	HOSTF_FCV = 256,
	HOSTF_CRUISE = 512,
}
enum InitFlag {
	ISF_RES_0 = 1,  ## bit  0: spare
	ISF_RES_1 = 2,  ## bit  1: spare
	ISF_LOCAL = 4,  ## bit  2: guest or single player
	ISF_MSO_COLS = 8,  ## bit  3: keep colours in MSO text
	ISF_NLP = 16,  ## bit  4: receive NLP packets
	ISF_MCI = 32,  ## bit  5: receive MCI packets
	ISF_CON = 64,  ## bit  6: receive CON packets
	ISF_OBH = 128,  ## bit  7: receive OBH packets
	ISF_HLV = 256,  ## bit  8: receive HLV packets
	ISF_AXM_LOAD = 512,  ## bit  9: receive AXM when loading a layout
	ISF_AXM_EDIT = 1024,  ## bit 10: receive AXM when changing objects
	ISF_REQ_JOIN = 2048,  ## bit 11: process join requests
}
enum InterfaceMode {
	CIM_NORMAL,  ## not in a special mode
	CIM_OPTIONS,
	CIM_HOST_OPTIONS,
	CIM_GARAGE,
	CIM_CAR_SELECT,
	CIM_TRACK_SELECT,
	CIM_SHIFTU,  ## free view mode
	CIM_NUM
}
enum InterfaceNormal {
	NRM_NORMAL,
	NRM_WHEEL_TEMPS,  ## F9
	NRM_WHEEL_DAMAGE,  ## F10
	NRM_LIVE_SETTINGS,  ## F11
	NRM_PIT_INSTRUCTIONS,  ## F12
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
	LFS_ENGLISH,  ## 0
	LFS_DEUTSCH,  ## 1
	LFS_PORTUGUESE,  ## 2
	LFS_FRENCH,  ## 3
	LFS_SUOMI,  ## 4
	LFS_NORSK,  ## 5
	LFS_NEDERLANDS,  ## 6
	LFS_CATALAN,  ## 7
	LFS_TURKISH,  ## 8
	LFS_CASTELLANO,  ## 9
	LFS_ITALIANO,  ## 10
	LFS_DANSK,  ## 11
	LFS_CZECH,  ## 12
	LFS_RUSSIAN,  ## 13
	LFS_ESTONIAN,  ## 14
	LFS_SERBIAN,  ## 15
	LFS_GREEK,  ## 16
	LFS_POLSKI,  ## 17
	LFS_CROATIAN,  ## 18
	LFS_HUNGARIAN,  ## 19
	LFS_BRAZILIAN,  ## 20
	LFS_SWEDISH,  ## 21
	LFS_SLOVAK,  ## 22
	LFS_GALEGO,  ## 23
	LFS_SLOVENSKI,  ## 24
	LFS_BELARUSSIAN,  ## 25
	LFS_LATVIAN,  ## 26
	LFS_LITHUANIAN,  ## 27
	LFS_TRADITIONAL_CHINESE,  ## 28
	LFS_SIMPLIFIED_CHINESE,  ## 29
	LFS_JAPANESE,  ## 30
	LFS_KOREAN,  ## 31
	LFS_BULGARIAN,  ## 32
	LFS_LATINO,  ## 33
	LFS_UKRAINIAN,  ## 34
	LFS_INDONESIAN,  ## 35
	LFS_ROMANIAN,  ## 36
	LFS_NUM_LANG  ## 37
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
	MSO_SYSTEM,  ## 0 - system message
	MSO_USER,  ## 1 - normal visible user message
	MSO_PREFIX,  ## 2 - hidden message starting with special prefix (see ISI)
	MSO_O,  ## 3 - hidden message typed on local pc with /o command
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
enum OBHFlag {
	OBH_LAYOUT = 1,
	OBH_CAN_MOVE = 2,
	OBH_WAS_MOVING = 4,
	OBH_ON_SPOT = 8,
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
	PITLANE_EXIT,  ## 0 - left pit lane
	PITLANE_ENTER,  ## 1 - entered pit lane
	PITLANE_NO_PURPOSE,  ## 2 - entered for no purpose
	PITLANE_DT,  ## 3 - entered for drive-through
	PITLANE_SG,  ## 4 - entered for stop-go
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
enum Player {
	PIF_LEFTSIDE = 1,
	PIF_RESERVED_2 = 2,
	PIF_RESERVED_4 = 4,
	PIF_AUTOGEARS = 8,
	PIF_SHIFTER = 16,
	PIF_RESERVED_32 = 32,
	PIF_HELP_B = 64,
	PIF_AXIS_CLUTCH = 128,
	PIF_INPITS = 256,
	PIF_AUTOCLUTCH = 512,
	PIF_MOUSE = 1024,
	PIF_KB_NO_HELP = 2048,
	PIF_KB_STABILISED = 4096,
	PIF_CUSTOM_VIEW = 8192,
}
enum PMOAction {
	PMO_LOADING_FILE,  ## 0 - sent by the layout loading system only
	PMO_ADD_OBJECTS,  ## 1 - adding objects (from InSim or editor)
	PMO_DEL_OBJECTS,  ## 2 - delete objects (from InSim or editor)
	PMO_CLEAR_ALL,  ## 3 - clear all objects (NumO must be zero)
	PMO_TINY_AXM,  ## 4 - a reply to a TINY_AXM request
	PMO_TTC_SEL,  ## 5 - a reply to a TTC_SEL request
	PMO_SELECTION,  ## 6 - set a connection's layout editor selection
	PMO_POSITION,  ## 7 - user pressed O without anything selected
	PMO_GET_Z,  ## 8 - request Z values / reply with Z values
	PMO_NUM
}
enum PMOFlags {
	PMO_FILE_END = 1,
	PMO_MOVE_MODIFY = 2,
	PMO_SELECTION_REAL = 4,
	PMO_AVOID_CHECK = 8,
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
enum ReplayOption {
	RIPOPT_LOOP = 1,
	RIPOPT_SKINS = 2,
	RIPOPT_FULL_PHYS = 4,
}
enum Screenshot {
	SSH_OK,  ## 0 - OK: completed instruction
	SSH_DEDICATED,  ## 1 - can't save a screenshot - dedicated host
	SSH_CORRUPTED,  ## 2 - IS_SSH corrupted (e.g. Name does not end with zero)
	SSH_NO_SAVE,  ## 3 - could not save the screenshot
}
enum Setup {
	SETF_SYMM_WHEELS = 1,
	SETF_TC_ENABLE = 2,
	SETF_ABS_ENABLE = 4,
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
	VIEW_FOLLOW,  ## 0 - arcade
	VIEW_HELI,  ## 1 - helicopter
	VIEW_CAM,  ## 2 - tv camera
	VIEW_DRIVER,  ## 3 - cockpit
	VIEW_CUSTOM,  ## 4 - custom
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
const PING_INTERVAL := 30
const TIMEOUT_DELAY := 10

const RELAY_ADDRESS := "isrelay.lfs.net"
const RELAY_PORT := 47474

var lfs_connection: LFSConnection = null
var nlp_mci_connection := LFSConnectionUDP.new()
var is_relay := false
var initialization_data: InSimInitializationData = null

var insim_connected := false
var ping_timer := Timer.new()
var timeout_timer := Timer.new()


func _ready() -> void:
	add_child(nlp_mci_connection)
	var _discard := nlp_mci_connection.packet_received.connect(_on_packet_received)

	add_child(ping_timer)
	ping_timer.one_shot = true
	_discard = ping_timer.timeout.connect(send_ping)
	add_child(timeout_timer)
	timeout_timer.one_shot = true
	_discard = timeout_timer.timeout.connect(handle_timeout)

	_discard = isp_ver_received.connect(read_version_packet)
	_discard = isp_tiny_received.connect(_on_tiny_packet_received)
	_discard = isp_small_received.connect(_on_small_packet_received)


func close() -> void:
	if not lfs_connection:
		return
	send_packet(InSimTinyPacket.new(0, Tiny.TINY_CLOSE))
	print("Closing InSim connection.")
	lfs_connection.disconnect_from_host()
	nlp_mci_connection.disconnect_from_host()
	insim_connected = false
	disconnected.emit()


func connect_lfs_connection_signals() -> void:
	var _discard := lfs_connection.connected.connect(_on_connected_to_host)
	_discard = lfs_connection.connection_failed.connect(_on_connection_failed)
	_discard = lfs_connection.packet_received.connect(_on_packet_received)


func create_initialization_packet() -> InSimISIPacket:
	var initialization_packet := InSimISIPacket.new()
	initialization_packet.udp_port = initialization_data.udp_port
	initialization_packet.flags = initialization_data.flags
	initialization_packet.prefix = initialization_data.prefix
	initialization_packet.interval = initialization_data.interval
	initialization_packet.admin = initialization_data.admin
	initialization_packet.i_name = initialization_data.i_name
	return initialization_packet


func handle_timeout() -> void:
		timeout.emit()
		insim_connected = false
		push_warning("InSim connection timed out.")
		close()


func initialize(
	address: String, port: int, init_data: InSimInitializationData,
	insim_relay := false, use_udp := false
) -> void:
	initialization_data = init_data
	if (
		use_udp and lfs_connection is LFSConnectionTCP
		or not use_udp and lfs_connection is LFSConnectionUDP
	):
		remove_child(lfs_connection)
		lfs_connection.queue_free()
		await get_tree().process_frame
	if lfs_connection:
		lfs_connection.disconnect_from_host()
	else:
		if use_udp:
			lfs_connection = LFSConnectionUDP.new()
		else:
			lfs_connection = LFSConnectionTCP.new()
		add_child(lfs_connection)
		connect_lfs_connection_signals()
	if insim_relay:
		address = RELAY_ADDRESS
		port = RELAY_PORT
		is_relay = true
	else:
		is_relay = false
	lfs_connection.connect_to_host(address, port, initialization_data.udp_port)


func push_error_unknown_packet_subtype(type: int, subtype: int) -> void:
	push_error("%s with unknown packet subtype" % [Packet.keys()[type], subtype])


func push_error_unknown_packet_type(type: int) -> void:
	push_error("Unknown packet type: %d" % [type])


func read_ping_reply() -> void:
	insim_connected = true
	reset_timeout_timer()


func read_version_packet(packet: InSimVERPacket) -> void:
	insim_connected = true
	if packet.insim_ver != VERSION:
		print("Host InSim version (%d) is different from local version (%d)." % \
				[packet.insim_ver, VERSION])
		close()
		return
	print("Host InSim version matches local version (%d)." % [VERSION])


func reset_timeout_timer() -> void:
	ping_timer.start(PING_INTERVAL)
	timeout_timer.stop()


func send_keep_alive_packet() -> void:
	send_packet(InSimTinyPacket.new(0, Tiny.TINY_NONE))
	reset_timeout_timer()


func send_packet(packet: InSimPacket) -> void:
	if not lfs_connection:
		push_error("No connection, cannot send packet.")
		return
	if (
		not insim_connected
		and not is_relay
		and packet.type != Packet.ISP_ISI
		and not (packet.type == Packet.ISP_TINY and (packet as InSimTinyPacket).sub_type == Tiny.TINY_PING)
		and packet.type < Packet.IRP_ARQ
	):
		push_warning("Warning: Sending packet but InSim is not initialized.")
	packet.fill_buffer()
	var packet_sent_successfully := lfs_connection.send_packet(packet.buffer)
	if packet_sent_successfully:
		packet_sent.emit(packet)


func send_ping() -> void:
	timeout_timer.start(TIMEOUT_DELAY)
	send_packet(InSimTinyPacket.new(1, Tiny.TINY_PING))


func _on_connected_to_host() -> void:
	if not is_relay:
		send_packet(create_initialization_packet())
		nlp_mci_connection.disconnect_from_host()
		if initialization_data.udp_port != 0:
			nlp_mci_connection.connect_to_host(lfs_connection.address, lfs_connection.udp_port, 0, true)
		reset_timeout_timer()
		connected.emit()


func _on_connection_failed() -> void:
	push_warning("Could not connect to %s:%d." % [lfs_connection.address, lfs_connection.port])


func _on_packet_received(packet_buffer: PackedByteArray) -> void:
	var packet := InSimPacket.create_packet_from_buffer(packet_buffer)
	packet_received.emit(packet)
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
		Packet.IRP_ARP:
			irp_arp_received.emit(packet)
		Packet.IRP_HOS:
			irp_hos_received.emit(packet)
		Packet.IRP_ERR:
			irp_err_received.emit(packet)
		_:
			push_error_unknown_packet_type(packet.type)


func _on_small_packet_received(packet: InSimSmallPacket) -> void:
	match packet.sub_type:
		Small.SMALL_VTA:
			small_vta_received.emit(packet)
		Small.SMALL_RTP:
			small_rtp_received.emit(packet)
		Small.SMALL_ALC:
			small_alc_received.emit(packet)
		_:
			push_error_unknown_packet_subtype(packet.type, packet.sub_type)


func _on_tiny_packet_received(packet: InSimTinyPacket) -> void:
	match packet.sub_type:
		Tiny.TINY_NONE:
			send_keep_alive_packet()
		Tiny.TINY_REPLY:
			read_ping_reply()
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
			push_error_unknown_packet_subtype(packet.type, packet.sub_type)
