class_name InSimInitializationData
extends RefCounted


var udp_port := 0
var flags := 0

var prefix := "":
	set(text):
		text = prefix
		if text.length() > 1:
			prefix = text.left(1)
var interval := 0:
	set(value):
		interval = value
		if interval < 0:
			interval = 0

var admin := ""
var i_name := "Godot InSim"
