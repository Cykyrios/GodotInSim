class_name InSimPLHPacket
extends InSimPacket


const PLH_MAX_PLAYERS := 40
const PLH_DATA_SIZE := 4

const PACKET_MIN_SIZE := 4 + PLH_DATA_SIZE
const PACKET_MAX_SIZE := 4 + PLH_DATA_SIZE * PLH_MAX_PLAYERS
const PACKET_TYPE := InSim.Packet.ISP_PLH
var nump := 0

var hcaps: Array[PlayerHCap] = []


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if (
		packet_size < PACKET_MIN_SIZE
		or packet_size > PACKET_MAX_SIZE
		or packet_size % SIZE_MULTIPLIER != 0
	):
		push_error("%s packet expected size [%d..%d step %d], got %d." % [InSim.Packet.keys()[type],
				PACKET_MIN_SIZE, PACKET_MAX_SIZE, SIZE_MULTIPLIER, packet_size])
		return
	super(packet)
	nump = read_byte(packet)
	hcaps.clear()
	for i in nump:
		var player_hcap := PlayerHCap.new()
		player_hcap.player_id = read_byte(packet)
		player_hcap.flags = read_byte(packet)
		player_hcap.h_mass = read_byte(packet)
		player_hcap.h_tres = read_byte(packet)
		hcaps.append(player_hcap)


func _fill_buffer() -> void:
	super()
	update_req_i()
	add_byte(nump)
	for i in hcaps.size():
		add_byte(hcaps[i].player_id)
		add_byte(hcaps[i].flags)
		add_byte(hcaps[i].h_mass)
		add_byte(hcaps[i].h_tres)


func _get_data_dictionary() -> Dictionary:
	return {
		"NumP": nump,
		"HCaps": hcaps,
	}


func remove_unused_data() -> void:
	size = 4 + PLH_DATA_SIZE * hcaps.size()
	resize_buffer(size)


class PlayerHCap extends RefCounted:
	const H_MASS_MAX := 200
	const H_TRES_MAX := 50

	var player_id := 0
	var flags := 0
	var h_mass := 0:
		set(new_mass):
			h_mass = clampi(new_mass, 0, H_MASS_MAX)
	var h_tres := 0:
		set(new_tres):
			h_tres = clampi(new_tres, 0, H_TRES_MAX)

	func _to_string() -> String:
		return "(PLID %d, Flags %d, %dkg, %d%%)" % [player_id, flags, h_mass, h_tres]
