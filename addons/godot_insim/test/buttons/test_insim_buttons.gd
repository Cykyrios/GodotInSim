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
