class_name LFSConnection
extends Node

## Base class for connection and data I/O with LFS
##
## InSim initialization automatically creates either a TCP connection or a UDP connection,
## depending on parameters passed.

signal connection_failed
signal connected
signal disconnected
signal packet_received(packet: LFSPacket)
signal packet_sent(packet: LFSPacket)

var address := ""
var port := 0
var udp_port := 0


func _process(_delta: float) -> void:
	get_incoming_packets()


func connect_to_host(_address: String, _port: int, _udp_port := 0) -> void:
	address = _address
	port = _port
	udp_port = _udp_port


func disconnect_from_host() -> void:
	pass


func get_incoming_packets() -> void:
	pass


@warning_ignore("unused_parameter")
func send_packet(packet: InSimPacket) -> void:
	pass
