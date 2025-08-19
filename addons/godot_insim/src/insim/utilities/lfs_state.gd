class_name LFSState
extends RefCounted
## LFS game state
##
## Utility object representing the current state of the game, using [InSimSTAPacket].

var replay_speed := 1.0  ## Replay speed
var flags := 0  ## Game state flags, see [enum InSim.State].
var ingame_cam := InSim.View.VIEW_MAX  ## Current camera
var view_plid := 0  ## Currently viewed player's PLID
var num_players := 0  ## Number of driving players
var num_connections := 0  ## Number of connected players
var num_finished := 0  ## Number of players who have finished the race.
var race_in_progress := 0  ## Whether the race is in progress.
var qual_minutes := 0  ## Qualifying time in minutes
var race_laps := 0  ## Race laps (LFS-encoded value)
var server_status := 0  ## Server status
var track := ""  ## Current track (TTNR code)
var weather := 0  ## Current weather
var wind := 0  ## Current wind level


## Returns a dictionary of changed flags and their values, comparing [param new_flags] and
## [member flags].
func get_flags_changes(new_flags: int) -> Dictionary[String, String]:
	var changes: Dictionary[String, String] = {}
	for key: String in InSim.State:
		var value := InSim.State[key] as int
		if new_flags & value != flags & value:
			changes[key] = "ON" if new_flags & value else "OFF"
	return changes


## Returns a dictionary of changes in the state's properties, comparing the given
## [param state_packet] and the current state.
func get_state_changes(state_packet: InSimSTAPacket) -> Dictionary[String, Variant]:
	var changes: Dictionary[String, Variant] = {}
	if state_packet.replay_speed != replay_speed:
		changes["Replay Speed"] = state_packet.replay_speed
	if state_packet.flags != flags:
		changes["Flags"] = get_flags_changes(state_packet.flags)
	if state_packet.ingame_cam != ingame_cam:
		changes["InGame Cam"] = InSim.View.find_key(state_packet.ingame_cam)
	if state_packet.view_plid != view_plid:
		changes["View PLID"] = state_packet.view_plid
	if state_packet.num_players != num_players:
		changes["Num Players"] = state_packet.num_players
	if state_packet.num_connections != num_connections:
		changes["Num Connections"] = state_packet.num_connections
	if state_packet.num_finished != num_finished:
		changes["Num Finished"] = state_packet.num_finished
	if state_packet.race_in_progress != race_in_progress:
		changes["Race In Progress"] = state_packet.race_in_progress
	if state_packet.qual_mins != qual_minutes:
		changes["Quali Minutes"] = state_packet.qual_mins
	if state_packet.race_laps != race_laps:
		changes["Race Laps"] = state_packet.race_laps
	if state_packet.server_status != server_status:
		changes["Server Status"] = state_packet.server_status
	if state_packet.track != track:
		changes["Track"] = state_packet.track
	if state_packet.weather != weather:
		changes["Weather"] = state_packet.weather
	if state_packet.wind != wind:
		changes["Wind"] = state_packet.wind
	return changes


## Sets the current state's properties from the given [param packet].
func set_from_sta_packet(packet: InSimSTAPacket) -> void:
	replay_speed = packet.replay_speed
	flags = packet.flags
	ingame_cam = packet.ingame_cam
	view_plid = packet.view_plid
	num_players = packet.num_players
	num_connections = packet.num_connections
	num_finished = packet.num_finished
	race_in_progress = packet.race_in_progress
	qual_minutes = packet.qual_mins
	race_laps = packet.race_laps
	server_status = packet.server_status
	track = packet.track
	weather = packet.weather
	wind = packet.wind
