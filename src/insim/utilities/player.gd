class_name Player
extends RefCounted


var ucid := 0
var player_type := 0
var flags := 0
var player_name := ""
var plate := ""
var car_name := ""
var skin_name := ""
var tyres: Array[InSim.Tyre] = []
var h_mass := 0
var h_tres := 0
var model := 0
var passengers := 0
var rw_adjust := 0
var fw_adjust := 0
var setup_flags := 0
var config := 0


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
