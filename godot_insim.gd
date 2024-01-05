extends MarginContainer


@onready var outgauge_label := %OutGaugeLabel
@onready var outsim_label := %OutSimLabel


func _ready() -> void:
	var initialization_data := InSimInitializationData.new()
	GISInSim.initialize(initialization_data)
	GISOutGauge.initialize()
	GISOutSim.initialize(0x1ff)
	var _discard := GISOutGauge.packet_received.connect(update_outgauge)
	_discard = GISOutSim.packet_received.connect(update_outsim)
	var timer := Timer.new()
	add_child(timer)
	_discard = timer.timeout.connect(send_random_lights)
	_discard = timer.timeout.connect(send_random_switches)
	timer.start(0.1)


func _exit_tree() -> void:
	GISInSim.close()
	GISOutGauge.close()
	GISOutSim.close()


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
	GISInSim.send_local_car_lights(lcl)


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
	GISInSim.send_local_car_switches(lcs)


func update_outgauge(outgauge_packet: OutGaugePacket) -> void:
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


func update_outsim(outsim_packet: OutSimPacket) -> void:
	outsim_label.text = ""
	if outsim_packet is OutSimPacketSimple:
		var outsim_pack := (outsim_packet as OutSimPacketSimple).outsim_pack
		outsim_label.text += "%s: %s\n" % ["Time", outsim_pack.time]
		outsim_label.text += "%s: %s\n" % ["Angular Velocity", outsim_pack.ang_vel]
		outsim_label.text += "%s: %s\n" % ["Heading", outsim_pack.heading]
		outsim_label.text += "%s: %s\n" % ["Pitch", outsim_pack.pitch]
		outsim_label.text += "%s: %s\n" % ["Roll", outsim_pack.roll]
		outsim_label.text += "%s: %s\n" % ["Acceleration", outsim_pack.accel]
		outsim_label.text += "%s: %s\n" % ["Velocity", outsim_pack.vel]
		outsim_label.text += "%s: %s\n" % ["Position", outsim_pack.pos]
		outsim_label.text += "%s: %s\n" % ["ID", outsim_pack.id]
	elif outsim_packet is OutSimPacketDetailed:
		var pack := (outsim_packet as OutSimPacketDetailed).outsim_pack
		var os_options := (outsim_packet as OutSimPacketDetailed).outsim_pack.os_options
		if os_options & OutSim.OutSimOpts.OSO_HEADER:
			outsim_label.text += "%s: %s\n" % ["L", pack.header_l]
			outsim_label.text += "%s: %s\n" % ["F", pack.header_f]
			outsim_label.text += "%s: %s\n" % ["S", pack.header_s]
			outsim_label.text += "%s: %s\n" % ["T", pack.header_t]
		if os_options & OutSim.OutSimOpts.OSO_ID:
			outsim_label.text += "%s: %s\n" % ["ID", pack.id]
		if os_options & OutSim.OutSimOpts.OSO_TIME:
			outsim_label.text += "%s: %s\n" % ["Time", pack.time]
		if os_options & OutSim.OutSimOpts.OSO_MAIN:
			var outsim_main := pack.os_main
			outsim_label.text += "%s: %s\n" % ["AngVel", outsim_main.ang_vel]
			outsim_label.text += "%s: %s\n" % ["Heading", outsim_main.heading]
			outsim_label.text += "%s: %s\n" % ["Pitch", outsim_main.pitch]
			outsim_label.text += "%s: %s\n" % ["Roll", outsim_main.roll]
			outsim_label.text += "%s: %s\n" % ["Accel", outsim_main.accel]
			outsim_label.text += "%s: %s\n" % ["Vel", outsim_main.vel]
			outsim_label.text += "%s: %s\n" % ["Pos", outsim_main.pos]
		if os_options & OutSim.OutSimOpts.OSO_INPUTS:
			var outsim_inputs := pack.os_inputs
			outsim_label.text += "%s: %s\n" % ["Throttle", outsim_inputs.throttle]
			outsim_label.text += "%s: %s\n" % ["Brake", outsim_inputs.brake]
			outsim_label.text += "%s: %s\n" % ["InputSteer", outsim_inputs.input_steer]
			outsim_label.text += "%s: %s\n" % ["Clutch", outsim_inputs.clutch]
			outsim_label.text += "%s: %s\n" % ["Handbrake", outsim_inputs.handbrake]
		if os_options & OutSim.OutSimOpts.OSO_DRIVE:
			outsim_label.text += "%s: %s\n" % ["Gear", pack.gear]
			outsim_label.text += "%s: %s\n" % ["Sp1", pack.sp1]
			outsim_label.text += "%s: %s\n" % ["Sp2", pack.sp2]
			outsim_label.text += "%s: %s\n" % ["Sp3", pack.sp3]
			outsim_label.text += "%s: %s\n" % ["EngineAngVel", pack.engine_ang_vel]
			outsim_label.text += "%s: %s\n" % ["MaxTorqueAtVel", pack.max_torque_at_vel]
		if os_options & OutSim.OutSimOpts.OSO_DISTANCE:
			outsim_label.text += "%s: %s\n" % ["CurrentLapDistance", pack.current_lap_distance]
			outsim_label.text += "%s: %s\n" % ["IndexedDistance", pack.indexed_distance]
		if os_options & OutSim.OutSimOpts.OSO_WHEELS:
			var outsim_wheels := pack.os_wheels
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["SuspDeflect", outsim_wheels[0].susp_deflect, outsim_wheels[1].susp_deflect, outsim_wheels[2].susp_deflect, outsim_wheels[3].susp_deflect]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["Steer", outsim_wheels[0].steer, outsim_wheels[1].steer, outsim_wheels[2].steer, outsim_wheels[3].steer]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["XForce", outsim_wheels[0].x_force, outsim_wheels[1].x_force, outsim_wheels[2].x_force, outsim_wheels[3].x_force]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["YForce", outsim_wheels[0].y_force, outsim_wheels[1].y_force, outsim_wheels[2].y_force, outsim_wheels[3].y_force]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["VerticalLoad", outsim_wheels[0].vertical_load, outsim_wheels[1].vertical_load, outsim_wheels[2].vertical_load, outsim_wheels[3].vertical_load]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["AngVel", outsim_wheels[0].ang_vel, outsim_wheels[1].ang_vel, outsim_wheels[2].ang_vel, outsim_wheels[3].ang_vel]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["LeanRelToRoad", outsim_wheels[0].lean_rel_to_road, outsim_wheels[1].lean_rel_to_road, outsim_wheels[2].lean_rel_to_road, outsim_wheels[3].lean_rel_to_road]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["AirTemp", outsim_wheels[0].air_temp, outsim_wheels[1].air_temp, outsim_wheels[2].air_temp, outsim_wheels[3].air_temp]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["SlipFraction", outsim_wheels[0].slip_fraction, outsim_wheels[1].slip_fraction, outsim_wheels[2].slip_fraction, outsim_wheels[3].slip_fraction]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["Touching", outsim_wheels[0].touching, outsim_wheels[1].touching, outsim_wheels[2].touching, outsim_wheels[3].touching]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["Sp3", outsim_wheels[0].sp3, outsim_wheels[1].sp3, outsim_wheels[2].sp3, outsim_wheels[3].sp3]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["SlipRatio", outsim_wheels[0].slip_ratio, outsim_wheels[1].slip_ratio, outsim_wheels[2].slip_ratio, outsim_wheels[3].slip_ratio]
			outsim_label.text += "%s: %s/%s/%s/%s\n" % ["TanSlipAngle", outsim_wheels[0].tan_slip_angle, outsim_wheels[1].tan_slip_angle, outsim_wheels[2].tan_slip_angle, outsim_wheels[3].tan_slip_angle]
		if os_options & OutSim.OutSimOpts.OSO_EXTRA_1:
			outsim_label.text += "%s: %s\n" % ["SteerTorque", pack.steer_torque]
			outsim_label.text += "%s: %s\n" % ["Spare", pack.spare]
