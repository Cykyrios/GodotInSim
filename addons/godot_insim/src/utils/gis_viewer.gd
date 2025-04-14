extends Node

## GIS Viewer
##
## An autoload providing utility functions related to 2D and 3D display of [InSim] and LFS entities.
## For instance, you can generate top-down images of a track configuration's [PTHFile].

## Saves a top-down image of the PTH mesh as returned by [method get_pth_mesh] to a transparent
## PNG file. The final image is a square [param size] pixels wide, representing a 4096x4096 meter
## area; the default [param size] of 2048 therefore corresponds to 2 meters per pixel.[br]
## The optional items [param include_line], [param include_road] and [param include_limits] allow
## customizing the resulting image.[br]
## [u]Note:[/u] The image size must be in the range 64-16384.
func save_pth_to_png(
	pth_file: PTHFile, image_path: String, size := 2048, include_line := true,
	include_road := true, include_limits := true, line_width := 1.0, line_color := Color.RED,
	road_color := Color.WHITE, limits_color := Color.DIM_GRAY
) -> void:
	const VIEWPORT_SCALE := 4096.0
	const VIEWPORT_MIN_SIZE := 512
	size = clampi(size, 64, 16384)
	var viewport_size := maxi(size, VIEWPORT_MIN_SIZE)
	var viewport := SubViewport.new()
	viewport.size = Vector2i.ONE * viewport_size
	viewport.disable_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.msaa_2d = Viewport.MSAA_8X
	viewport.transparent_bg = true
	add_child(viewport)
	var world_environment := WorldEnvironment.new()
	viewport.add_child(world_environment)
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color.BLACK
	world_environment.environment = environment
	var camera := Camera2D.new()
	viewport.add_child(camera)
	camera.zoom = Vector2.ONE * viewport_size / VIEWPORT_SCALE
	var mesh := pth_file.get_2d_mesh()
	pth_file.update_2d_mesh(mesh, line_width * VIEWPORT_SCALE / viewport_size, line_color, road_color, limits_color)
	if not include_line:
		mesh.get_child(2).queue_free()
	if not include_road:
		mesh.get_child(1).queue_free()
	if not include_limits:
		mesh.get_child(0).queue_free()
	viewport.add_child(mesh)
	await RenderingServer.frame_post_draw
	var image := viewport.get_texture().get_image()
	if size < VIEWPORT_MIN_SIZE:
		image.resize(size, size, Image.INTERPOLATE_LANCZOS)
	var error := image.save_png(image_path)
	if error != OK:
		push_warning("Failed to save image: error %d" % [error])
	viewport.queue_free()
