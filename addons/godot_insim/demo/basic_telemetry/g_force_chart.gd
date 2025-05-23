class_name DemoGForceChart
extends Control


var data: Array[Vector3] = []
var chart_size := Vector2(200, 200):
	set(value):
		chart_size = value
		custom_minimum_size = chart_size
var chart_scale := Vector2.ONE
var line_color := Color.WHITE
var line_thickness := 2.0
var marker_radius := 8.0
var x_range := Vector2(-2, 2)
var y_range := Vector2(-2, 2)
var fade_time := 2.0
var border := 4
var grid_color := Color(0.75, 0.75, 0.75)


func _ready() -> void:
	custom_minimum_size = chart_size
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER


func _process(delta: float) -> void:
	for i in data.size():
		data[i].z = data[i].z - delta
	while (
		data.size() > 500  # FIXME: Capping is good, but the following condition is not working.
		or (
			data.size() > 1
			and data[0].z >= data[1].z
			and absf(data[0].z) > fade_time
		)
	):
		data.pop_front()
	queue_redraw()


func _draw() -> void:
	if data.size() <= 2:
		return
	var radius_one_g := size[size.min_axis_index()] / 2 - border
	var radius_half_g := 0.5 * radius_one_g
	draw_line(Vector2(0, size.y / 2), Vector2(size.x, size.y / 2), grid_color)
	draw_line(Vector2(size.x / 2, 0), Vector2(size.x / 2, size.y), grid_color)
	draw_circle(size / 2, radius_one_g, grid_color, false, 2, true)
	draw_circle(size / 2, radius_half_g, Color(grid_color, 0.5), false, 2, true)
	var scaled_data: Array[Vector3] = data.duplicate()
	for i in data.size():
		var point := data[i]
		scaled_data[i] = Vector3(
			remap(point.x, x_range.x, x_range.y, border, size.x - border),
			remap(point.y, y_range.x, y_range.y, size.y - border, border),
			point.z
		)
	var marker_pos := Vector2(scaled_data[-1].x, scaled_data[-1].y)
	draw_circle(marker_pos, marker_radius, Color.WHITE, false, 2, true)
	var points := PackedVector2Array()
	var colors := PackedColorArray()
	var _resize := points.resize(scaled_data.size())
	_resize = colors.resize(scaled_data.size())
	for i in scaled_data.size():
		points[i] = Vector2(scaled_data[i].x, scaled_data[i].y)
		var color := line_color
		color.a = 1 - (absf(scaled_data[i].z) / fade_time)
		colors[i] = color
	draw_polyline_colors(points, colors, line_thickness, true)
