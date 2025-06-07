extends GdUnitTestSuite

# TestSuite generated from
const __source = "res://addons/godot_insim/src/buttons/insim_buttons.gd"


func test_compact_bfn_packets() -> void:
	var insim := mock(InSim, CALL_REAL_FUNC) as InSim
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
