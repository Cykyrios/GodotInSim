class_name InSimRelayPacket
extends InSimPacket
## InSim Relay packet
##
## Base packet for InSim Relay specific packets.[br]
## [b]Note:[/b] InSim Relay packets are technically identical to standard InSim packets.

const RELAY_SIZE_MULTIPLIER := 1


func _init() -> void:
	super()
	size_multiplier = RELAY_SIZE_MULTIPLIER


# Undoes the packet header's size reduction for standard InSim packets.
# See issue #5, this override should go if/when Relay packets stop being different.
func _fill_buffer() -> void:
	super()
	buffer[0] = buffer[0] * INSIM_SIZE_MULTIPLIER
