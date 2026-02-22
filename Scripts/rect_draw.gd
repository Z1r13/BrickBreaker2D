class_name RectDraw2D
extends Node2D

@export
var size: Vector2i:
	set(v):
		size = v
		queue_redraw()

@export
var color: Color:
	set(v):
		color = v
		queue_redraw()


func _draw():
	draw_rect(
		Rect2(size.x * -0.5, size.y * -0.5, size.x, size.y),
		color,
		true
	)
