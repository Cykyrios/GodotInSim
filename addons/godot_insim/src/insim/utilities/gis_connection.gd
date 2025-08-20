class_name GISConnection
extends RefCounted
## InSim player connection
##
## Utility object representing a player connection, associated to a UCID.

## Connection flags
enum Flags {
	REMOTE = 4,
}

var ucid := 0  ## The UCID assigned to this connection.
var username := ""  ## The player's username
var nickname := ""  ## The player's nickname
var admin := false  ## Whether the player is an admin.
var flags := 0  ## Connection flags, see [enum Flags].


## Creates and returns a new [GISConnection] object from the given [param packet].
static func create_from_ncn_packet(packet: InSimNCNPacket) -> GISConnection:
	var new_connection := GISConnection.new()
	new_connection.ucid = packet.ucid
	new_connection.username = packet.user_name
	new_connection.nickname = packet.player_name
	new_connection.admin = packet.admin
	new_connection.flags = packet.flags
	return new_connection


## Returns [code]true[/code] if the given [param connection_flags] represent a local connection.
static func is_connection_local(connection_flags: int) -> bool:
	return GISConnection._is_local(connection_flags)


static func _is_local(connection_flags: int) -> bool:
	return true if (connection_flags & Flags.REMOTE) == 0 else false


## Returns [code]true[/code] if the connection is local ([constant Flags.REMOTE] equals 0).
func is_local() -> bool:
	return _is_local(flags)
