class_name CapsuleDraw2D
extends Node2D

var length: float = 80.0:
	set(v):
		length = max(v, thickness)
		queue_redraw()

var thickness: float = 16.0:
	set(v):
		thickness = max(v, 1.0)
		queue_redraw()

var color = Color(0.25, 0.85, 1, 1):
	set(v):
		color = v
		queue_redraw()


func _draw() -> void:
	draw_rect(
		Rect2(-length * 0.5, -thickness, length, thickness * 2),
		color,
		true
	)
	draw_circle(Vector2(-length * 0.5, 0.0), thickness, color)
	draw_circle(Vector2(length * 0.5, 0.0), thickness, color)
