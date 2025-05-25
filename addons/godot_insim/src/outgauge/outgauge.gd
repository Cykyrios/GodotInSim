class_name OutGauge
extends Node
## OutGauge interface
##
## You can add an [OutGauge] node to any scene to enable reading data from LFS.[br]
## [b]Note:[/b] OutGauge requires some setup in the [code]cfg.txt[/code] file; you can find more
## details in the [code]docs/InSim.txt[/code] file, in the section pertaining to OutGauge.

## Emitted when a packet is received. You should connect to this signal if you plan to use OutGauge.
signal packet_received(packet: OutGaugePacket)

var _lfs_connection := LFSConnectionUDP.new()


## Creates and returns an [OutGaugePacket] from the given [param packet_buffer]. This method is
## not intended to be used directly, and is called automatically by an [OutGauge] instance when it
## receives a raw packet.
static func create_packet_from_buffer(packet_buffer: PackedByteArray) -> OutGaugePacket:
	var packet := OutGaugePacket.new()
	packet.buffer = packet_buffer
	packet.decode_packet(packet_buffer)
	return packet


func _ready() -> void:
	add_child(_lfs_connection)
	var _discard := _lfs_connection.packet_received.connect(_on_packet_received)


## Closes the [OutGauge] connection, disabling packet reading.[br]
## [b]Note:[/b] As OutGauge data is transmitted over UDP, there is no connection per se; this simply
## means the [OutGauge] instance will stop listening to packets.
func close() -> void:
	_lfs_connection._disconnect_from_host()


## Enables packet listening over UDP with the given [param address] and [param port].
func initialize(address := "127.0.0.1", port := 29_998) -> void:
	_lfs_connection._connect_to_host(address, port, 0, true)


func _on_packet_received(packet_buffer: PackedByteArray) -> void:
	var packet := OutGauge.create_packet_from_buffer(packet_buffer)
	packet_received.emit(packet as OutGaugePacket)
