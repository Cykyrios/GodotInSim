class_name InSimIPBPacket
extends InSimPacket

## IP Bans - variable size

const IPB_MAX_BANS := 120
const IPB_DATA_SIZE := 4

const PACKET_BASE_SIZE := 8
const PACKET_MIN_SIZE := PACKET_BASE_SIZE
const PACKET_MAX_SIZE := PACKET_BASE_SIZE + IPB_DATA_SIZE * IPB_MAX_BANS
const PACKET_TYPE := InSim.Packet.ISP_IPB
var numb := 0  ## number of bans in this packet

var sp0 := 0
var sp1 := 0
var sp2 := 0
var sp3 := 0

var ban_ips: Array[IPAddress] = []  ## IP addresses, 0 to [constant IPB_MAX_BANS] ([member numb])


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
		push_error("%s packet expected size [%d..%d step %d], got %d." % [InSim.Packet.keys()[type],
				PACKET_MIN_SIZE, PACKET_MAX_SIZE, SIZE_MULTIPLIER, packet_size])
		return
	super(packet)
	numb = read_byte()
	sp0 = read_byte()
	sp1 = read_byte()
	sp2 = read_byte()
	sp3 = read_byte()
	ban_ips.clear()
	for i in numb:
		var ip_address := IPAddress.new()
		ip_address.fill_from_string("%d.%d.%d.%d" % [read_byte(), read_byte(),
				read_byte(), read_byte()])
		ban_ips.append(ip_address)


func _fill_buffer() -> void:
	super()
	update_req_i()
	numb = mini(numb, ban_ips.size())
	add_byte(numb)
	add_byte(sp0)
	add_byte(sp1)
	add_byte(sp2)
	add_byte(sp3)
	resize_buffer(PACKET_BASE_SIZE + numb * IPB_DATA_SIZE)
	for i in numb:
		add_byte(ban_ips[i].address_array[0])
		add_byte(ban_ips[i].address_array[1])
		add_byte(ban_ips[i].address_array[2])
		add_byte(ban_ips[i].address_array[3])


func _get_data_dictionary() -> Dictionary:
	return {
		"NumB": numb,
		"Sp0": sp0,
		"Sp1": sp1,
		"Sp2": sp2,
		"Sp3": sp3,
		"BanIPs": ban_ips,
	}


func remove_unused_data() -> void:
	size = PACKET_BASE_SIZE + IPB_DATA_SIZE * ban_ips.size()
	resize_buffer(size)
