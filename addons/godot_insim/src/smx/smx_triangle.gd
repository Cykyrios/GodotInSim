class_name SMXTriangle
extends RefCounted

## SMX Triangle
##
## Triangle data included in an [SMXObject].

const STRUCT_SIZE := 8
var vertex_a := 0
var vertex_b := 0
var vertex_c := 0
var zero := 0


func _to_string() -> String:
	return "Vertex A: %d, Vertex B: %d, Vertex C: %d" % [vertex_a, vertex_b, vertex_c]
