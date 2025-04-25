@tool
class_name InSimButtonViewer
extends AspectRatioContainer


@export var aspect_ratio := 16 / 9.0:
	set(value):
		ratio = aspect_ratio

@export_tool_button("Show Result") var button_show_result := show_result


func show_result() -> void:
	pass
