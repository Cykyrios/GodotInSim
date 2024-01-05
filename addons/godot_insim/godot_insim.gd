@tool
extends EditorPlugin


const AUTOLOAD_INSIM := "GISInSim"
const AUTOLOAD_OUTSIM := "GISOutSim"
const AUTOLOAD_OUTGAUGE := "GISOutGauge"


func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_INSIM, "res://addons/godot_insim/src/insim/insim.gd")
	add_autoload_singleton(AUTOLOAD_OUTSIM, "res://addons/godot_insim/src/outsim/outsim.gd")
	add_autoload_singleton(AUTOLOAD_OUTGAUGE, "res://addons/godot_insim/src/outgauge/outgauge.gd")


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_INSIM)
	remove_autoload_singleton(AUTOLOAD_OUTSIM)
	remove_autoload_singleton(AUTOLOAD_OUTGAUGE)
