class_name LFSConnection
extends Node
## Base class for connection and data I/O with LFS
##
## InSim initialization automatically creates either a TCP connection or a UDP connection,
## depending on parameters passed.[br]
## [b]Warning:[/b] This class is not intended to be used directly, nor are [LFSConnectionTCP] and
## [LFSConnectionUDP]; an [LFSConnection] object is included in all protocol objects ([InSim],
## [OutGauge], [OutSim]) and is supposed to stay internal. You can use [signal InSim.timeout]
## and [member InSim.insim_connected] instead if you need to check connection status.

@warning_ignore_start("unused_signal")
signal connection_failed
signal connected
signal disconnected
signal packet_received(packet: PackedByteArray)
@warning_ignore_restore("unused_signal")

var address := ""  ## The IP address to connect to
var port := 0  ## The port to listen to
var udp_port := 0  ## Dedicated UDP port for responses, see [code]docs/InSim.txt[/code] for details.


func _process(_delta: float) -> void:
	_get_incoming_packets()


## Virtual function to be overridden, starting with a call to [code]super[/code].
## Connects to the host at the given [param c_address] and [param c_port]; [param c_udp_port] can
## be used for TCP connections expecting UDP responses on a different port.
func _connect_to_host(c_address: String, c_port: int, c_udp_port := 0) -> void:
	address = c_address
	port = c_port
	udp_port = c_udp_port


## Virtual function to be overridden. Disconnects from the host.
func _disconnect_from_host() -> void:
	pass


## Virtual function to be overridden. Reads incoming packets.
func _get_incoming_packets() -> void:
	pass


## Virtual function to be overridden. Sends a raw [param packet].
@warning_ignore("unused_parameter")
func _send_packet(packet: PackedByteArray) -> bool:
	return false
