class_name LFSState
extends RefCounted


var replay_speed := 1.0
var flags := 0
var ingame_cam := InSim.View.VIEW_MAX
var view_plid := 0
var num_players := 0
var num_connections := 0
var num_finished := 0
var race_in_progress := 0
var qual_minutes := 0
var race_laps := 0
var server_status := 0
var track := ""
var weather := 0
var wind := 0


func get_flags_changes(new_flags: int) -> Dictionary[String, String]:
	var changes: Dictionary[String, String] = {}
	for i in InSim.State.size():
		var key := InSim.State.keys()[i] as String
		var value := InSim.State.values()[i] as int
		if new_flags & value != flags & value:
			changes[key] = "ON" if new_flags & value else "OFF"
	return changes


func get_state_changes(state_packet: InSimSTAPacket) -> Dictionary[String, Variant]:
	var changes: Dictionary[String, Variant] = {}
	if state_packet.replay_speed != replay_speed:
		changes["Replay Speed"] = replay_speed
	if state_packet.flags != flags:
		changes["Flags"] = get_flags_changes(state_packet.flags)
	if state_packet.ingame_cam != ingame_cam:
		changes["InGame Cam"] = InSim.View.keys()[ingame_cam]
	if state_packet.view_plid != view_plid:
		changes["View PLID"] = view_plid
	if state_packet.num_players != num_players:
		changes["Num Players"] = num_players
	if state_packet.num_connections != num_connections:
		changes["Num Connections"] = num_connections
	if state_packet.num_finished != num_finished:
		changes["Num Finished"] = num_finished
	if state_packet.race_in_progress != race_in_progress:
		changes["Race In Progress"] = race_in_progress
	if state_packet.qual_mins != qual_minutes:
		changes["Quali Minutes"] = qual_minutes
	if state_packet.race_laps != race_laps:
		changes["Race Laps"] = race_laps
	if state_packet.server_status != server_status:
		changes["Server Status"] = server_status
	if state_packet.track != track:
		changes["Track"] = track
	if state_packet.weather != weather:
		changes["Weather"] = weather
	if state_packet.wind != wind:
		changes["Wind"] = wind
	return changes


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
