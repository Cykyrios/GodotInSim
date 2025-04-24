extends Control


var insim: InSim = null


func _ready() -> void:
	insim = InSim.new()
	add_child(insim)
	var _connect := insim.isp_bfn_received.connect(_on_bfn_received)
	_connect = insim.isp_btc_received.connect(_on_btc_received)
	_connect = insim.isp_btt_received.connect(_on_btt_received)
	insim.initialize(
		"127.0.0.1",
		29_999,
		InSimInitializationData.create(
			"InSim Buttons",
			"",
			InSim.InitFlag.ISF_LOCAL,
			""
		)
	)
	await insim.isp_ver_received
	show_manual_buttons()


func show_manual_buttons() -> void:
	var buttons_left := 30
	var buttons_top := 40
	var button_width := 15
	var button_height := 5
	insim.send_packet(InSimBTNPacket.create(
		0, 0, 0,
		InSim.ButtonStyle.ISB_LIGHT,
		0,
		buttons_left, buttons_top,
		2 * button_width, 9 * button_height,
	))
	insim.send_packet(InSimBTNPacket.create(
		0, 1, 0,
		InSim.ButtonColor.ISB_TITLE,
		0,
		buttons_left, buttons_top,
		2 * button_width, 1.5 * button_height,
		"Manual Buttons"
	))
	insim.send_packet(InSimBTNPacket.create(
		0, 2, 0,
		InSim.ButtonColor.ISB_LIGHT_GRAY,
		0,
		buttons_left, buttons_top + 2 * button_height,
		button_width, button_height,
		"Default"
	))
	insim.send_packet(InSimBTNPacket.create(
		0, 3, 0,
		InSim.ButtonColor.ISB_TITLE,
		0,
		buttons_left + button_width, buttons_top + 2 * button_height,
		button_width, button_height,
		"Title"
	))
	insim.send_packet(InSimBTNPacket.create(
		0, 4, 0,
		InSim.ButtonColor.ISB_UNSELECTED,
		0,
		buttons_left, buttons_top + 3 * button_height,
		button_width, button_height,
		"Unselected"
	))
	insim.send_packet(InSimBTNPacket.create(
		0, 5, 0,
		InSim.ButtonColor.ISB_SELECTED,
		0,
		buttons_left + button_width, buttons_top + 3 * button_height,
		button_width, button_height,
		"Selected"
	))
	insim.send_packet(InSimBTNPacket.create(
		0, 6, 0,
		InSim.ButtonColor.ISB_OK,
		0,
		buttons_left, buttons_top + 4 * button_height,
		button_width, button_height,
		"OK"
	))
	insim.send_packet(InSimBTNPacket.create(
		0, 7, 0,
		InSim.ButtonColor.ISB_CANCEL,
		0,
		buttons_left + button_width, buttons_top + 4 * button_height,
		button_width, button_height,
		"Cancel"
	))
	insim.send_packet(InSimBTNPacket.create(
		0, 8, 0,
		InSim.ButtonColor.ISB_TEXT,
		0,
		buttons_left, buttons_top + 5 * button_height,
		button_width, button_height,
		"Text String"
	))
	insim.send_packet(InSimBTNPacket.create(
		0, 9, 0,
		InSim.ButtonColor.ISB_UNAVAILABLE,
		0,
		buttons_left + button_width, buttons_top + 5 * button_height,
		button_width, button_height,
		"Unavailable"
	))
	insim.send_packet(InSimBTNPacket.create(
		0, 10, 0,
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		0,
		buttons_left + 0.5 * button_width, buttons_top + 6.5 * button_height,
		button_width, button_height,
		"Click"
	))
	insim.send_packet(InSimBTNPacket.create(
		0, 11, 0,
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		10,
		buttons_left + 0.5 * button_width, buttons_top + 7.5 * button_height,
		button_width, button_height,
		"Type",
		"You can type up to 10 characters"
	))


func _on_bfn_received(packet: InSimBFNPacket) -> void:
	if packet.subtype == InSim.ButtonFunction.BFN_USER_CLEAR:
		insim.send_local_message("You cleared the InSim buttons.")
	elif packet.subtype == InSim.ButtonFunction.BFN_REQUEST:
		insim.send_local_message("You requested InSim buttons.")
		show_manual_buttons()


func _on_btc_received(packet: InSimBTCPacket) -> void:
	if packet.click_id == 10:
		insim.send_local_message("You clicked the Click button in the Manual Buttons category.")


func _on_btt_received(packet: InSimBTTPacket) -> void:
	if packet.click_id == 11:
		insim.send_local_message(
			"You typed \"%s\" in the Type button in the Manual Button category." % [
				packet.text + LFSText.get_color_code(LFSText.ColorCode.DEFAULT),
			]
		)
