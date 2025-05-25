class_name SMXTriangle
extends RefCounted
## SMX Triangle
##
## Triangle data included in an [SMXObject].

## The size of the included data.
const STRUCT_SIZE := 8

## The first vertex index for this triangle.
var vertex_a := 0
## The second vertex index for this triangle.
var vertex_b := 0
## The third vertex index for this triangle.
var vertex_c := 0
## Spare byte.
var zero := 0


func _to_string() -> String:
	return "Vertex A: %d, Vertex B: %d, Vertex C: %d" % [vertex_a, vertex_b, vertex_c]
