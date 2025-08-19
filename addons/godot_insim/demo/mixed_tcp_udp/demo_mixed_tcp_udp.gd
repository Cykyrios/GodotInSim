extends Control

var insim: InSim = null

var tcp_packets: Array[String] = []

@onready var label_tcp: Label = %LabelTCP
@onready var label_udp: Label = %LabelUDP


func _ready() -> void:
	insim = InSim.new()
	add_child(insim)
	var _connect := insim.packet_received.connect(_on_packet_received)
	_connect = insim.udp_mci_received.connect(_on_udp_mci_received)

	insim.initialize(
		"127.0.0.1",
		29_999,
		InSimInitializationData.create(
			"Mixed TCP UDP",
			InSim.InitFlag.ISF_LOCAL | InSim.InitFlag.ISF_MCI,
			"",
			"",
			10,
			30_000,
		)
	)


func _on_packet_received(packet: InSimPacket) -> void:
	tcp_packets.append(packet.get_pretty_text())
	while tcp_packets.size() > 20:
		tcp_packets.pop_front()
	label_tcp.text = ""
	for packet_string in tcp_packets:
		label_tcp.text += packet_string + "\n"


func _on_udp_mci_received(packet: InSimMCIPacket) -> void:
	label_udp.text = ""
	for info in packet.info:
		var info_string := "PLID %d: P%d (lap %d node %d), speed %.1f km/h, pos %.1v" % [
			info.plid,
			info.position,
			info.lap,
			info.node,
			GISUnit.convert_speed(
				info.gis_speed, GISUnit.Speed.METER_PER_SECOND, GISUnit.Speed.KPH
			),
			info.gis_position,
		]
		label_udp.text += info_string + "\n"
