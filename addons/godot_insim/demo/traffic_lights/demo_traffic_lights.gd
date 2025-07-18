extends PanelContainer


signal first_line_crossed(plid: int, line: int)
signal second_line_crossed(plid: int, line: int)
signal approach_circle_entered(plid: int, circle: int)
signal driver_ran_red_light(plid: int)

enum LightColor {OFF, GREEN, AMBER, RED}
enum IntersectionState {X_GREEN, X_AMBER, X_RED, Y_GREEN, Y_AMBER, Y_RED}

const GREEN_DURATION := 15.0
const AMBER_DURATION := 4.0
const ALL_RED_DURATION := 2.0
const TIME_OFFSET := 5.0
const INTERSECTION_CENTER := Vector2(-534, 779)
const LAYOUT_PATH := "res://addons/godot_insim/demo/traffic_lights/WE1X_demo_lights.lyt"

@export var insim_ip := "127.0.0.1"
@export var insim_port := 29_999

var insim: InSim = null

var intersection_state := IntersectionState.X_GREEN
var lights: Array[LightColor] = [LightColor.OFF, LightColor.OFF, LightColor.OFF, LightColor.OFF]
var timer: Timer = null


func _ready() -> void:
	insim = InSim.new()
	add_child(insim)
	var _connect := insim.isp_uco_received.connect(_on_uco_received)

	_connect = first_line_crossed.connect(_on_first_line_crossed)
	_connect = second_line_crossed.connect(_on_second_line_crossed)
	_connect = approach_circle_entered.connect(_on_approach_circle_entered)

	insim.initialize(
		insim_ip,
		insim_port,
		InSimInitializationData.create(
			"Traffic LIghts",
			0,
		)
	)
	await get_tree().create_timer(0.5).timeout
	if not insim.lfs_state.track.begins_with("WE") or insim.lfs_state.track[-1] not in ["X", "Y"]:
		insim.send_local_message(
			"^1This demo is intended to run on Westhill open config (like ^2WE1X^1).",
			InSim.MessageSound.SND_ERROR
		)
		insim.send_local_message(
			"^1Please try again after loading the expected track.",
			InSim.MessageSound.SND_ERROR
		)
		get_tree().quit()
	await get_tree().create_timer(0.5).timeout
	insim.send_packet(InSimAXMPacket.create(0, 0, InSim.PMOAction.PMO_CLEAR_ALL))
	var layout := LYTFile.load_from_file(LAYOUT_PATH)
	var axm_packets := layout.get_axm_packets()
	for packet in axm_packets:
		# Forces the object optimisation flag, as it is required to be able to control lights
		packet.pmo_flags = (
			(packet.pmo_flags & ~InSim.PMOFlags.PMO_FILE_END) | InSim.PMOFlags.PMO_FILE_END
		)
		insim.send_packet(packet)

	timer = Timer.new()
	add_child(timer)
	_connect = timer.timeout.connect(_on_timer_timeout)
	set_lights([10, 11, 12, 13], LightColor.RED)
	await get_tree().create_timer(3).timeout
	intersection_state = IntersectionState.Y_RED
	_on_timer_timeout()


func send_system_message(message: String, sound: InSim.MessageSound) -> void:
		if insim.lfs_state.flags & InSim.State.ISS_MULTI:
			insim.send_message_to_connection(255, message, sound)
		else:
			insim.send_local_message(message, sound)


func set_lights(light_groups: Array[int], light_state: LightColor) -> void:
	for group in light_groups:
		lights[group - 10] = light_state
		insim.send_packet(InSimOCOPacket.create(
			InSim.OCOAction.OCO_LIGHTS_SET,
			InSim.AXOIndex.AXO_START_LIGHTS,
			group,
			0 if light_state == LightColor.OFF
			else 1 if light_state == LightColor.RED
			else 2 if light_state == LightColor.AMBER
			else 8
		))


func _on_approach_circle_entered(plid: int, circle: int) -> void:
	if lights[circle - 10] == LightColor.RED and timer.time_left > TIME_OFFSET:
		timer.start(timer.time_left - TIME_OFFSET)
		send_system_message(
			LFSText.replace_plid_with_name("PLID %d shortened red light" % [plid], insim),
			InSim.MessageSound.SND_SYSMESSAGE
		)
	elif lights[circle - 10] == LightColor.GREEN:
		timer.start(timer.time_left + TIME_OFFSET)
		send_system_message(
			LFSText.replace_plid_with_name("PLID %d lengthened green light" % [plid], insim),
			InSim.MessageSound.SND_SYSMESSAGE
		)


func _on_first_line_crossed(plid: int, id: int) -> void:
	if lights[id - 10] == LightColor.RED:
		var message := LFSText.replace_plid_with_name(
			"PLID %d may have run a light!" % [plid], insim
		)
		send_system_message(message, InSim.MessageSound.SND_ERROR)


func _on_second_line_crossed(plid: int, id: int) -> void:
	if lights[id - 10] == LightColor.RED:
		var message := LFSText.replace_plid_with_name(
			"PLID %d ran a red light!" % [plid], insim
		)
		send_system_message(message, InSim.MessageSound.SND_ERROR)
		driver_ran_red_light.emit(plid)  # Not used, should be connected to from another script


func _on_timer_timeout() -> void:
	intersection_state = wrapi(
		intersection_state + 1, 0, IntersectionState.size()
	) as IntersectionState
	match intersection_state:
		IntersectionState.X_GREEN:
			set_lights([11, 13], LightColor.GREEN)
			timer.start(GREEN_DURATION)
		IntersectionState.X_AMBER:
			set_lights([11, 13], LightColor.AMBER)
			timer.start(AMBER_DURATION)
		IntersectionState.X_RED:
			set_lights([11, 13], LightColor.RED)
			timer.start(ALL_RED_DURATION)
		IntersectionState.Y_GREEN:
			set_lights([10, 12], LightColor.GREEN)
			timer.start(GREEN_DURATION)
		IntersectionState.Y_AMBER:
			set_lights([10, 12], LightColor.AMBER)
			timer.start(AMBER_DURATION)
		IntersectionState.Y_RED:
			set_lights([10, 12], LightColor.RED)
			timer.start(ALL_RED_DURATION)


func _on_uco_received(packet: InSimUCOPacket) -> void:
	if (
		packet.info.index == InSim.AXOIndex.AXO_IS_CP
		and packet.uco_action == InSim.UCOAction.UCO_CP_FWD
	):
		var line_number := packet.info.flags & 0x03
		var line_id := 0
		var object_pos := packet.info.gis_position
		if object_pos.x < INTERSECTION_CENTER.x:
			if object_pos.y < INTERSECTION_CENTER.y:
				line_id = 10
			else:
				line_id = 13
		else:
			if object_pos.y < INTERSECTION_CENTER.y:
				line_id = 11
			else:
				line_id = 12
		if line_number == 1:
			first_line_crossed.emit(packet.plid, line_id)
		elif line_number == 2:
			second_line_crossed.emit(packet.plid, line_id)
	elif (
		packet.info.index == InSim.AXOIndex.AXO_IS_AREA
		and packet.uco_action == InSim.UCOAction.UCO_CIRCLE_ENTER
	):
		approach_circle_entered.emit(packet.plid, packet.info.heading)
