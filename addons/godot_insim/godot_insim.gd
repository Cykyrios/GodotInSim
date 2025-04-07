@tool
extends EditorPlugin


func _enable_plugin() -> void:
	add_autoload_singleton("GISViewer", "res://addons/godot_insim/src/utils/gis_viewer.gd")


func _disable_plugin() -> void:
	remove_autoload_singleton("GISViewer")


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
