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
			InSim.InitFlag.ISF_MSO_COLS,
			""
		)
	)
	await insim.isp_ver_received
	await get_tree().create_timer(0.5).timeout
	show_manual_buttons()
	show_auto_buttons()


func show_auto_buttons() -> void:
	insim.buttons.id_range = Vector2i(50, 80)
	var buttons_left := 70
	var buttons_top := 40
	var button_width := 15
	var button_height := 5
	insim.add_button(
		[],
		Vector2i(buttons_left, buttons_top),
		Vector2i(2 * button_width, 9 * button_height),
		InSim.ButtonStyle.ISB_LIGHT,
	)
	insim.add_button(
		[],
		Vector2i(buttons_left, buttons_top),
		Vector2i(2 * button_width, roundi(1.5 * button_height)),
		InSim.ButtonColor.ISB_TITLE,
		"Auto Buttons"
	)
	insim.add_button(
		[],
		Vector2i(buttons_left, buttons_top + 2 * button_height),
		Vector2i(2 * button_width, button_height),
		0,
		"Custom clickID range: %d-%d" % [insim.buttons.id_range.x, insim.buttons.id_range.y],
	)
	insim.add_button(
		[255],
		Vector2i(buttons_left, buttons_top + 3 * button_height),
		Vector2i(2 * button_width, button_height),
		0,
		"test",
		"test",
	)
	var button := insim.get_button_by_name("test", 255)
	if button:
		button.text = "ID=%d, name=%s" % [button.click_id, button.name]
		insim.send_packet(button.get_btn_packet(true))
	insim.add_button(
		[],
		Vector2i(buttons_left + 2, buttons_top + 4 * button_height),
		Vector2i(2 * button_width - 4, button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		func(ucid: int) -> String: return insim.get_connection_nickname(ucid),
		"player_name",
	)
	insim.add_button(
		[],
		Vector2i(buttons_left + 2, buttons_top + 5 * button_height),
		Vector2i(2 * button_width - 4, button_height),
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK,
		"Time",
		"clock",
	)

	# Infinite loop to get updates every second, obviously not a good choice if you want
	# to be able to interrupt the loop cleanly.
	var loop := 0
	while true:
		await get_tree().create_timer(1).timeout
		button = insim.get_button_by_name("clock", 255)
		button.text = Time.get_time_string_from_system(true)
		insim.send_packet(button.get_btn_packet(true))
		loop += 1
		if loop % 2:
			insim.add_button(
				[],
				Vector2i(buttons_left + 2, buttons_top + 6 * button_height),
				Vector2i(2 * button_width - 4, button_height),
				0,
				"",
				"blink",
			)
			button = insim.get_button_by_name("blink", 255)
			if button:
				button.text = "ID=%d, name=%s" % [button.click_id, button.name]
				insim.send_packet(button.get_btn_packet(true))
		else:
			insim.delete_buttons_by_name("blink")


func show_manual_buttons() -> void:
	var buttons_left := 30
	var buttons_top := 40
	var button_width := 15
	var button_height := 5
	insim.send_packet(InSimBTNPacket.create(
		255, 0, 0,
		InSim.ButtonStyle.ISB_LIGHT,
		0,
		buttons_left, buttons_top,
		2 * button_width, 9 * button_height,
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 1, 0,
		InSim.ButtonColor.ISB_TITLE,
		0,
		buttons_left, buttons_top,
		2 * button_width, roundi(1.5 * button_height),
		"Manual Buttons"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 2, 0,
		InSim.ButtonColor.ISB_LIGHT_GRAY,
		0,
		buttons_left, buttons_top + 2 * button_height,
		button_width, button_height,
		"Default"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 3, 0,
		InSim.ButtonColor.ISB_TITLE,
		0,
		buttons_left + button_width, buttons_top + 2 * button_height,
		button_width, button_height,
		"Title"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 4, 0,
		InSim.ButtonColor.ISB_UNSELECTED,
		0,
		buttons_left, buttons_top + 3 * button_height,
		button_width, button_height,
		"Unselected"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 5, 0,
		InSim.ButtonColor.ISB_SELECTED,
		0,
		buttons_left + button_width, buttons_top + 3 * button_height,
		button_width, button_height,
		"Selected"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 6, 0,
		InSim.ButtonColor.ISB_OK,
		0,
		buttons_left, buttons_top + 4 * button_height,
		button_width, button_height,
		"OK"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 7, 0,
		InSim.ButtonColor.ISB_CANCEL,
		0,
		buttons_left + button_width, buttons_top + 4 * button_height,
		button_width, button_height,
		"Cancel"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 8, 0,
		InSim.ButtonColor.ISB_TEXT,
		0,
		buttons_left, buttons_top + 5 * button_height,
		button_width, button_height,
		"Text String"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 9, 0,
		InSim.ButtonColor.ISB_UNAVAILABLE,
		0,
		buttons_left + button_width, buttons_top + 5 * button_height,
		button_width, button_height,
		"Unavailable"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 10, 0,
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK | InSim.ButtonColor.ISB_OK,
		0,
		buttons_left + roundi(0.5 * button_width), buttons_top + roundi(6.5 * button_height),
		button_width, button_height,
		"Click"
	))
	insim.send_packet(InSimBTNPacket.create(
		255, 11, 0,
		InSim.ButtonStyle.ISB_DARK | InSim.ButtonStyle.ISB_CLICK | InSim.ButtonColor.ISB_TEXT,
		10,
		buttons_left + roundi(0.5 * button_width), buttons_top + roundi(7.5 * button_height),
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
	# Note that buttons created manually are not tracked in InSimButtons; you can either
	# add them manually (insim.buttons[ucid] = InSimButtonDictionary.new(), then
	# add a manually created InSimButton to it), or keep track of manual buttons yourself.
	# For click_id == 10 below, we check packet.click_id instead of button.click_id for
	# that reason.
	var button := insim.get_button_by_id(packet.click_id, packet.ucid)
	var flags := packet.click_flags
	var message := "You clicked %s (%s)." % [
		"the ^2Click^8 button in the Manual Buttons category" if packet.click_id == 10 \
				else "the player name button" if button and button.name == "player_name" \
				else "a button",
		"%s click%s%s" % [
			"right" if flags & InSim.ButtonClick.ISB_RMB else "left",
			" + Ctrl" if flags & InSim.ButtonClick.ISB_CTRL else "",
			" + Shift" if flags & InSim.ButtonClick.ISB_SHIFT else "",
		],
	]
	if insim.lfs_state.flags & InSim.State.ISS_MULTI:
		insim.send_message_to_connection(
			255,
			message.replace("You", insim.get_connection_nickname(packet.ucid) \
					+ LFSText.get_color_code(LFSText.ColorCode.DEFAULT)),
			InSim.MessageSound.SND_MESSAGE
		)
	else:
		insim.send_local_message(message, InSim.MessageSound.SND_MESSAGE)
	if button and button.name == "player_name":
		button.text = "ID=%d, name=%s" % [
			button.click_id,
			button.name,
		] if button.text == insim.get_connection_nickname(button.ucid) \
				else insim.get_connection_nickname(button.ucid)
		insim.send_packet(button.get_btn_packet(true))


func _on_btt_received(packet: InSimBTTPacket) -> void:
	var message := "You typed %s in %s." % [
		"\"%s\"" % [packet.text + LFSText.get_color_code(LFSText.ColorCode.DEFAULT)] \
				if not packet.text.is_empty() else "nothing",
		"the ^6Type^8 button in the Manual Button category" if packet.click_id == 11 \
				else "a button",
	]
	if insim.lfs_state.flags & InSim.State.ISS_MULTI:
		insim.send_message_to_connection(
			255,
			message.replace("You", insim.get_connection_nickname(packet.ucid) \
					+ LFSText.get_color_code(LFSText.ColorCode.DEFAULT)),
			InSim.MessageSound.SND_MESSAGE
		)
	else:
		insim.send_local_message(message, InSim.MessageSound.SND_MESSAGE)
