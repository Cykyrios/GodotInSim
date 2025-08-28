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
## controlling LFS with special packets, text commands or keypresses.[br]
## [br]
## INITIALISING InSim[br]
## ==================[br]
## To initialise the InSim system, type into LFS: /insim xxxxx
## where xxxxx is the TCP and UDP port you want LFS to open.[br]
## OR start LFS with the command line option: LFS /insim=xxxxx
## This will make LFS listen for packets on that TCP and UDP port.


## Emitted when InSim has successfully connected, after receiving an [InSimVERPacket] response
## from [method initialize].
signal connected
## Emitted when InSim disconnects, which happens when calling [method close] or after a
## [signal timeout].
signal disconnected
## After a given delay of [constant PING_INTERVAL] with no packet received, a ping is sent to LFS;
## if no response is received within [constant TIMEOUT_DELAY], this signal is emitted.
signal timeout

## Emitted when a packet is received from LFS. Specific signals are also emitted
## for each packet type.[br]
## [b]Note:[/b] When requesting UDP updates for [InSimNLPPacket] or [InSimMCIPacket],
## [signal udp_packet_received] is emitted instead of this one.
signal packet_received(packet: InSimPacket)
## Emitted when a packet is sent successfully. [param sender] can be used
## to identify the source of the packet (InSim itself, or the user application),
## and defaults to [code]"InSim"[/code] in [method send_packet].
signal packet_sent(packet: InSimPacket, sender: String)
signal isp_acr_received(packet: InSimACRPacket)  ## Emitted when an [InSimACRPacket] is received.
signal isp_aic_received(packet: InSimAICPacket)  ## Emitted when an [InSimAICPacket] is received.
signal isp_aii_received(packet: InSimAIIPacket)  ## Emitted when an [InSimAIIPacket] is received.
signal isp_axi_received(packet: InSimAXIPacket)  ## Emitted when an [InSimAXIPacket] is received.
signal isp_axm_received(packet: InSimAXMPacket)  ## Emitted when an [InSimAXMPacket] is received.
signal isp_axo_received(packet: InSimAXOPacket)  ## Emitted when an [InSimAXOPacket] is received.
signal isp_bfn_received(packet: InSimBFNPacket)  ## Emitted when an [InSimBFNPacket] is received.
signal isp_btc_received(packet: InSimBTCPacket)  ## Emitted when an [InSimBTCPacket] is received.
signal isp_btt_received(packet: InSimBTTPacket)  ## Emitted when an [InSimBTTPacket] is received.
signal isp_cch_received(packet: InSimCCHPacket)  ## Emitted when an [InSimCCHPacket] is received.
signal isp_cim_received(packet: InSimCIMPacket)  ## Emitted when an [InSimCIMPacket] is received.
signal isp_cnl_received(packet: InSimCNLPacket)  ## Emitted when an [InSimCNLPacket] is received.
signal isp_con_received(packet: InSimCONPacket)  ## Emitted when an [InSimCONPacket] is received.
signal isp_cpp_received(packet: InSimCPPPacket)  ## Emitted when an [InSimCPPPacket] is received.
signal isp_cpr_received(packet: InSimCPRPacket)  ## Emitted when an [InSimCPRPacket] is received.
signal isp_crs_received(packet: InSimCRSPacket)  ## Emitted when an [InSimCRSPacket] is received.
signal isp_csc_received(packet: InSimCSCPacket)  ## Emitted when an [InSimCSCPacket] is received.
signal isp_fin_received(packet: InSimFINPacket)  ## Emitted when an [InSimFINPacket] is received.
signal isp_flg_received(packet: InSimFLGPacket)  ## Emitted when an [InSimFLGPacket] is received.
signal isp_hlv_received(packet: InSimHLVPacket)  ## Emitted when an [InSimHLVPacket] is received.
signal isp_iii_received(packet: InSimIIIPacket)  ## Emitted when an [InSimIIIPacket] is received.
signal isp_ipb_received(packet: InSimIPBPacket)  ## Emitted when an [InSimIPBPacket] is received.
signal isp_ism_received(packet: InSimISMPacket)  ## Emitted when an [InSimISMPacket] is received.
signal isp_lap_received(packet: InSimLAPPacket)  ## Emitted when an [InSimLAPPacket] is received.
signal isp_mal_received(packet: InSimMALPacket)  ## Emitted when an [InSimMALPacket] is received.
signal isp_mci_received(packet: InSimMCIPacket)  ## Emitted when an [InSimMCIPacket] is received.
signal isp_mso_received(packet: InSimMSOPacket)  ## Emitted when an [InSimMSOPacket] is received.
signal isp_nci_received(packet: InSimNCIPacket)  ## Emitted when an [InSimNCIPacket] is received.
signal isp_ncn_received(packet: InSimNCNPacket)  ## Emitted when an [InSimNCNPacket] is received.
signal isp_nlp_received(packet: InSimNLPPacket)  ## Emitted when an [InSimNLPPacket] is received.
signal isp_npl_received(packet: InSimNPLPacket)  ## Emitted when an [InSimNPLPacket] is received.
signal isp_obh_received(packet: InSimOBHPacket)  ## Emitted when an [InSimOBHPacket] is received.
signal isp_pen_received(packet: InSimPENPacket)  ## Emitted when an [InSimPENPacket] is received.
signal isp_pit_received(packet: InSimPITPacket)  ## Emitted when an [InSimPITPacket] is received.
signal isp_pfl_received(packet: InSimPFLPacket)  ## Emitted when an [InSimPFLPacket] is received.
signal isp_pla_received(packet: InSimPLAPacket)  ## Emitted when an [InSimPLAPacket] is received.
signal isp_plh_received(packet: InSimPLHPacket)  ## Emitted when an [InSimPLHPacket] is received.
signal isp_pll_received(packet: InSimPLLPacket)  ## Emitted when an [InSimPLLPacket] is received.
signal isp_plp_received(packet: InSimPLPPacket)  ## Emitted when an [InSimPLPPacket] is received.
signal isp_psf_received(packet: InSimPSFPacket)  ## Emitted when an [InSimPSFPacket] is received.
signal isp_reo_received(packet: InSimREOPacket)  ## Emitted when an [InSimREOPacket] is received.
signal isp_res_received(packet: InSimRESPacket)  ## Emitted when an [InSimRESPacket] is received.
signal isp_rip_received(packet: InSimRIPPacket)  ## Emitted when an [InSimRIPPacket] is received.
signal isp_rst_received(packet: InSimRSTPacket)  ## Emitted when an [InSimRSTPacket] is received.
signal isp_slc_received(packet: InSimSLCPacket)  ## Emitted when an [InSimSLCPacket] is received.
## Emitted when an [InSimSmallPacket] is received.
signal isp_small_received(packet: InSimSmallPacket)
signal isp_spx_received(packet: InSimSPXPacket)  ## Emitted when an [InSimSPXPacket] is received.
signal isp_ssh_received(packet: InSimSSHPacket)  ## Emitted when an [InSimSSHPacket] is received.
signal isp_sta_received(packet: InSimSTAPacket)  ## Emitted when an [InSimSTAPacket] is received.
signal isp_tiny_received(packet: InSimTinyPacket)  ## Emitted when an [InSimTinyPacket] is received.
signal isp_toc_received(packet: InSimTOCPacket)  ## Emitted when an [InSimTOCPacket] is received.
signal isp_uco_received(packet: InSimUCOPacket)  ## Emitted when an [InSimUCOPacket] is received.
signal isp_ver_received(packet: InSimVERPacket)  ## Emitted when an [InSimVERPacket] is received.
signal isp_vtn_received(packet: InSimVTNPacket)  ## Emitted when an [InSimVTNPacket] is received.
## Emitted when an [InSimSmallPacket] is received with a [member InSimSmallPacket.sub_type] equal
## to [constant InSim.Small.SMALL_ALC].
signal small_alc_received(packet: InSimSmallPacket)
## Emitted when an [InSimSmallPacket] is received with a [member InSimSmallPacket.sub_type] equal
## to [constant InSim.Small.SMALL_RTP].
signal small_rtp_received(packet: InSimSmallPacket)
## Emitted when an [InSimSmallPacket] is received with a [member InSimSmallPacket.sub_type] equal
## to [constant InSim.Small.SMALL_VTA].
signal small_vta_received(packet: InSimSmallPacket)
## Emitted when an [InSimTinyPacket] is received with a [member InSimTinyPacket.sub_type] equal
## to [constant InSim.Tiny.TINY_AXC].
signal tiny_axc_received(packet: InSimTinyPacket)
## Emitted when an [InSimTinyPacket] is received with a [member InSimTinyPacket.sub_type] equal
## to [constant InSim.Tiny.TINY_CLR].
signal tiny_clr_received(packet: InSimTinyPacket)
## Emitted when an [InSimTinyPacket] is received with a [member InSimTinyPacket.sub_type] equal
## to [constant InSim.Tiny.TINY_MPE].
signal tiny_mpe_received(packet: InSimTinyPacket)
## Emitted when an [InSimTinyPacket] is received with a [member InSimTinyPacket.sub_type] equal
## to [constant InSim.Tiny.TINY_REN].
signal tiny_ren_received(packet: InSimTinyPacket)
## Emitted when an [InSimTinyPacket] is received with a [member InSimTinyPacket.sub_type] equal
## to [constant InSim.Tiny.TINY_REPLY].
signal tiny_reply_received(packet: InSimTinyPacket)
## Emitted when an [InSimTinyPacket] is received with a [member InSimTinyPacket.sub_type] equal
## to [constant InSim.Tiny.TINY_VTC].
signal tiny_vtc_received(packet: InSimTinyPacket)
## Emitted when a packet is received by the [member nlp_mci_connection], which only happens
## if you request UDP updates via [InSimISIPacket].
signal udp_packet_received(packet: InSimPacket)
## Emitted when an [InSimNLPPacket] is received by the [member nlp_mci_connection].
signal udp_nlp_received(packet: InSimNLPPacket)
## Emitted when an [InSimMCIPacket] is received by the [member nlp_mci_connection].
signal udp_mci_received(packet: InSimMCIPacket)

## Emitted when a player clears InSim buttons using [kbd]Shift + I[/kbd] or [kbd]Shift + B[/kbd].
signal connection_cleared_buttons(ucid: int)
## Emitted when a player requests InSim buttons using [kbd]Shift + I[/kbd] or [kbd]Shift + B[/kbd].
signal connection_requested_buttons(ucid: int)
## Emitted when a player has received global InSim buttons (on connection or after
## requesting buttons). This can be used to update the buttons' contents, for buttons that are
## customized to each player.
signal global_buttons_restored(ucid: int)

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
	ISP_IPB,  ## 67 - both ways: set IP bans
	ISP_AIC,  ## 68 - instruction: set AI control values
	ISP_AII,  ## 69 - info: info about AI car
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
	TINY_IPB,  ## 29 - info request: send IS_IPB listing the IP bans
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
	SMALL_AII,  ## 11 - info request: get local AI info
}
enum TTC {
	TTC_NONE,  ## 0: not used
	TTC_SEL,  ## 1 - info request: send IS_AXM for a layout editor selection
	TTC_SEL_START,  ## 2 - info request: send IS_AXM every time the selection changes
	TTC_SEL_STOP,  ## 3 - instruction: switch off IS_AXM requested by TTC_SEL_START
}

## See [AIInputVal] for more details
enum AIControl {
	CS_MSX,  ## 0 - steering : 1 hard left / 32768 centre / 65535 hard right
	CS_THROTTLE,  ## 1 - 0 to 65535
	CS_BRAKE,  ## 2 - 0 to 65535
	CS_CHUP,  ## 3 - hold shift up lever
	CS_CHDN,  ## 4 - hold shift down lever
	CS_IGNITION,  ## 5 - toggle
	CS_EXTRALIGHT,  ## 6 - toggle
	CS_HEADLIGHTS,  ## 7 - 1: off / 2: side / 3: low / 4: high
	CS_SIREN,  ## 8 - hold siren - 1: fast / 2: slow
	CS_HORN,  ## 9 - hold horn - 1 to 5
	CS_FLASH,  ## 10 - hold flash - 1: on
	CS_CLUTCH,  ## 11 - 0 to 65535
	CS_HANDBRAKE,  ## 12 - 0 to 65535
	CS_INDICATORS,  ## 13 - 1: cancel / 2: left / 3: right / 4: hazard
	CS_GEAR,  ## 14 - for shifter (leave at 255 for sequential control)
	CS_LOOK,  ## 15 - 0: none / 4: left / 5: left+ / 6: right / 7: right+
	CS_PITSPEED,  ## 16 - toggle
	CS_TCDISABLE,  ## 17 - toggle
	CS_FOGREAR,  ## 18 - toggle
	CS_FOGFRONT,  ## 19 - toggle
	CS_SEND_AI_INFO = 240,  ## 240
	CS_REPEAT_AI_INFO,  ## 241
	CS_SET_HELP_FLAGS = 253, ## 253: set help flags (PIF_AUTOGEARS, PIF_HELP_B, PIF_AUTOCLUTCH)
	CS_RESET_INPUTS,  ## 254: reset all inputs, CS_MSX is 32768, CS_GEAR is 255, other inputs are 0
	CS_STOP_CONTROL,  ## 255: stop control, the AI driver will stop the car
}
enum AIFlags {
	AIFLAGS_IGNITION = 1,  ## detect if engine running
	AIFLAGS_CHUP = 4,  ## upshift lever currently held
	AIFLAGS_CHDN = 8,  ## downshift lever currently held
}
enum AutoCrossObject {
	AXO_START_LIGHTS1 = 149,
	AXO_START_LIGHTS2 = 150,
	AXO_START_LIGHTS3 = 151,
}
enum AXOIndex {
	AXO_NULL,
	AXO_1,
	AXO_2,
	AXO_3,
	AXO_CHALK_LINE,
	AXO_CHALK_LINE2,
	AXO_CHALK_AHEAD,
	AXO_CHALK_AHEAD2,
	AXO_CHALK_LEFT,
	AXO_CHALK_LEFT2,
	AXO_CHALK_LEFT3,
	AXO_CHALK_RIGHT,
	AXO_CHALK_RIGHT2,
	AXO_CHALK_RIGHT3,
	AXO_14,
	AXO_15,
	AXO_16,
	AXO_17,
	AXO_18,
	AXO_19,
	AXO_CONE_RED,
	AXO_CONE_RED2,
	AXO_CONE_RED3,
	AXO_CONE_BLUE,
	AXO_CONE_BLUE2,
	AXO_CONE_GREEN,
	AXO_CONE_GREEN2,
	AXO_CONE_ORANGE,
	AXO_CONE_WHITE,
	AXO_CONE_YELLOW,
	AXO_CONE_YELLOW2,
	AXO_31,
	AXO_32,
	AXO_33,
	AXO_34,
	AXO_35,
	AXO_36,
	AXO_37,
	AXO_38,
	AXO_39,
	AXO_CONE_PTR_RED,
	AXO_CONE_PTR_BLUE,
	AXO_CONE_PTR_GREEN,
	AXO_CONE_PTR_YELLOW,
	AXO_44,
	AXO_45,
	AXO_46,
	AXO_47,
	AXO_TYRE_SINGLE,
	AXO_TYRE_STACK2,
	AXO_TYRE_STACK3,
	AXO_TYRE_STACK4,
	AXO_TYRE_SINGLE_BIG,
	AXO_TYRE_STACK2_BIG,
	AXO_TYRE_STACK3_BIG,
	AXO_TYRE_STACK4_BIG,
	AXO_56,
	AXO_57,
	AXO_58,
	AXO_59,
	AXO_60,
	AXO_61,
	AXO_62,
	AXO_63,
	AXO_MARKER_CURVE_L,
	AXO_MARKER_CURVE_R,
	AXO_MARKER_L,
	AXO_MARKER_R,
	AXO_MARKER_HARD_L,
	AXO_MARKER_HARD_R,
	AXO_MARKER_L_R,
	AXO_MARKER_R_L,
	AXO_MARKER_S_L,
	AXO_MARKER_S_R,
	AXO_MARKER_S2_L,
	AXO_MARKER_S2_R,
	AXO_MARKER_U_L,
	AXO_MARKER_U_R,
	AXO_78,
	AXO_79,
	AXO_80,
	AXO_81,
	AXO_82,
	AXO_83,
	AXO_DIST25,
	AXO_DIST50,
	AXO_DIST75,
	AXO_DIST100,
	AXO_DIST125,
	AXO_DIST150,
	AXO_DIST200,
	AXO_DIST250,
	AXO_92,
	AXO_93,
	AXO_94,
	AXO_95,
	AXO_ARMCO1,
	AXO_ARMCO3,
	AXO_ARMCO5,
	AXO_99,
	AXO_100,
	AXO_101,
	AXO_102,
	AXO_103,
	AXO_BARRIER_LONG,
	AXO_BARRIER_RED,
	AXO_BARRIER_WHITE,
	AXO_107,
	AXO_108,
	AXO_109,
	AXO_110,
	AXO_111,
	AXO_BANNER1,
	AXO_BANNER2,
	AXO_114,
	AXO_115,
	AXO_116,
	AXO_117,
	AXO_118,
	AXO_119,
	AXO_RAMP1,
	AXO_RAMP2,
	AXO_122,
	AXO_123,
	AXO_124,
	AXO_125,
	AXO_126,
	AXO_127,
	AXO_SPEED_HUMP_10M,
	AXO_SPEED_HUMP_6M,
	AXO_130,
	AXO_131,
	AXO_132,
	AXO_133,
	AXO_134,
	AXO_135,
	AXO_POST_GREEN,
	AXO_POST_ORANGE,
	AXO_POST_RED,
	AXO_POST_WHITE,
	AXO_140,
	AXO_141,
	AXO_142,
	AXO_143,
	AXO_BALE,
	AXO_145,
	AXO_146,
	AXO_147,
	AXO_RAILING,
	AXO_START_LIGHTS,
	AXO_150,
	AXO_151,
	AXO_152,
	AXO_153,
	AXO_154,
	AXO_155,
	AXO_156,
	AXO_157,
	AXO_158,
	AXO_159,
	AXO_SIGN_KEEP_LEFT,
	AXO_SIGN_KEEP_RIGHT,
	AXO_162,
	AXO_163,
	AXO_164,
	AXO_165,
	AXO_166,
	AXO_167,
	AXO_SIGN_SPEED_80,
	AXO_SIGN_SPEED_50,
	AXO_170,
	AXO_171,
	AXO_CONCRETE_SLAB,
	AXO_CONCRETE_RAMP,
	AXO_CONCRETE_WALL,
	AXO_CONCRETE_PILLAR,
	AXO_CONCRETE_SLAB_WALL,
	AXO_CONCRETE_RAMP_WALL,
	AXO_CONCRETE_SHORT_SLAB_WALL,
	AXO_CONCRETE_WEDGE,
	AXO_180,
	AXO_181,
	AXO_182,
	AXO_183,
	AXO_START_POSITION,
	AXO_PIT_START_POINT,
	AXO_PIT_STOP_BOX,
	AXO_187,
	AXO_188,
	AXO_189,
	AXO_190,
	AXO_191,
	AXO_IS_CP = 252,
	AXO_IS_AREA,
	AXO_MARSHAL,
	AXO_ROUTE,
}
enum ButtonClick {
	ISB_LMB = 1,  ## left click
	ISB_RMB = 2,  ## right click
	ISB_CTRL = 4,  ## ctrl + click
	ISB_SHIFT = 8,  ## shift + click
}
enum ButtonColor {
	ISB_LIGHT_GRAY,
	ISB_TITLE,
	ISB_UNSELECTED,
	ISB_SELECTED,
	ISB_OK,
	ISB_CANCEL,
	ISB_TEXT,
	ISB_UNAVAILABLE,
}
enum ButtonFunction {
	BFN_DEL_BTN,  ## 0 - instruction: delete one button or range of buttons (must set ClickID)
	BFN_CLEAR,  ## 1 - instruction: clear all buttons made by this insim instance
	BFN_USER_CLEAR,  ## 2 - info: user cleared this insim instance's buttons
	BFN_REQUEST,  ## 3 - user request: SHIFT+B or SHIFT+I - request for buttons
}
enum ButtonPosition {
	X_MIN = 0,  ## Minimum recommended X coordinate
	X_MAX = 110,  ## Maximum recommended X coordinate
	Y_MIN = 0,  ## Minimum recommended Y coordinate
	Y_MAX = 170,  ## Maximum recommended Y coordinate
}
enum ButtonStyle {
	ISB_C1 = 1,  ## Text color, 3-bit value, see [enum ButtonColor].
	ISB_C2 = 2,  ## Text color, 3-bit value, see [enum ButtonColor].
	ISB_C4 = 4,  ## Text color, 3-bit value, see [enum ButtonColor].
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
	CCI_BLUE = 1,  ## This car is being lapped.
	CCI_YELLOW = 2,  ## This car is causing a yellow flag.
	CCI_LAG = 32,  ## This player is lagging.
	CCI_FIRST = 64,  ## This is the first [CompCar] in this set of [InSimMCIPacket]s.
	CCI_LAST = 128,  ## This is the last [CompCar] in this set of [InSimMCIPacket]s.
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
	GRG_NUM,
	GRG_RATING = 255  ## Not documented in InSim.txt
}
enum InterfaceShiftU {
	FVM_PLAIN,  ## no buttons displayed
	FVM_BUTTONS,  ## buttons displayed (not editing)
	FVM_EDIT,  ## edit mode
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
	JRR_7,
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
	LCS_SET_SIGNALS = 1,  ## Deprecated, use [constant InSim.Small.SMALL_LCL] instead.
	LCS_SET_FLASH = 2,
	LCS_SET_HEADLIGHTS = 4,  ## Deprecated, use [constant InSim.Small.SMALL_LCL] instead.
	LCS_SET_HORN = 8,
	LCS_SET_SIREN = 16,
}
enum LeaveReason {
	LEAVR_DISCO,  ## no reason given
	LEAVR_TIMEOUT,  ## timed out
	LEAVR_LOSTCONN,  ## lost connection
	LEAVR_KICKED,  ## kicked
	LEAVR_BANNED,  ## ban
	LEAVR_SECURITY,  ## security
	LEAVR_CPW,  ## cheat protection wrong
	LEAVR_OOS,  ## out of sync with host
	LEAVR_JOOS,  ## join OOS (initial sync failed)
	LEAVR_HACK,  ## invalid packet
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
	OBH_LAYOUT = 1,  ## an added object
	OBH_CAN_MOVE = 2,  ## a movable object
	OBH_WAS_MOVING = 4,  ## was moving before this hit
	OBH_ON_SPOT = 8,  ## object in original position
}
enum OCOAction {
	OCO_ZERO,
	OCO_1,
	OCO_2,
	OCO_3,
	OCO_LIGHTS_RESET,  ## give up control of all lights
	OCO_LIGHTS_SET,  ## use Data byte to set the bulbs
	OCO_LIGHTS_UNSET,  ## give up control of the specified lights
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
	PENR_UNKNOWN,  ## unknown or cleared penalty
	PENR_ADMIN,  ## penatly given by admin
	PENR_WRONG_WAY,  ## wrong way driving
	PENR_FALSE_START,  ## starting before green light
	PENR_SPEEDING,  ## speeding in pit lane
	PENR_STOP_SHORT,  ## stop-go pit stop too short
	PENR_STOP_LATE,  ## compulsory stop is too late
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
enum PlayerFlag {
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
	RIP_OK,  ## completed instruction
	RIP_ALREADY,  ## already at the destination
	RIP_DEDICATED,  ## can't run a replay - dedicated host
	RIP_WRONG_MODE,  ## can't start a replay - not in a suitable mode
	RIP_NOT_REPLAY,  ## RName is zero but no replay is currently loaded
	RIP_CORRUPTED,  ## IS_RIP corrupted (e.g. RName does not end with zero)
	RIP_NOT_FOUND,  ## the replay file was not found
	RIP_UNLOADABLE,  ## obsolete / future / corrupted
	RIP_DEST_OOB,  ## destination is beyond replay length
	RIP_UNKNOWN,  ## unknown error found starting replay
	RIP_USER,  ## replay search was terminated by user
	RIP_OOS,  ## can't reach destination - SPR is out of sync
}
enum ReplayOption {
	RIPOPT_LOOP = 1,  ## replay will loop
	RIPOPT_SKINS = 2,  ## download missing skins
	RIPOPT_FULL_PHYS = 4,  ## use full physics when searching an MPR
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
	ISS_GAME = 1,  ## in game (or MPR)
	ISS_REPLAY = 2,  ## in SPR
	ISS_PAUSED = 4,  ## paused
	ISS_SHIFTU = 8,  ## free view mode
	ISS_DIALOG = 16,  ## in a dialog
	ISS_SHIFTU_FOLLOW = 32,  ## FOLLOW view
	ISS_SHIFTU_NO_OPT = 64,  ## free view buttons hidden
	ISS_SHOW_2D = 128,  ## showing 2d display
	ISS_FRONT_END = 256,  ## entry screen
	ISS_MULTI = 512,  ## multiplayer mode
	ISS_MPSPEEDUP = 1024,  ## multiplayer speedup option
	ISS_WINDOWED = 2048,  ## LFS is running in a window
	ISS_SOUND_MUTE = 4096,  ## sound is switched off
	ISS_VIEW_OVERRIDE = 8192,  ## override user view
	ISS_VISIBLE = 16384,  ## InSim buttons visible
	ISS_TEXT_ENTRY = 32768,  ## in a text entry dialog
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
	UCO_CIRCLE_ENTER,  ## entered a circle
	UCO_CIRCLE_LEAVE,  ## left a circle
	UCO_CP_FWD,  ## crossed cp in forward direction
	UCO_CP_REV,  ## crossed cp in backward direction
}
enum View {
	VIEW_FOLLOW,  ## 0 - arcade
	VIEW_HELI,  ## 1 - helicopter
	VIEW_CAM,  ## 2 - tv camera
	VIEW_DRIVER,  ## 3 - cockpit
	VIEW_CUSTOM,  ## 4 - custom
	VIEW_MAX,
	VIEW_ANOTHER = 255  ## viewing another car
}
enum Vote {
	VOTE_NONE,
	VOTE_END,
	VOTE_RESTART,
	VOTE_QUALIFY,
	VOTE_NUM
}

const VERSION := 9  ## Current supported InSim version
const PING_INTERVAL := 31  ## Interval between pings, if no packet is received before that.
const TIMEOUT_DELAY := 10  ## Timeout if no reply to ping within this delay.

const OCO_INDEX_MAIN := 240  ## Main start lights

## A UCID value of 255 has a special meaning for some packets, such as [InSimBTNPacket], which
## causes the created button to be sent to everyone.
const UCID_ALL := 255
## The ReqI value used by Godot InSim for packets that use a non-zero value.
const GIS_REQI := 250

var lfs_connection: LFSConnection = null  ## Internal connection for TCP/UDP communication
## UDP connection used specifically for receiving NLP or MCI packets, see [InSimISIPacket].
var nlp_mci_connection: LFSConnectionUDP = null
var _is_host := false  ## Whether this is a host InSim application, do not set manually.
## Helper struct for InSim initialization, see [InSimISIPacket].
var initialization_data: InSimInitializationData = null
## This boolean controls whether connecting to InSim versions other than [constant VERSION]
## is allowed. If you know the target version is compatible with the current [constant VERSION],
## enable this, but be aware that issues may occur.
var allow_different_insim_versions := false

## Current status of the InSim connection; can report [code]false[/code] even if TCP is connected.
## InSim is considered connected when the first [InSimVERPacket] is received after
## [method initialize], and whenever it receives a packet after that. Connection is considered
## dropped after [method close] or a [signal timeout]. If you need to handle timeouts, connect
## to [signal timeout] instead of checking the value of this variable.
var insim_connected := false
## A timer used to check the connection status, resets when a packet is received.
var ping_timer: Timer = null
## A timer used to check for timeouts, after [member ping_timer] has expired.
var timeout_timer: Timer = null

## Current state of the game, as per IS_STA documentation. Updated automatically upon
## receiving an [InSimSTAPacket]. Does not include packet header.
var lfs_state: LFSState = null
## Dictionary of UCID/[GISConnection] pairs, updated automatically.
var connections: Dictionary[int, GISConnection] = {}
## Dictionary of PLID/[GISPlayer] pairs, updated automatically.
var players: Dictionary[int, GISPlayer] = {}
## Manager object for all known/registered [InSimButton] objects.
var button_manager: InSimButtonManager = null

# Set to true in initialize(), used to silence unconnected InSim warning when sending packets
var _initializing := false


func _init() -> void:
	initialization_data = InSimInitializationData.new()
	lfs_state = LFSState.new()
	button_manager = InSimButtonManager.new(self)
	nlp_mci_connection = LFSConnectionUDP.new()
	add_child(nlp_mci_connection)
	ping_timer = Timer.new()
	add_child(ping_timer)
	timeout_timer = Timer.new()
	add_child(timeout_timer)


func _ready() -> void:
	var _discard := nlp_mci_connection.packet_received.connect(_on_udp_packet_received)

	ping_timer.one_shot = true
	_discard = ping_timer.timeout.connect(_send_ping)
	timeout_timer.one_shot = true
	_discard = timeout_timer.timeout.connect(_handle_timeout)

	_discard = isp_bfn_received.connect(_on_isp_bfn_received)
	_discard = isp_cnl_received.connect(_on_isp_cnl_received)
	_discard = isp_cpr_received.connect(_on_isp_cpr_received)
	_discard = isp_ism_received.connect(_on_isp_ism_received)
	_discard = isp_ncn_received.connect(_on_isp_ncn_received)
	_discard = isp_npl_received.connect(_on_isp_npl_received)
	_discard = isp_pfl_received.connect(_on_isp_pfl_received)
	_discard = isp_pll_received.connect(_on_isp_pll_received)
	_discard = isp_sta_received.connect(_on_isp_sta_received)
	_discard = isp_toc_received.connect(_on_isp_toc_received)
	_discard = isp_small_received.connect(_on_small_packet_received)
	_discard = isp_tiny_received.connect(_on_tiny_packet_received)
	_discard = tiny_clr_received.connect(_on_tiny_clr_received)
	_discard = tiny_mpe_received.connect(_on_tiny_mpe_received)
	_discard = isp_ver_received.connect(_read_version_packet)


## Awaits and returns a packet of the given [param type]. The returned packet must have the
## given [param req_i], and can additionally be filtered by filling [param details] with
## properties. Property keys should be names of the awaited packet's properties, and values
## can be any desired value; for instance, the following example returns the first [InSimNPLPacket]
## for a player which has R3 tyres:
## [codeblock]
## await await_packet(
##     InSimTinyPacket.create(1, InSim.Tiny.TINY_NPL),
##     InSim.Packet.ISP_NPL,
##     {"tyres": [InSim.Tyre.TYRE_R3, InSim.Tyre.TYRE_R3, InSim.Tyre.TYRE_R3, InSim.Tyre.TYRE_R3]},
## )
## [/codeblock]
## If, however, no player has all R3 tyres, your code will get stuck awaiting those specific
## requirements; you should generally use this method only when you know the expected packet
## will be received immediately or when that packet can be sent from other parts of your code.[br]
## [b]Danger:[/b] Awaiting a non-zero [param req_i] means the expected packet has to be requested
## specifically; this can lead to your code being soft-locked! This is something you especially
## need to consider when using [method await_packets] or [method send_packet_await_packets].
## Filtering results using [param details] can also lead to soft-locking when too specific; make
## sure the expected packet [i]will[/i] eventually be received, and you don't need the code
## following this call to run until the packet is received.
func await_packet(type: Packet, req_i := 0, details := {}) -> InSimPacket:
	details["req_i"] = req_i
	return await _await_packet(type, details)


## Awaits and returns [param number] packets of the given [param type]. All packets must have
## the given [param req_i] and are further filtered by [param details]. See [method await_packet]
## for more details about filtering packets.[br]
## [b]Note:[/b] As your code awaits for the given amount of packets, this can be used to easily
## wait for a specific number of events, e.g. wait until 5 players join the track after some event;
## on the other hand, it also means you can soft-lock your code, depending on where you use
## this method.
func await_packets(type: Packet, number: int, req_i := 0, details := {}) -> Array[InSimPacket]:
	print_verbose("Awaiting %d packet%s of type %s" % [
		number, "s" if number > 1 else "", Packet.keys()[Packet.values().find(type)]
	])
	details["req_i"] = req_i
	var packets: Array[InSimPacket] = []
	for i in number:
		packets.append(await _await_packet(type, details))
		print_verbose("Received %d/%d packet%s" % [i + 1, number, "s" if number > 1 else ""])
	return packets


## Closes the InSim connection. Trying to send packets after this may cause numerous errors in
## the log or terminal.
func close() -> void:
	if not lfs_connection:
		return
	send_packet(InSimTinyPacket.create(0, Tiny.TINY_CLOSE))
	print("Closing InSim connection.")
	lfs_connection._disconnect_from_host()
	nlp_mci_connection._disconnect_from_host()
	insim_connected = false
	ping_timer.stop()
	_initializing = false
	disconnected.emit()


## Returns the LFS license name corresponding to the given [param ucid], or an empty [String]
## if not found (invalid [param ucid], player left, or [code]0[/code] (host)).
func get_connection_username(ucid: int) -> String:
	if connections.has(ucid):
		return connections[ucid].username
	return ""


## Returns the player name corresponding to the given [param ucid], or an empty [String]
## if not found (invalid [param ucid] or player left).
func get_connection_nickname(ucid: int) -> String:
	if connections.has(ucid):
		return connections[ucid].nickname
	return ""


## Returns the player name corresponding to the given [param plid], or an empty [String]
## if not found (invalid [param plid] or player joined the spectators).
func get_player_name(plid: int) -> String:
	if players.has(plid):
		return players[plid].player_name
	return ""


## Attempts to connect to InSim at the given [param address] and [param port], with the
## specified [param init_data]. If [param use_udp] is [code]true[/code], a UDP connection will be
## used instead of TCP.[br]
## [b]Note:[/b] Using TCP is generally the preferred solution to prevent missing or unordered
## packets; UDP should be reserved for cases where you want minimal latency and don't mind losing
## some packets.[br]
## [b]Tip:[/b] You can set the [member InSimInitializationData.udp_port] to request [InSimNLPPacket]
## or [InSimMCIPacket] updates via UDP while using a TCP connection for other packets. Read
## [code]InSim.txt[/code] for more details.
func initialize(
	address: String, port: int, init_data: InSimInitializationData, use_udp := false
) -> void:
	initialization_data = init_data
	if lfs_connection and (
		use_udp and lfs_connection is LFSConnectionTCP
		or not use_udp and lfs_connection is LFSConnectionUDP
	):
		remove_child(lfs_connection)
		lfs_connection.queue_free()
		await get_tree().process_frame
	if lfs_connection:
		lfs_connection._disconnect_from_host()
	else:
		if use_udp:
			lfs_connection = LFSConnectionUDP.new()
		else:
			lfs_connection = LFSConnectionTCP.new()
		add_child(lfs_connection)
		_connect_lfs_connection_signals()
	_initializing = true
	lfs_connection._connect_to_host(address, port, initialization_data.udp_port)


## Returns [code]true[/code] if this InSim instance is a host application (remote connected
## to the host server with InSim access); returns [code]false[/code] otherwise.
func is_host() -> bool:
	return _is_host


## Sends a UTF8-formatted text string to LFS as a local message.
func send_local_message(
	message: String, sound := InSim.MessageSound.SND_SILENT, sender := "InSim"
) -> void:
	var message_buffer := LFSText.unicode_to_lfs_bytes(message)
	if message_buffer.size() < InSimMSLPacket.MSG_MAX_LENGTH:
		send_packet(InSimMSLPacket.create(message, sound), sender)
		return
	for split_message in LFSText.split_message(message, InSimMSLPacket.MSG_MAX_LENGTH):
		send_local_message(split_message, sound, sender)


## Sends a UTF8-formatted message to LFS as user. Color codes (e.g. ^1 for red)
## will be converted accordingly.
func send_message(message: String, sender := "InSim") -> void:
	var message_buffer := LFSText.unicode_to_lfs_bytes(message)
	var packet: InSimPacket = null
	if message.begins_with("/"):
		packet = InSimMSTPacket.create(message)
	elif message_buffer.size() < InSimMSTPacket.MSG_MAX_LENGTH:
		packet = InSimMSTPacket.create(message)
	elif message_buffer.size() < InSimMSXPacket.MSG_MAX_LENGTH:
		packet = InSimMSXPacket.create(message)
	else:
		for split_message in LFSText.split_message(message, InSimMSXPacket.MSG_MAX_LENGTH):
			send_message(split_message, sender)
		return
	send_packet(packet, sender)


## Sends a UTF8-formatted message to a specific connection, identified by its [param ucid].
## A value of 255 will send the message to everyone.[br]
## [b]Note:[/b] On a local [InSim] instance, [method send_local_message] is called instead.
func send_message_to_connection(
	ucid: int, message: String, sound := InSim.MessageSound.SND_SILENT, sender := "InSim"
) -> void:
	if not _is_host:
		send_local_message(message, sound, sender)
		return
	var message_buffer := LFSText.unicode_to_lfs_bytes(message)
	if message_buffer.size() < InSimMTCPacket.TEXT_MAX_LENGTH:
		send_packet(InSimMTCPacket.create(ucid, 0, message, sound), sender)
		return
	for split_message in LFSText.split_message(message, InSimMTCPacket.TEXT_MAX_LENGTH):
		send_message_to_connection(ucid, split_message, sound, sender)


## Sends a UTF8-formatted message to a specific player, identified by their [param plid].[br]
## [b]Note:[/b] On a local [InSim] instance, [method send_local_message] is called instead.
func send_message_to_player(
	plid: int, message: String, sound := InSim.MessageSound.SND_SILENT, sender := "InSim"
) -> void:
	if not _is_host:
		send_local_message(message, sound, sender)
		return
	var message_buffer := LFSText.unicode_to_lfs_bytes(message)
	if message_buffer.size() < InSimMTCPacket.TEXT_MAX_LENGTH:
		send_packet(InSimMTCPacket.create(0, plid, message, sound), sender)
		return
	for split_message in LFSText.split_message(message, InSimMTCPacket.TEXT_MAX_LENGTH):
		send_message_to_player(plid, split_message, sound, sender)


## Sends an InSim packet to LFS. You can pass the name of your application to
## [param sender] if you want to identify the origin of sent packets (by connecting
## the [signal packet_sent] signal).
func send_packet(packet: InSimPacket, sender := "InSim") -> void:
	if not packet:
		push_warning("Null packet was not sent.")
		return
	if not lfs_connection:
		push_error("No connection, cannot send packet.")
		return
	if (
		not insim_connected
		and not _initializing
		and packet.type != Packet.ISP_ISI
		and not (
			packet.type == Packet.ISP_TINY
			and (packet as InSimTinyPacket).sub_type == Tiny.TINY_PING
		)
	):
		push_error("Cannot send packet: InSim is not connected.")
	packet.fill_buffer()
	var packet_sent_successfully := lfs_connection._send_packet(packet.buffer)
	if packet_sent_successfully:
		packet_sent.emit(packet, sender)


## Sends the given packet [param to_send], and awaits and returns the packet [param to_await].
## Calls [method await_packet] internally, passing [param to_send]'s [member InSimPacket.req_i].
func send_packet_await_packet(
	to_send: InSimPacket, to_await: Packet, details := {}, sender := "InSim"
) -> InSimPacket:
	send_packet(to_send, sender)
	return await await_packet(to_await, to_send.req_i, details)


## Sends the given packet [param to_send], and awaits for the given [param number] of packets
## of type [param to_await] to be received before returning them. Calls
## [method await_packets] internally, passing [param to_send]'s [member InSimPacket.req_i].
func send_packet_await_packets(
	to_send: InSimPacket, to_await: Packet, number: int, details := {}, sender := "InSim"
) -> Array[InSimPacket]:
	send_packet(to_send, sender)
	return await await_packets(to_await, number, to_send.req_i, details)


## Sends multiple [param packets] passed in an array, calling [method send_packet] for each packet.
func send_packets(packets: Array[InSimPacket], sender := "InSim") -> void:
	for packet in packets:
		send_packet(packet, sender)


#region Buttons
## Sends an [InSimBTNPacket] corresponding to every button defined by the data passed.
## See [method add_solo_button] for more details on button definition. Internally, this
## calls [method InSimButtonManager.add_multi_button]. If [param ucids] is empty, the button
## will be considered global, and every player will receive it; additionally, any player
## joining the server will also receive that button. You can connect to the
## [signal global_buttons_restored] signal to [method update_multi_button].[br]
## When sending a button to multiple connections, you can map the button's text to
## each UCID by passing a [Callable] to [param text] instead of a regular [String]
## (see example code below). Similarly, you can customize the [param caption] and
## [param type_in]. For each of those parameters, the [Callable] must return the
## appropriate type, and should take a UCID as argument, so the value can be mapped
## to each UCID properly.[br]
## The following example shows how you can tailor the button's text to each player,
## by displaying their name in the upper-left corner of the screen:
## [codeblock]
## # Assuming your InSim instance is named insim
## insim.add_multi_button(
## 	[],  # empty array, will retrieve all connections (global button)
## 	Vector2i(0, 0),
## 	Vector2i(30, 5),
## 	InSim.ButtonStyle.ISB_DARK,
## 	func(ucid: int) -> String: return insim.get_connection_nickname(ucid),
## )
## [/codeblock]
func add_multi_button(
	ucids: Array[int], position: Vector2i, size: Vector2i, style: int, text: Variant,
	button_name := "", type_in: Variant = 0, caption: Variant = "", show_everywhere := false,
	sender := "InSim",
) -> void:
	if type_in > 0:
		style |= InSim.ButtonStyle.ISB_CLICK
	for packet in button_manager.add_multi_button(
		ucids, position, size, style, text, button_name, type_in, caption, show_everywhere
	):
		send_packet(packet, sender)


## Sends an [InSimBTNPacket] corresponding to the data passed. Button definition is
## mostly in line with [InSimBTNPacket], replacing [member InSimBTNPacket.inst] with
## the [param show_everywhere] boolean and using [Vector2i] for [param position] and
## [param size]. Internally, this function calls [method InSimButtonManager.add_solo_button].[br]
## If you set [param type_in] to a value greater than [code]0[/code], the
## [constant InSim.ButtonStyle.ISB_CLICK] flag is automatically added to [param style].[br]
## [b]Note:[/b] This function allows you to create a single button, i.e. fixed data for
## a given UCID (including [constant UCID_ALL]) and a given (generated) clickID.
## If you want to send a button to multiple players (or everyone), and possibly customize
## the contents for every player, use [method add_multi_button] instead.
func add_solo_button(
	ucid: int, position: Vector2i, size: Vector2i, style: int, text: String, button_name := "",
	type_in := 0, caption := "", show_everywhere := false, sender := "InSim",
) -> void:
	if type_in > 0:
		style |= InSim.ButtonStyle.ISB_CLICK
	var packet := button_manager.add_solo_button(
		ucid, position, size, style, text, button_name, type_in, caption, show_everywhere
	)
	if packet:
		send_packet(packet, sender)


## Deletes an [InSimButton] using the given [param button] reference, and sends the
## corresponding [InSimBFNPacket]s. When deleting an [InSimMultiButton], [param ucids]
## allows you to delete the button only for some players, while leaving it empty will
## delete it for everyone; [param ucids] is ignored when deleting an [InSimSoloButton].
## If you want to delete multiple buttons in one call, you can use [method delete_buttons].
func delete_button(button: InSimButton, ucids: Array[int] = [], sender := "InSim") -> void:
	for packet in button_manager.delete_button(button, ucids):
		send_packet(packet, sender)


## Deletes all given buttons [param to_delete], calling [method delete_button] for each
## of them, and sends the corresponding [InSimBFNPacket]s. Passing an non-empty
## [param ucids] array allows you to "filter" which players will have their buttons
## deleted (only for [InSimMultiButton], as [InSimSoloButton] will always be deleted).
func delete_buttons(
	to_delete: Array[InSimButton], ucids: Array[int] = [], sender := "InSim"
) -> void:
	for packet in button_manager.delete_buttons(to_delete, ucids):
		send_packet(packet, sender)


## Disables button updates for the given [param ucid].
## See [member InSimButtonManager.disabled_ucids] for details,
## and [method enable_buttons_for_ucid] for the opposite method.
func disable_buttons_for_ucid(ucid: int) -> void:
	button_manager.disable_buttons_for_ucid(ucid)


## Enables button updates for the given [param ucid].
## See [member InSimButtonManager.disabled_ucids] for details,
## and [method disable_buttons_for_ucid] for the opposite method.
func enable_buttons_for_ucid(ucid: int) -> void:
	button_manager.enable_buttons_for_ucid(ucid)


## Returns the [InSimButton] matching the given [param click_id] and [param ucid], or
## [code]null[/code] if no matching button is found. If [param retry_with_ucid_all]
## is [code]true[/code], and no button was found, attempts to find the [param click_id]
## for [constant UCID_ALL].[br]
## [b]Important:[/b] If a single UCID mapping from an [InSimMultiButton] matches,
## the button is returned, including all UCID mappings; if you are using this method
## to delete buttons, make sure not to delete more buttons than intended.
func get_button_by_id(click_id: int, ucid: int, retry_with_ucid_all := false) -> InSimButton:
	return button_manager.get_button_by_id(click_id, ucid, retry_with_ucid_all)


## Returns the first [InSimButton] matching the given [param button_name], filtered by
## the given [param ucid], or [code]null[/code] if no matching button is found.
## If [param ucid] is equal to [code]-1[/code], it is ignored, and all UCIDs become valid
## for matching the button.[br]
## [b]Note:[/b] If multiple buttons have the same name, the returned button may not be
## the expected one; you should always make sure to give unique names to your buttons.
func get_button_by_name(button_name: StringName, ucid := -1) -> InSimButton:
	return button_manager.get_button_by_name(button_name, ucid)


## Returns an [InSimButton] [Array] containing all buttons with clickIDs in the range
## defined by [param click_id] and [param click_max] (both ends inclusive) for the
## given [param ucids], or an empty array if no matching button is found. If [param ucids]
## is empty, all UCIDs are valid for matching.[br]
## [b]Important:[/b] If a single UCID mapping from an [InSimMultiButton] matches,
## the complete button is included in the array; if you are using this method to delete
## buttons, make sure not to delete more buttons than intended.
func get_buttons_by_id_range(
	click_id: int, click_max := 0, ucids: Array[int] = []
) -> Array[InSimButton]:
	return button_manager.get_buttons_by_id_range(click_id, click_max, ucids)


## Returns all [InSimButton]s whose name starts with the given [param prefix] for
## the given [param ucids], or an empty array if no matching button is found.
## If [param ucids] is empty, all UCIDs are valid for matching.
func get_buttons_by_prefix(prefix: StringName, ucids: Array[int] = []) -> Array[InSimButton]:
	return button_manager.get_buttons_by_prefix(prefix, ucids)


## Returns all [InSimButton]s whose name matches the given [param regex] for the
## given [param ucids], or an empty array if no matching button is found.
## If [param ucids] is empty, all UCIDs are valid for matching.
func get_buttons_by_regex(regex: RegEx, ucids: Array[int] = []) -> Array[InSimButton]:
	return button_manager.get_buttons_by_regex(regex, ucids)


## Sends all global buttons (see [method InSimButtonManager.get_global_buttons])
## to the player associated with the given [param ucid], and emits the
## [signal global_buttons_restored], which you can connect to in order to update
## those buttons' contents.
func restore_global_buttons(ucid: int) -> void:
	for packet in button_manager.get_global_button_packets(ucid):
		send_packet(packet)
	global_buttons_restored.emit(ucid)


## Updates the text of the [param button] with the given [param text], [param caption],
## and [param type_in], using be either a [String] ([int] for [param type_in]) or
## a [Callable] taking a [code]ucid[/code] parameter and returning a [String] ([int]
## for [param type_in]). The default value of [code]-1[/code] for [param type_in] leaves
## its value unchanged.
func update_multi_button(
	button: InSimMultiButton, text: Variant, caption: Variant = "", type_in: Variant = -1,
	sender := "InSim",
) -> void:
	for packet in button_manager.update_multi_button(button, text, caption, type_in):
		send_packet(packet, sender)


## Updates the contents of the [param button] using the given [param text],
## [param caption], and optional [param type_in]. An [InSimBTNPacket] corresponding to
## the updated button is sent automatically, unless the button was not modified.
func update_solo_button(
	button: InSimSoloButton, text: String, caption := "", type_in := -1, sender := "InSim"
) -> void:
	if not button:
		push_error("Cannot update button text, button is null.")
		return
	var packet := button_manager.update_solo_button(button, text, caption, type_in)
	if packet:
		send_packet(packet, sender)
#endregion


func _await_packet(type: Packet, details := {}) -> InSimPacket:
	while true:
		var packet: InSimPacket = await packet_received
		if packet.type == type:
			var properties := packet.get_property_list().filter(func(prop: Dictionary) -> bool:
				return prop["name"] in details
			)
			if properties.all(func(prop: Dictionary) -> bool:
				var prop_name := prop["name"] as String
				var prop_type := prop["type"] as int
				return packet.get(prop_name) == type_convert(details[prop_name], prop_type)
			):
				return packet
	return null


func _connect_lfs_connection_signals() -> void:
	var _discard := lfs_connection.connected.connect(_on_connected_to_host)
	_discard = lfs_connection.connection_failed.connect(_on_connection_failed)
	_discard = lfs_connection.packet_received.connect(_on_packet_received)


func _handle_timeout() -> void:
		timeout.emit()
		insim_connected = false
		push_error("InSim connection timed out.")
		close()


# Defers connected signal until all requested packets for initialization are received.
func _perform_internal_initialization() -> void:
	print("Initializing Godot InSim...")
	var _packet: InSimPacket = await send_packet_await_packet(
		InSimTinyPacket.create(GIS_REQI, InSim.Tiny.TINY_SST), Packet.ISP_STA
	)
	var ism_packet: InSimISMPacket = await send_packet_await_packet(
		InSimTinyPacket.create(GIS_REQI, InSim.Tiny.TINY_ISM), Packet.ISP_ISM
	)
	_is_host = lfs_state.flags & InSim.State.ISS_MULTI and ism_packet.host == 1
	await get_tree().process_frame
	# We don't need to request IS_NCN/IS_NPL packets as this is done when receiving an IS_ISM.
	while (
		connections.size() < lfs_state.num_connections
		or players.size() < lfs_state.num_players
	):
		await get_tree().process_frame

	_initializing = false
	insim_connected = true
	print("Godot InSim is ready")
	connected.emit.call_deferred()


func _push_error_unknown_packet_subtype(type: int, subtype: int) -> void:
	push_error("%s with unknown packet subtype" % [
		Packet.keys()[Packet.values().find(type)],
		subtype,
	])


func _push_error_unknown_packet_type(type: int) -> void:
	push_error("Unknown packet type: %d" % [type])


func _read_ping_reply() -> void:
	insim_connected = true
	_reset_timeout_timer()


func _read_version_packet(packet: InSimVERPacket) -> void:
	print("Connected to LFS %s %s" % [packet.version, packet.product])
	if packet.insim_ver != VERSION:
		var message := "Game InSim version (%d) is different from local version (%d)" % [
			packet.insim_ver, VERSION
		]
		if not allow_different_insim_versions:
			push_error(message)
			printerr("Connection to InSim versions other than %d is not allowed." % [VERSION])
			printerr("You can force connection by enabling InSim.allow_different_insim_versions.")
			close()
			return
		push_warning(message)
	if not insim_connected:
		print("Game InSim version matches local version (%d)" % [VERSION])
		_perform_internal_initialization()


func _reset_timeout_timer() -> void:
	ping_timer.start(PING_INTERVAL)
	timeout_timer.stop()


func _send_keep_alive_packet() -> void:
	send_packet(InSimTinyPacket.create(0, Tiny.TINY_NONE))
	_reset_timeout_timer()


func _send_ping() -> void:
	timeout_timer.start(TIMEOUT_DELAY)
	send_packet(InSimTinyPacket.create(GIS_REQI, Tiny.TINY_PING))


func _on_connected_to_host() -> void:
	send_packet(InSimISIPacket.create(
		initialization_data.udp_port,
		initialization_data.flags,
		initialization_data.prefix,
		initialization_data.interval,
		initialization_data.admin,
		initialization_data.i_name
	))
	nlp_mci_connection._disconnect_from_host()
	if initialization_data.udp_port != 0:
		nlp_mci_connection._connect_to_host(
			lfs_connection.address, lfs_connection.udp_port, 0, true
		)
	_reset_timeout_timer()


func _on_connection_failed() -> void:
	push_error("Could not connect to %s:%d." % [lfs_connection.address, lfs_connection.port])


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
		Packet.ISP_IPB:
			isp_ipb_received.emit(packet)
		Packet.ISP_AIC:
			isp_aic_received.emit(packet)
		Packet.ISP_AII:
			isp_aii_received.emit(packet)
		_:
			_push_error_unknown_packet_type(packet.type)


func _on_small_packet_received(packet: InSimSmallPacket) -> void:
	match packet.sub_type:
		Small.SMALL_VTA:
			small_vta_received.emit(packet)
		Small.SMALL_RTP:
			small_rtp_received.emit(packet)
		Small.SMALL_ALC:
			small_alc_received.emit(packet)
		_:
			_push_error_unknown_packet_subtype(packet.type, packet.sub_type)


func _on_tiny_packet_received(packet: InSimTinyPacket) -> void:
	match packet.sub_type:
		Tiny.TINY_NONE:
			_send_keep_alive_packet()
		Tiny.TINY_REPLY:
			_read_ping_reply()
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
			_push_error_unknown_packet_subtype(packet.type, packet.sub_type)


func _on_udp_packet_received(packet_buffer: PackedByteArray) -> void:
	var packet := InSimPacket.create_packet_from_buffer(packet_buffer)
	udp_packet_received.emit(packet)
	match packet.type:
		Packet.ISP_NLP:
			udp_nlp_received.emit(packet)
		Packet.ISP_MCI:
			udp_mci_received.emit(packet)
		_:
			_push_error_unknown_packet_type(packet.type)


#region InSim event management: connections, players, state, buttons
func _on_isp_bfn_received(packet: InSimBFNPacket) -> void:
	var ucid := packet.ucid
	match packet.subtype:
		InSim.ButtonFunction.BFN_USER_CLEAR:
			disable_buttons_for_ucid(ucid)
			connection_cleared_buttons.emit(ucid)
		InSim.ButtonFunction.BFN_REQUEST:
			enable_buttons_for_ucid(ucid)
			connection_requested_buttons.emit(ucid)


func _on_isp_cnl_received(packet: InSimCNLPacket) -> void:
	var _discard := connections.erase(packet.ucid)
	button_manager.forget_buttons_for_ucid(packet.ucid)
	lfs_state.num_connections = packet.total


func _on_isp_cpr_received(packet: InSimCPRPacket) -> void:
	var connection := connections.get(packet.ucid, null) as GISConnection
	if connection:
		connection.nickname = packet.player_name
	for player: GISPlayer in players.values():
		if player.ucid == packet.ucid:
			player.player_name = packet.player_name
			player.plate = packet.plate


func _on_isp_ism_received(packet: InSimISMPacket) -> void:
	if packet.req_i == 0:
		connections.clear()
		players.clear()
	send_packet(InSimTinyPacket.create(GIS_REQI, InSim.Tiny.TINY_NCN))
	send_packet(InSimTinyPacket.create(GIS_REQI, InSim.Tiny.TINY_NPL))


func _on_isp_ncn_received(packet: InSimNCNPacket) -> void:
	if packet.req_i not in [0, GIS_REQI]:
		return
	var ucid := packet.ucid
	connections[ucid] = GISConnection.create_from_ncn_packet(packet)
	lfs_state.num_connections = packet.total
	if packet.req_i == 0:
		button_manager._add_global_button_mapping(ucid)
		restore_global_buttons(ucid)


func _on_isp_npl_received(packet: InSimNPLPacket) -> void:
	players[packet.plid] = GISPlayer.create_from_npl_packet(packet)
	if packet.num_players > 0:
		lfs_state.num_players = packet.num_players


func _on_isp_pfl_received(packet: InSimPFLPacket) -> void:
	var plid := packet.plid
	if not players.has(plid):
		push_error("%s: No player found with PLID %d" % [Packet.keys()[packet.type], plid])
		return
	var player := players[plid]
	player.flags = packet.flags


func _on_isp_pll_received(packet: InSimPLLPacket) -> void:
	var _discard := players.erase(packet.plid)
	lfs_state.num_players -= 1


func _on_isp_sta_received(packet: InSimSTAPacket) -> void:
	lfs_state.set_from_sta_packet(packet)


func _on_isp_toc_received(packet: InSimTOCPacket) -> void:
	var plid := packet.plid
	if not players.has(plid):
		push_error("%s: No player found with PLID %d" % [Packet.keys()[packet.type], plid])
		return
	var player := players[plid]
	player.ucid = packet.new_ucid
	player.player_name = get_connection_nickname(player.ucid)


func _on_tiny_clr_received(_packet: InSimTinyPacket) -> void:
	players.clear()
	lfs_state.num_players = 0


func _on_tiny_mpe_received(_packet: InSimTinyPacket) -> void:
	connections.clear()
	players.clear()
	send_packet(InSimTinyPacket.create(GIS_REQI, InSim.Tiny.TINY_NCN))
#endregion
