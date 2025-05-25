class_name InSimPLHPacket
extends InSimPacket
## PLayer Handicaps packet - variable size
##
## This packet is sent to set player handicaps, and received when a player handicap is changed.

const PLH_MAX_PLAYERS := 40  ## Max players per packet
const PLH_DATA_SIZE := 4  ## Handicap data size

const PACKET_BASE_SIZE := 4  ## Base packet size
const PACKET_MIN_SIZE := PACKET_BASE_SIZE  ## Minimum packet size
const PACKET_MAX_SIZE := PACKET_BASE_SIZE + PLH_DATA_SIZE * PLH_MAX_PLAYERS  ## Maximum packet size
const PACKET_TYPE := InSim.Packet.ISP_PLH  ## The packet's type, see [enum InSim.Packet].
var nump := 0  ## Number of players in this packet

var hcaps: Array[PlayerHandicap] = []  ## Handicaps, 0 to [constant PLH_MAX_PLAYERS] ([member nump])


## Creates and returns a new [InSimPLHPacket] from the given parameters.
static func create(plh_nump: int, plh_hcaps: Array[PlayerHandicap]) -> InSimPLHPacket:
	var packet := InSimPLHPacket.new()
	packet.nump = plh_nump
	packet.hcaps = plh_hcaps.duplicate()
	return packet


func _init() -> void:
	size = PACKET_MAX_SIZE
	type = PACKET_TYPE
	receivable = true
	sendable = true


func _decode_packet(packet: PackedByteArray) -> void:
	var packet_size := packet.size()
	if (
		packet_size < PACKET_MIN_SIZE
		or packet_size > PACKET_MAX_SIZE
		or packet_size % SIZE_MULTIPLIER != 0
	):
		push_error("%s packet expected size [%d..%d step %d], got %d." % [get_type_string(),
				PACKET_MIN_SIZE, PACKET_MAX_SIZE, SIZE_MULTIPLIER, packet_size])
		return
	super(packet)
	nump = read_byte()
	hcaps.clear()
	for i in nump:
		var player_hcap := PlayerHandicap.new()
		player_hcap.plid = read_byte()
		player_hcap.flags = read_byte()
		player_hcap.h_mass = read_byte()
		player_hcap.h_tres = read_byte()
		hcaps.append(player_hcap)


func _fill_buffer() -> void:
	super()
	update_req_i()
	nump = mini(nump, hcaps.size())
	add_byte(nump)
	resize_buffer(PACKET_BASE_SIZE + nump * PLH_DATA_SIZE)
	for i in nump:
		add_byte(hcaps[i].plid)
		add_byte(hcaps[i].flags)
		add_byte(hcaps[i].h_mass)
		add_byte(hcaps[i].h_tres)


func _get_data_dictionary() -> Dictionary:
	return {
		"NumP": nump,
		"HCaps": hcaps,
	}


func _get_pretty_text() -> String:
	var handicaps := ""
	for i in hcaps.size():
		var hcap := hcaps[i]
		handicaps += "" if i == 0 else ", " + "PLID %d (%d kg, %d %%)" % [hcap.plid, hcap.h_mass,
				hcap.h_tres]
	return "Players handicaps: %s" % [handicaps]


# FIXME: Never actually used
func remove_unused_data() -> void:
	size = PACKET_BASE_SIZE + PLH_DATA_SIZE * hcaps.size()
	resize_buffer(size)
