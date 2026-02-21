class_name CircleDraw2D
extends Node2D


var radius: float = 10.0:
	set(v):
		radius = max(v, 1.0)
		queue_redraw()


var color: Color = Color.WHITE:
	set(v):
		color = v
		queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)
