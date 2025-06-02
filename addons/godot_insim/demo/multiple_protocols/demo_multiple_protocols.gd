extends MarginContainer


var insim := InSim.new()
var outsim := OutSim.new()
var outgauge := OutGauge.new()

var car_lights_timer := Timer.new()
var car_switches_timer := Timer.new()

@onready var insim_button: Button = %InSimButton
@onready var car_lights_button: Button = %CarLightsButton
@onready var car_switches_button: Button = %CarSwitchesButton

@onready var outgauge_label: Label = %OutGaugeLabel
@onready var outsim_label_1: Label = %OutSimLabel1
@onready var outsim_label_2: Label = %OutSimLabel2


func _ready() -> void:
	var _discard := insim_button.pressed.connect(_on_insim_button_pressed)
	_discard = car_lights_button.pressed.connect(_on_car_lights_button_pressed)
	_discard = car_switches_button.pressed.connect(_on_car_switches_button_pressed)

	add_child(outgauge)
	outgauge.initialize()
	add_child(outsim)
	outsim.initialize(0x1ff)
	_discard = outgauge.packet_received.connect(update_outgauge)
	_discard = outsim.packet_received.connect(update_outsim)
	initialize_timers()

	add_child(insim)


func _exit_tree() -> void:
	if insim.insim_connected:
		insim.close()
	outgauge.close()
	outsim.close()


func initialize_timers() -> void:
	add_child(car_lights_timer)
	add_child(car_switches_timer)
	var _connect := car_lights_timer.timeout.connect(send_random_lights)
	_connect = car_switches_timer.timeout.connect(send_random_switches)


func _on_insim_button_pressed() -> void:
	if insim.insim_connected:
		insim.close()
		insim_button.text = "Initialize InSim"
	else:
		insim.initialize(
			"127.0.0.1",
			29_999,
			InSimInitializationData.create(
				"Multi-protocol",
				InSim.InitFlag.ISF_LOCAL,
			)
		)
		insim_button.text = "Close InSim"


func _on_car_lights_button_pressed() -> void:
	if car_lights_timer.is_stopped():
		car_lights_timer.start(0.1)
		car_lights_button.text = "Stop Car Lights"
		send_local_car_lights(CarLights.new())
	else:
		car_lights_timer.stop()
		send_local_car_lights(CarLights.create())
		car_lights_button.text = "Send Random Car Lights"


func _on_car_switches_button_pressed() -> void:
	if car_switches_timer.is_stopped():
		car_switches_timer.start(0.1)
		car_switches_button.text = "Stop Car Switches"
	else:
		car_switches_timer.stop()
		send_local_car_switches(CarSwitches.create())
		car_switches_button.text = "Send Random Car Switches"


func send_local_car_lights(lcl: CarLights) -> void:
	insim.send_packet(InSimSmallPacket.create(0, InSim.Small.SMALL_LCL, lcl.get_value()))


func send_local_car_switches(lcs: CarSwitches) -> void:
	insim.send_packet(InSimSmallPacket.create(0, InSim.Small.SMALL_LCS, lcs.get_value()))


func send_random_lights() -> void:
	var lcl := CarLights.new()
	lcl.set_signals = true
	lcl.set_lights = true
	lcl.set_fog_rear = true
	lcl.set_fog_front = true
	lcl.set_extra = true
	lcl.signals = randi() % 4
	lcl.lights = randi() % 4
	lcl.fog_rear = randi() % 2
	lcl.fog_front = randi() % 2
	lcl.extra = randi() % 2
	send_local_car_lights(lcl)


func send_random_switches() -> void:
	var lcs := CarSwitches.new()
	lcs.set_signals = false
	lcs.set_flash = true
	lcs.set_headlights = false
	lcs.set_horn = true
	lcs.set_siren = true
	lcs.signals = randi() % 4
	lcs.flash = randi() % 2
	lcs.headlights = randi() % 2
	lcs.horn = randi() % 6
	lcs.siren = randi() % 3
	send_local_car_switches(lcs)


func update_outgauge(outgauge_packet: OutGaugePacket) -> void:
	outgauge_label.text = "OutGauge:"
	outgauge_label.text += "\n%s: %s" % ["Time", outgauge_packet.time]
	outgauge_label.text += "\n%s: %s" % ["Car Name", outgauge_packet.car_name]
	outgauge_label.text += "\n%s: %s" % ["Flags", outgauge_packet.get_flags_array()]
	var gear := outgauge_packet.gear - 1
	outgauge_label.text += "\n%s: %s" % [
			"Gear",
			"R" if gear < 0 else "N" if gear == 0 else str(gear),
		]
	outgauge_label.text += "\n%s: %s" % ["Player ID", outgauge_packet.plid]
	outgauge_label.text += "\n%s: %.2f" % ["Speed", outgauge_packet.speed]
	outgauge_label.text += "\n%s: %.2f" % ["RPM", outgauge_packet.rpm]
	outgauge_label.text += "\n%s: %.2f" % ["Turbo", outgauge_packet.turbo]
	outgauge_label.text += "\n%s: %s" % ["Engine Temperature", outgauge_packet.engine_temp]
	outgauge_label.text += "\n%s: %s" % ["Fuel", outgauge_packet.fuel]
	outgauge_label.text += "\n%s: %s" % ["Oil Pressure", outgauge_packet.oil_pres]
	outgauge_label.text += "\n%s: %s" % ["Oil Temperature", outgauge_packet.oil_temp]
	outgauge_label.text += "\n%s:\n%s" % ["Available Lights",
			outgauge_packet.get_lights_array(outgauge_packet.dash_lights)]
	outgauge_label.text += "\n%s:\n%s" % ["Active Lights",
			outgauge_packet.get_lights_array(outgauge_packet.show_lights)]
	outgauge_label.text += "\n%s: %.2f" % ["Throttle", outgauge_packet.throttle]
	outgauge_label.text += "\n%s: %.2f" % ["Brake", outgauge_packet.brake]
	outgauge_label.text += "\n%s: %.2f" % ["Clutch", outgauge_packet.clutch]
	outgauge_label.text += "\n%s: %s" % ["Display 1", outgauge_packet.display1]
	outgauge_label.text += "\n%s: %s" % ["Display 2", outgauge_packet.display2]
	outgauge_label.text += "\n%s: %s" % ["ID", outgauge_packet.id]


func update_outsim(outsim_packet: OutSimPacket) -> void:
	outsim_label_1.text = "OutSim:"
	var os_options := outsim_packet.outsim_options
	if os_options & OutSim.OutSimOpts.OSO_HEADER:
		outsim_label_1.text += "\n%s" % [outsim_packet.header]
	if os_options & OutSim.OutSimOpts.OSO_ID:
		outsim_label_1.text += "\n%s: %d" % ["ID", outsim_packet.id]
	if os_options & OutSim.OutSimOpts.OSO_TIME:
		outsim_label_1.text += "\n%s: %d" % ["Time", outsim_packet.time]
	if os_options & OutSim.OutSimOpts.OSO_MAIN:
		var outsim_main := outsim_packet.os_main
		outsim_label_1.text += "\n%s: %.2v" % ["AngVel", outsim_main.ang_vel]
		outsim_label_1.text += "\n%s: %.2f, %s: %.2f, %s: %.2f" % [
			"Heading", outsim_main.heading,
			"Pitch", outsim_main.pitch,
			"Roll", outsim_main.roll,
		]
		outsim_label_1.text += "\n%s: %.2v" % ["Accel", outsim_main.accel]
		outsim_label_1.text += "\n%s: %.2v" % ["Vel", outsim_main.vel]
		outsim_label_1.text += "\n%s: %s" % ["Pos", outsim_main.pos]
	if os_options & OutSim.OutSimOpts.OSO_INPUTS:
		var outsim_inputs := outsim_packet.os_inputs
		outsim_label_1.text += "\n%s: %.2f\n%s: %.2f\n%s: %.2f\n%s: %.2f\n%s: %.2f" % \
				["Throttle", outsim_inputs.throttle, "Brake", outsim_inputs.brake,
				"InputSteer", outsim_inputs.input_steer, "Clutch", outsim_inputs.clutch,
				"Handbrake", outsim_inputs.handbrake]
	if os_options & OutSim.OutSimOpts.OSO_DRIVE:
		var gear := outsim_packet.gear - 1
		outsim_label_1.text += "\n%s: %s" % [
			"Gear",
			"R" if gear < 0 else "N" if gear == 0 else str(gear),
		]
		outsim_label_1.text += "\n%s: %.2f" % ["EngineAngVel", outsim_packet.engine_ang_vel]
		outsim_label_1.text += "\n%s: %.2f" % ["MaxTorqueAtVel", outsim_packet.max_torque_at_vel]
	if os_options & OutSim.OutSimOpts.OSO_DISTANCE:
		outsim_label_1.text += "\n%s: %.2f" % ["CurrentLapDistance", outsim_packet.current_lap_distance]
		outsim_label_1.text += "\n%s: %.2f" % ["IndexedDistance", outsim_packet.indexed_distance]
	if os_options & OutSim.OutSimOpts.OSO_WHEELS:
		var outsim_wheels := outsim_packet.os_wheels
		outsim_label_2.text = "{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"SuspDeflect",
			"%.2f" % outsim_wheels[0].susp_deflect, "%.2f" % outsim_wheels[1].susp_deflect,
			"%.2f" % outsim_wheels[2].susp_deflect, "%.2f" % outsim_wheels[3].susp_deflect,
		])
		outsim_label_2.text += "\n{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"Steer",
			"%.2f" % outsim_wheels[0].steer, "%.2f" % outsim_wheels[1].steer,
			"%.2f" % outsim_wheels[2].steer, "%.2f" % outsim_wheels[3].steer,
		])
		outsim_label_2.text += "\n{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"XForce",
			"%.2f" % outsim_wheels[0].x_force, "%.2f" % outsim_wheels[1].x_force,
			"%.2f" % outsim_wheels[2].x_force, "%.2f" % outsim_wheels[3].x_force,
		])
		outsim_label_2.text += "\n{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"YForce",
			"%.2f" % outsim_wheels[0].y_force, "%.2f" % outsim_wheels[1].y_force,
			"%.2f" % outsim_wheels[2].y_force, "%.2f" % outsim_wheels[3].y_force,
		])
		outsim_label_2.text += "\n{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"VerticalLoad",
			"%.2f" % outsim_wheels[0].vertical_load, "%.2f" % outsim_wheels[1].vertical_load,
			"%.2f" % outsim_wheels[2].vertical_load, "%.2f" % outsim_wheels[3].vertical_load,
		])
		outsim_label_2.text += "\n{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"AngVel",
			"%.2f" % outsim_wheels[0].ang_vel, "%.2f" % outsim_wheels[1].ang_vel,
			"%.2f" % outsim_wheels[2].ang_vel, "%.2f" % outsim_wheels[3].ang_vel,
		])
		outsim_label_2.text += "\n{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"LeanRelToRoad",
			"%.2f" % outsim_wheels[0].lean_rel_to_road, "%.2f" % outsim_wheels[1].lean_rel_to_road,
			"%.2f" % outsim_wheels[2].lean_rel_to_road, "%.2f" % outsim_wheels[3].lean_rel_to_road,
		])
		outsim_label_2.text += "\n{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"AirTemp",
			"%d" % outsim_wheels[0].air_temp, "%d" % outsim_wheels[1].air_temp,
			"%d" % outsim_wheels[2].air_temp, "%d" % outsim_wheels[3].air_temp,
		])
		outsim_label_2.text += "\n{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"SlipFraction",
			"%d" % outsim_wheels[0].slip_fraction, "%d" % outsim_wheels[1].slip_fraction,
			"%d" % outsim_wheels[2].slip_fraction, "%d" % outsim_wheels[3].slip_fraction,
		])
		outsim_label_2.text += "\n{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"Touching",
			"%d" % outsim_wheels[0].touching, "%d" % outsim_wheels[1].touching,
			"%d" % outsim_wheels[2].touching, "%d" % outsim_wheels[3].touching,
		])
		outsim_label_2.text += "\n{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"SlipRatio",
			"%.2f" % outsim_wheels[0].slip_ratio, "%.2f" % outsim_wheels[1].slip_ratio,
			"%.2f" % outsim_wheels[2].slip_ratio, "%.2f" % outsim_wheels[3].slip_ratio,
		])
		outsim_label_2.text += "\n{0} front: {3}/{4}\n{0} rear: {1}/{2}".format([
			"TanSlipAngle",
			"%.2f" % outsim_wheels[0].tan_slip_angle, "%.2f" % outsim_wheels[1].tan_slip_angle,
			"%.2f" % outsim_wheels[2].tan_slip_angle, "%.2f" % outsim_wheels[3].tan_slip_angle,
		])
	if os_options & OutSim.OutSimOpts.OSO_EXTRA_1:
		outsim_label_2.text += "\n%s: %.2f" % ["SteerTorque", outsim_packet.steer_torque]
