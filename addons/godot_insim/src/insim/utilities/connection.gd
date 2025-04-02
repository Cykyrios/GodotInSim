class_name Connection
extends RefCounted


var username := ""
var nickname := ""
var admin := false
var flags := 0


static func create_from_ncn_packet(packet: InSimNCNPacket) -> Connection:
	var new_connection := Connection.new()
	new_connection.username = packet.user_name
	new_connection.nickname = packet.player_name
	new_connection.admin = packet.admin
	new_connection.flags = packet.flags
	return new_connection
