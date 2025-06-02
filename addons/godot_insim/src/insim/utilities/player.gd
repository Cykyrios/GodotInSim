class_name Player
extends RefCounted
## InSim driving player
##
## Utility object representing a player or AI currently driving, associated to a PLID.

enum PlayerType {
	FEMALE = 1,
	AI = 2,
	REMOTE = 4,
}

var ucid := 0  ## UCID associated to this player
var player_type := 0  ## Player type (female, AI and remote flags)
var flags := 0  ## Player flags, see [enum InSim.PlayerFlag].
var player_name := ""  ## Player name
var plate := ""  ## Player's plate
var car_name := ""  ## Player's car skin ID
var skin_name := ""  ## Player skin
var tyres: Array[InSim.Tyre] = []  ## Player's tyre compounds
var h_mass := 0  ## Added mass
var h_tres := 0  ## Intake restriction
var model := 0  ## Player model
var passengers := 0  ## Passengers
var rw_adjust := 0  ## Rear tyre width adjustment
var fw_adjust := 0  ## Front tyre width adjustment
var setup_flags := 0  ## Setup flags, see [enum InSim.Setup].
var config := 0  ## Vehicle configuration


## Creates and returns a new [Player] object from the given [param packet].
static func create_from_npl_packet(packet: InSimNPLPacket) -> Player:
	var new_player := Player.new()
	new_player.ucid = packet.ucid
	new_player.player_type = packet.player_type
	new_player.flags = packet.flags
	new_player.player_name = packet.player_name
	new_player.plate = packet.plate
	new_player.car_name = packet.car_name
	new_player.skin_name = packet.skin_name
	new_player.tyres = packet.tyres.duplicate()
	new_player.h_mass = packet.h_mass
	new_player.h_tres = packet.h_tres
	new_player.model = packet.model
	new_player.passengers = packet.passengers
	new_player.rw_adjust = packet.rw_adjust
	new_player.fw_adjust = packet.fw_adjust
	new_player.setup_flags = packet.setup_flags
	new_player.config = packet.config
	return new_player


## Returns a dictionary show the changed flags between [param new_flags] and [member flags].
func get_flags_changes(new_flags: int) -> Dictionary[String, String]:
	var changes: Dictionary[String, String] = {}
	for i in InSim.PlayerFlag.size():
		var key := InSim.PlayerFlag.keys()[i] as String
		var value := InSim.PlayerFlag.values()[i] as int
		if new_flags & value != flags & value:
			changes[key] = "ON" if new_flags & value else "OFF"
	return changes


## Returns [code]true[/code] is the player is an AI.
func is_ai() -> bool:
	return player_type & PlayerType.AI


## Returns [code]true[/code] is the player model is female.
func is_female() -> bool:
	return player_type & PlayerType.FEMALE


## Returns [code]true[/code] is the player is a human driver.
func is_human() -> bool:
	return not is_ai()


## Returns [code]true[/code] is the player is local to the InSim instance.
func is_local() -> bool:
	return not is_remote()


## Returns [code]true[/code] is the player is male.
func is_male() -> bool:
	return not is_female()


## Returns [code]true[/code] is the player is remote to the InSim instance.
func is_remote() -> bool:
	return player_type & PlayerType.REMOTE


## Sets [member player_type] from the values of [param p_female], [param p_ai],
## and [param p_remote].
func set_player_type(p_female := false, p_ai := false, p_remote := false) -> void:
	player_type = (
		(PlayerType.FEMALE if p_female else 0)
		+ (PlayerType.AI if p_ai else 0)
		+ (PlayerType.REMOTE if p_remote else 0)
	)
