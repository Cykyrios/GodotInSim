extends MarginContainer


const GRAVITY := 9.81  # Used for g forces

var outsim: OutSim = null
var outgauge: OutGauge = null

@onready var chart_throttle: DemoLineChart = %Throttle
@onready var chart_brake: DemoLineChart = %Brake
@onready var chart_steering: DemoLineChart = %Steering
@onready var chart_g_forces: DemoGForceChart = %GForces


func _ready() -> void:
	chart_throttle.line_color = Color.GREEN
	chart_throttle.draw_extra_data = true
	chart_brake.line_color = Color.RED
	chart_brake.draw_extra_data = true
	chart_steering.line_color = Color.BLUE
	chart_steering.y_range = Vector2(-PI / 4, PI / 4)
	chart_g_forces.line_color = Color.GOLDENROD

	outgauge = OutGauge.new()
	add_child(outgauge)
	var _connect := outgauge.packet_received.connect(_on_outgauge_packet_received)
	outgauge.initialize()
	outsim = OutSim.new()
	add_child(outsim)
	_connect = outsim.packet_received.connect(_on_outsim_packet_received)
	outsim.initialize(0x1ff)

	await get_tree().process_frame
	get_tree().root.borderless = true
	get_tree().root.always_on_top = true
	get_tree().root.size = get_tree().root.get_contents_minimum_size()


func _on_outgauge_packet_received(packet: OutGaugePacket) -> void:
	var throttle := packet.throttle * 100
	var brake := packet.brake * 100
	var lights := packet.get_lights_array(packet.show_lights)
	var dl_abs := lights[OutGaugePacket.DLFlags.DL_ABS]
	var dl_tc := lights[OutGaugePacket.DLFlags.DL_TC]
	chart_throttle.data.append(Vector3(0, throttle, dl_tc))
	chart_brake.data.append(Vector3(0, brake, dl_abs))


func _on_outsim_packet_received(packet: OutSimPacket) -> void:
	var data := packet.outsim_pack
	var steer := data.os_inputs.input_steer
	chart_steering.data.append(Vector3(0, steer, 0))
	var angles := data.os_main.gis_angles
	var acceleration := data.os_main.accel
	var basis := Basis.from_euler(angles, EULER_ORDER_ZXY)
	var g_forces := acceleration * basis / GRAVITY
	chart_g_forces.data.append(Vector3(-g_forces.x, -g_forces.y, 0))
