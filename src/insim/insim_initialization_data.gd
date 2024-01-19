class_name InSimInitializationData
extends RefCounted


const PREFIX_LENGTH := 1

var udp_port := 0
var flags := 0

var prefix := "":
	set(text):
		text = prefix
		if text.length() > PREFIX_LENGTH:
			prefix = text.left(PREFIX_LENGTH)
var interval := 0:
	set(value):
		interval = value
		if interval < 0:
			interval = 0

var admin := ""
var i_name := "Godot InSim"
