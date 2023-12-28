extends MarginContainer


@export var address := "127.0.0.1"
@export var insim_port := 29_999
@export var outgauge_port := 29_998
@export var outsim_port := 29_997

var insim: InSim = null
var outgauge_socket: PacketPeerUDP = null
var outsim_socket: PacketPeerUDP = null

@onready var outgauge_label := %OutGaugeLabel
@onready var outsim_label := %OutSimLabel


func _ready() -> void:
	insim = InSim.new()
	insim.initialize()
	initialize_outgauge_socket()
	initialize_outsim_socket()
	#insim.start_sending_gauges()
	#await get_tree().create_timer(10).timeout
	#insim.close()


func _process(_delta: float) -> void:
	update_outgauge()
	update_outsim()


func initialize_outgauge_socket() -> void:
	outgauge_socket = PacketPeerUDP.new()
	var error := outgauge_socket.bind(outgauge_port, address)
	if error != OK:
		push_error(error)


func initialize_outsim_socket() -> void:
	outsim_socket = PacketPeerUDP.new()
	var error := outsim_socket.bind(outsim_port, address)
	if error != OK:
		push_error(error)


func update_outgauge() -> void:
	var packet := outgauge_socket.get_packet()
	if packet.is_empty():
		return
	var outgauge_packet := OutGaugePacket.new(packet)

	outgauge_label.text = ""
	outgauge_label.text += "%s: %s\n" % ["Time", outgauge_packet.time]
	outgauge_label.text += "%s: %s\n" % ["Car Name", outgauge_packet.car_name]
	outgauge_label.text += "%s: %s\n" % ["Flags", outgauge_packet.get_flags_array()]
	outgauge_label.text += "%s: %s\n" % ["Gear", outgauge_packet.gear]
	outgauge_label.text += "%s: %s\n" % ["Player ID", outgauge_packet.player_id]
	outgauge_label.text += "%s: %s\n" % ["Speed", outgauge_packet.speed]
	outgauge_label.text += "%s: %s\n" % ["RPM", outgauge_packet.rpm]
	outgauge_label.text += "%s: %s\n" % ["Turbo", outgauge_packet.turbo]
	outgauge_label.text += "%s: %s\n" % ["Engine Temperature", outgauge_packet.engine_temp]
	outgauge_label.text += "%s: %s\n" % ["Fuel", outgauge_packet.fuel]
	outgauge_label.text += "%s: %s\n" % ["Oil Pressure", outgauge_packet.oil_pres]
	outgauge_label.text += "%s: %s\n" % ["Oil Temperature", outgauge_packet.oil_temp]
	outgauge_label.text += "%s: %s\n" % ["Available Lights",
			outgauge_packet.get_lights_array(outgauge_packet.dash_lights)]
	outgauge_label.text += "%s: %s\n" % ["Active Lights",
			outgauge_packet.get_lights_array(outgauge_packet.show_lights)]
	outgauge_label.text += "%s: %s\n" % ["Throttle", outgauge_packet.throttle]
	outgauge_label.text += "%s: %s\n" % ["Brake", outgauge_packet.brake]
	outgauge_label.text += "%s: %s\n" % ["Clutch", outgauge_packet.clutch]
	outgauge_label.text += "%s: %s\n" % ["Display 1", outgauge_packet.display1]
	outgauge_label.text += "%s: %s\n" % ["Display 2", outgauge_packet.display2]
	outgauge_label.text += "%s: %s\n" % ["ID", outgauge_packet.id]


func update_outsim() -> void:
	var packet := outsim_socket.get_packet()
	if packet.is_empty():
		return
	var outsim_packet := OutSimPacket.new(packet)

	outsim_label.text = ""
	outsim_label.text += "%s: %s\n" % ["Time", outsim_packet.time]
	outsim_label.text += "%s: %s\n" % ["Angular Velocity", outsim_packet.ang_vel]
	outsim_label.text += "%s: %s\n" % ["Heading", outsim_packet.heading]
	outsim_label.text += "%s: %s\n" % ["Pitch", outsim_packet.pitch]
	outsim_label.text += "%s: %s\n" % ["Roll", outsim_packet.roll]
	outsim_label.text += "%s: %s\n" % ["Acceleration", outsim_packet.accel]
	outsim_label.text += "%s: %s\n" % ["Velocity", outsim_packet.vel]
	outsim_label.text += "%s: %s\n" % ["Position", outsim_packet.pos]
	outsim_label.text += "%s: %s\n" % ["ID", outsim_packet.id]
