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


func test_add_button() -> void:
	var packets := insim.buttons.add_button(
		[1, 2], Vector2i(10, 50), Vector2i(20, 5), InSim.ButtonStyle.ISB_DARK, "text", "button"
	)
	var _test: GdUnitAssert = assert_int(packets.size()).is_equal(2)
	_test = assert_array(packets).is_equal([
		InSimBTNPacket.create(1, 0, 0, InSim.ButtonStyle.ISB_DARK, 0, 10, 50, 20, 5, "text"),
		InSimBTNPacket.create(2, 0, 0, InSim.ButtonStyle.ISB_DARK, 0, 10, 50, 20, 5, "text"),
	])
	_test = assert_bool(
		insim.get_button_by_name("button", 1) != null
		and insim.get_button_by_name("button", 2) != null
	).is_true()


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
	var compacted := insim.buttons._compact_bfn_packets(packets)
	var buffer_expected: Array[int] = []
	for packet in expected:
		packet.fill_buffer()
		buffer_expected.append_array(packet.buffer)
	var buffer_compacted: Array[int] = []
	for packet in compacted:
		packet.fill_buffer()
		buffer_compacted.append_array(packet.buffer)
	var _test := assert_array(buffer_compacted).is_equal(buffer_expected)


func test_delete_buttons_by_id() -> void:
	insim.add_button([1, 2], Vector2i.ZERO, Vector2i.ZERO, 0, "", "button")
	insim.add_button([2, 3], Vector2i.ZERO, Vector2i.ZERO, 0, "", "test_button")
	insim.add_button([1, 2], Vector2i.ZERO, Vector2i.ZERO, 0, "", "hello")
	var packets := insim.buttons.delete_buttons_by_id([1, 2], 1, 2)
	var _test: GdUnitAssert = assert_int(packets.size()).is_equal(2)
	# NOTE: UCID 1 only has buttons 0 and 1, but only the click_id is checked for existence, so
	# the expected result is still click_id == 1 and max_id == 2.
	_test = assert_array([
		packets[0].ucid, packets[0].click_id, packets[0].click_max,
		packets[1].ucid, packets[1].click_id, packets[1].click_max,
	]).is_equal([1, 1, 2, 2, 1, 2])


func test_delete_buttons_by_name() -> void:
	insim.add_button([1, 2], Vector2i.ZERO, Vector2i.ZERO, 0, "", "button")
	insim.add_button([2, 3], Vector2i.ZERO, Vector2i.ZERO, 0, "", "test_button")
	insim.add_button([1, 2], Vector2i.ZERO, Vector2i.ZERO, 0, "", "hello")
	var packets := insim.buttons.delete_buttons_by_prefix([1, 2], "button")
	var _test: GdUnitAssert = assert_int(packets.size()).is_equal(2)
	_test = assert_array([
		packets[0].ucid, packets[0].click_id, packets[0].click_max,
		packets[1].ucid, packets[1].click_id, packets[1].click_max,
	]).is_equal([1, 0, 0, 2, 0, 0])


func test_delete_buttons_by_prefix() -> void:
	insim.add_button([1, 2], Vector2i.ZERO, Vector2i.ZERO, 0, "", "a/b")
	insim.add_button([2, 3], Vector2i.ZERO, Vector2i.ZERO, 0, "", "c/d/e")
	insim.add_button([1, 2], Vector2i.ZERO, Vector2i.ZERO, 0, "", "c/desktop")
	var packets := insim.buttons.delete_buttons_by_prefix([1, 2], "c/d")
	var _test: GdUnitAssert = assert_int(packets.size()).is_equal(2)
	_test = assert_array([
		packets[0].ucid, packets[0].click_id, packets[0].click_max,
		packets[1].ucid, packets[1].click_id, packets[1].click_max,
	]).is_equal([1, 1, 0, 2, 1, 2])


func test_delete_buttons_by_regex() -> void:
	insim.add_button([1, 2], Vector2i.ZERO, Vector2i.ZERO, 0, "", "a/b")
	insim.add_button([2, 3], Vector2i.ZERO, Vector2i.ZERO, 0, "", "c/d/e")
	insim.add_button([1, 2], Vector2i.ZERO, Vector2i.ZERO, 0, "", "no_category")
	var packets := insim.buttons.delete_buttons_by_regex([1, 2], RegEx.create_from_string(".+?/.+"))
	var _test: GdUnitAssert = assert_int(packets.size()).is_equal(2)
	_test = assert_array([
		packets[0].ucid, packets[0].click_id, packets[0].click_max,
		packets[1].ucid, packets[1].click_id, packets[1].click_max,
	]).is_equal([1, 0, 0, 2, 0, 1])
	packets = insim.buttons.delete_buttons_by_regex([1, 2], RegEx.create_from_string(".+?_cat.*?"))
	_test = assert_int(packets.size()).is_equal(2)
	_test = assert_array([
		packets[0].ucid, packets[0].click_id, packets[0].click_max,
		packets[1].ucid, packets[1].click_id, packets[1].click_max,
	]).is_equal([1, 1, 0, 2, 2, 0])
