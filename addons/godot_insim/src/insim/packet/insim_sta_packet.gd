class_name InSimSTAPacket
extends InSimPacket

## STAte packet

const TRACK_NAME_LENGTH := 6

const PACKET_SIZE := 28
const PACKET_TYPE := InSim.Packet.ISP_STA
var zero := 0

var replay_speed := 0.0  ## 4-byte float - 1.0 is normal speed

var flags := 0  ## state flags (see [enum InSim.State])
var ingame_cam := InSim.View.VIEW_MAX  ## Which type of camera is selected (see [enum InSim.View])
var view_plid := 0  ## Unique ID of viewed player (0 = none)

var num_players := 0  ## Number of players in race
var num_connections := 0  ## Number of connections including host
var num_finished := 0  ## Number finished or qualified
var race_in_progress := 0  ## 0 = no race / 1 = race / 2 = qualifying

var qual_mins := 0  ## qualifying duration
## race laps, with the following meanings depending on range:[br]
## 0: practice[br]
## 1-99: number of laps... laps = rl[br]
## 100-190: 100 to 1000 laps... laps = (rl - 100) * 10 + 100[br]
## 191-238: 1 to 48 hours... hours = rl - 190
var race_laps := 0  ## see "RaceLaps" near the top of this document
var sp2 := 0
var server_status := 0  ## 0 = unknown / 1 = success / > 1 = fail

var track := ""  ## short name for track e.g. FE2R
var weather := 0  ## 0,1,2...
var wind := 0  ## 0 = off / 1 = weak / 2 = strong


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
	replay_speed = read_float()

	flags = read_word()
	ingame_cam = read_byte() as InSim.View
	view_plid = read_byte()

	num_players = read_byte()
	num_connections = read_byte()
	num_finished = read_byte()
	race_in_progress = read_byte()

	qual_mins = read_byte()
	race_laps = read_byte()
	sp2 = read_byte()
	server_status = read_byte()

	track = read_string(TRACK_NAME_LENGTH)
	weather = read_byte()
	wind = read_byte()


func _get_data_dictionary() -> Dictionary:
	return {
		"Zero": zero,
		"ReplaySpeed": replay_speed,
		"Flags": flags,
		"InGameCam": ingame_cam,
		"ViewPLID": view_plid,
		"NumP": num_players,
		"NumConns": num_connections,
		"NumFinished": num_finished,
		"RaceInProg": race_in_progress,
		"QualMins": qual_mins,
		"RaceLaps": race_laps,
		"Sp2": sp2,
		"ServerStatus": server_status,
		"Track": track,
		"Weather": weather,
		"Wind": wind,
	}


func _get_pretty_text() -> String:
	return "State changed"
