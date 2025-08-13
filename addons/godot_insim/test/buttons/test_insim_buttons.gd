extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/buttons/insim_buttons.gd"

var insim: InSim = null


func before_test() -> void:
	insim = auto_free(InSim.new())
	add_child(insim)
	var connection := mock(LFSConnectionTCP) as LFSConnectionTCP
	insim.lfs_connection = connection
	insim.insim_connected = true


func test_add_solo_button() -> void:
	var packet := insim.button_manager.add_solo_button(
		1, Vector2i(10, 50), Vector2i(20, 5), InSim.ButtonStyle.ISB_DARK, "text", "button"
	)
	var _test: GdUnitAssert = assert_object(packet).is_equal(
		InSimBTNPacket.create(1, 0, 0, InSim.ButtonStyle.ISB_DARK, 0, 10, 50, 20, 5, "text")
	)
	_test = assert_array(insim.button_manager.buttons).has_size(1)
	var button := insim.button_manager.buttons[0]
	_test = assert_object(button).is_instanceof(InSimSoloButton)
	_test = assert_str(button.name).is_equal("button")


func test_add_multi_button() -> void:
	var packets := insim.button_manager.add_multi_button(
		[1, 2], Vector2i(10, 50), Vector2i(20, 5), InSim.ButtonStyle.ISB_DARK, "text", "button"
	)
	var _test: GdUnitAssert = assert_int(packets.size()).is_equal(2)
	_test = assert_array(packets).is_equal([
		InSimBTNPacket.create(1, 0, 0, InSim.ButtonStyle.ISB_DARK, 0, 10, 50, 20, 5, "text"),
		InSimBTNPacket.create(2, 0, 0, InSim.ButtonStyle.ISB_DARK, 0, 10, 50, 20, 5, "text"),
	])
	_test = assert_array(insim.button_manager.buttons).has_size(1)
	var button := insim.button_manager.buttons[0]
	_test = assert_object(button).is_instanceof(InSimMultiButton)
	_test = assert_str(button.name).is_equal("button")
	_test = assert_array((button as InSimMultiButton).ucid_mappings.keys()).is_equal([1, 2])


func test_add_multiple_buttons() -> void:
	insim.add_solo_button(0, Vector2i.ONE, Vector2i.ONE, 0, "")
	insim.add_multi_button([0, 1, 2], Vector2i.ONE, Vector2i.ONE, 0, "")
	var _test: GdUnitAssert = assert_array(insim.button_manager.buttons).has_size(2)
	_test = assert_dict(insim.button_manager.id_map).is_equal({
		0: [0, 1],
		1: [0],
		2: [0],
	})


func test_compact_bfn_packets() -> void:
	var packets: Array[InSimBFNPacket] = [
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 1, 10, 20),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 1, 21, 0),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 1, 22, 25),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 1, 27, 29),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 2, 10, 20),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 4, 5, 0),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 4, 21, 0),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 3, 21, 0),
	]
	var expected: Array[InSimBFNPacket] = [
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 1, 10, 25),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 1, 27, 29),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 2, 10, 20),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 3, 21, 0),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 4, 5, 0),
		InSimBFNPacket.create(InSim.ButtonFunction.BFN_DEL_BTN, 4, 21, 0),
	]
	var compacted := insim.button_manager._compact_bfn_packets(packets)
	var buffer_expected: Array[int] = []
	for packet in expected:
		packet.fill_buffer()
		buffer_expected.append_array(packet.buffer)
	var buffer_compacted: Array[int] = []
	for packet in compacted:
		packet.fill_buffer()
		buffer_compacted.append_array(packet.buffer)
	var _test := assert_array(buffer_compacted).is_equal(buffer_expected)


func test_delete_button() -> void:
	insim.add_solo_button(0, Vector2i.ONE, Vector2i.ONE, 0, "")
	insim.delete_button(insim.button_manager.buttons[0])
	var _test: GdUnitAssert = assert_array(insim.button_manager.buttons).is_empty()
	insim.add_multi_button([0, 1, 2], Vector2i.ONE, Vector2i.ONE, 0, "")
	var multi_button := insim.button_manager.buttons[0] as InSimMultiButton
	insim.delete_button(multi_button, [0, 1])
	_test = assert_array(insim.button_manager.buttons).has_size(1)
	_test = assert_dict(insim.button_manager.id_map).is_equal({2: [0]})


func test_delete_buttons() -> void:
	insim.add_solo_button(0, Vector2i.ONE, Vector2i.ONE, 0, "")
	var solo_button := insim.button_manager.buttons[-1] as InSimSoloButton
	insim.add_multi_button([0, 1, 2], Vector2i.ONE, Vector2i.ONE, 0, "")
	var multi_button := insim.button_manager.buttons[-1] as InSimMultiButton
	insim.delete_button(solo_button, [2])  # UCIDs should be ignored for InSimSoloButton.
	insim.delete_button(multi_button, [0, 1])
	var _test: GdUnitAssert = assert_array(insim.button_manager.buttons).has_size(1)
	_test = assert_dict(insim.button_manager.id_map).is_equal({2: [0]})



func test_get_button_by_id() -> void:
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "button")
	insim.add_multi_button([2, 3], Vector2i.ONE, Vector2i.ONE, 0, "", "test_button")
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "hello")
	insim.add_solo_button(1, Vector2i.ONE, Vector2i.ONE, 0, "", "another_button")
	var button := insim.get_button_by_id(1, 1)
	var _test: GdUnitAssert = assert_object(button).is_not_null()
	_test = assert_object(button).is_instanceof(InSimMultiButton)
	button = insim.get_button_by_id(1, 2)
	_test = assert_object(button).is_not_null()
	_test = assert_object(button).is_instanceof(InSimMultiButton)
	button = insim.get_button_by_id(2, 1)
	_test = assert_object(button).is_not_null()
	_test = assert_object(button).is_instanceof(InSimSoloButton)
	button = insim.get_button_by_id(2, 3)
	_test = assert_object(button).is_null()


func test_get_button_by_id_range() -> void:
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "button")
	insim.add_multi_button([2, 3], Vector2i.ONE, Vector2i.ONE, 0, "", "test_button")
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "hello")
	insim.add_solo_button(1, Vector2i.ONE, Vector2i.ONE, 0, "", "another_button")
	var buttons := insim.get_buttons_by_id_range(1, 2, [1])
	var _test: GdUnitAssert = assert_array(buttons).has_size(2)
	_test = assert_object(buttons[0]).is_not_null()
	_test = assert_object(buttons[0]).is_instanceof(InSimMultiButton)
	_test = assert_object(buttons[1]).is_not_null()
	_test = assert_object(buttons[1]).is_instanceof(InSimSoloButton)
	var multi_button := buttons[0] as InSimMultiButton
	_test = assert_int(multi_button.ucid_mappings[1].click_id).is_equal(1)
	buttons = insim.get_buttons_by_id_range(1, 2)
	_test = assert_array(buttons).has_size(3)  # 2 multi-buttons + 1 solo-button


func test_get_buttons_by_name() -> void:
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "button")
	insim.add_multi_button([2, 3], Vector2i.ONE, Vector2i.ONE, 0, "", "test_button")
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "hello")
	var button := insim.button_manager.get_button_by_name("button")
	var _test: GdUnitAssert = assert_object(button).is_not_null()
	_test = assert_object(button).is_instanceof(InSimMultiButton)


func test_get_buttons_by_prefix() -> void:
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "a/b")
	insim.add_multi_button([2, 3], Vector2i.ONE, Vector2i.ONE, 0, "", "c/d/e")
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "c/desktop")
	var buttons := insim.button_manager.get_buttons_by_prefix("c/d")
	var _test: GdUnitAssert = assert_array(buttons).has_size(2)
	_test = assert_object(buttons[0]).is_not_null()
	_test = assert_object(buttons[1]).is_not_null()
	_test = assert_str(buttons[0].name).is_equal("c/d/e")
	_test = assert_str(buttons[1].name).is_equal("c/desktop")


func test_get_buttons_by_regex() -> void:
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "a/b")
	insim.add_multi_button([2, 3], Vector2i.ONE, Vector2i.ONE, 0, "", "c/d/e")
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "no_category")
	var buttons := insim.button_manager.get_buttons_by_regex(RegEx.create_from_string(".+?/.+"))
	var _test: GdUnitAssert = assert_array(buttons).has_size(2)
	buttons = insim.button_manager.get_buttons_by_regex(RegEx.create_from_string(".+?_cat.*?"))
	_test = assert_array(buttons).has_size(1)


func test_update_solo_button() -> void:
	insim.add_solo_button(0, Vector2i.ONE, Vector2i.ONE, 0, "", "button 1")
	var solo_button := insim.button_manager.buttons[-1] as InSimSoloButton
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "button 2")
	var multi_button := insim.button_manager.buttons[-1] as InSimMultiButton
	insim.update_solo_button(solo_button, "test")
	insim.update_multi_button(multi_button, "update")
	var _test: GdUnitAssert = assert_str(solo_button.text).is_equal("test")
	_test = assert_str(multi_button.ucid_mappings[1].text).is_equal("update")


func test_update_multi_button_callable_text() -> void:
	insim.add_multi_button([1, 2], Vector2i.ONE, Vector2i.ONE, 0, "", "button 2")
	var button := insim.button_manager.buttons[-1] as InSimMultiButton
	var set_text_to_ucid := func(ucid: int) -> String:
		return str(ucid)
	insim.update_multi_button(button, set_text_to_ucid)
	for ucid in button.ucid_mappings:
		var mapping := button.ucid_mappings[ucid]
		var _test: GdUnitAssert = assert_str(mapping.text).is_equal(str(mapping.ucid))
