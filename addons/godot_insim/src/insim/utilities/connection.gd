class_name Connection
extends RefCounted
## InSim player connection
##
## Utility object representing a player connection, associated to a UCID.


var username := ""  ## The player's username
var nickname := ""  ## The player's nickname
var admin := false  ## Whether the player is an admin.
var flags := 0  ## Connection flags, see [enum Flags].


## Creates and returns a new [Connection] object from the given [param packet].
static func create_from_ncn_packet(packet: InSimNCNPacket) -> Connection:
	var new_connection := Connection.new()
	new_connection.username = packet.user_name
	new_connection.nickname = packet.player_name
	new_connection.admin = packet.admin
	new_connection.flags = packet.flags
	return new_connection
