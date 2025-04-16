class_name DemoLineChart
extends Control


var data: Array[Vector3] = []
var chart_size := Vector2(300, 50):
	set(value):
		chart_size = value
		custom_minimum_size = chart_size
var line_color := Color.WHITE
var line_thickness := 2.0
var x_range := Vector2(-5, 0)
var y_range := Vector2(0, 100)
var border := 4  # chart border margin
var draw_extra_data := false
var extra_color := Color.GRAY


func _ready() -> void:
	custom_minimum_size = chart_size
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER


func _process(delta: float) -> void:
	for i in data.size():
		data[i].x = data[i].x - delta
	while (
		data.size() > 1
		and (
			data[0].x > data[1].x
			or absf(data[0].x - data[-1].x) > absf(x_range.x - x_range.y)
		)
	):
		data.pop_front()
	queue_redraw()


func _draw() -> void:
	if data.size() <= 1:
		return
	var scaled_data := PackedVector2Array()
	var _resize := scaled_data.resize(data.size())
	for i in data.size():
		var point := data[i]
		scaled_data[i] = Vector2(
			remap(point.x, x_range.x, x_range.y, border, size.x - border),
			remap(point.y, y_range.x, y_range.y, size.y - border, border)
		)
	if draw_extra_data:
		var extra_data := PackedVector2Array([Vector2(scaled_data[0].x, size.y)])
		_resize = extra_data.resize(data.size() + 2)
		for i in data.size():
			extra_data[i + 1] = Vector2(
				scaled_data[i].x,
				scaled_data[i].y if data[i].z != 0 else size.y - border
			)
		extra_data[extra_data.size() - 1] = Vector2(
			scaled_data[scaled_data.size() - 1].x, size.y
		)
		extra_color = Color(line_color, 0.5)
		draw_colored_polygon(extra_data, extra_color)
	draw_polyline(scaled_data, line_color, line_thickness, true)
