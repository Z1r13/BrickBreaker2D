class_name DeathZone
extends Area2D

@onready var shape: RectangleShape2D = $CollisionShape2D.shape

@export
var color: Color = Color.AQUA
var _boundaries: Rect2


func _ready() -> void:
	queue_redraw()


func set_boundaries(rect: Rect2):
	_boundaries = rect
	position = Vector2(
		rect.position.x + rect.size.x / 2,
		rect.position.y + rect.size.y - 25)
	shape.size = Vector2(
		rect.size.x,
		25.0)
	rotation = 0.0
	queue_redraw()


func _draw() -> void:
	var draw_pos = Vector2(
		-_boundaries.size.x / 2,
		 0)
	var draw_size = Vector2(
		_boundaries.size.x,
		25.0)

	draw_rect(Rect2(draw_pos, draw_size), color)
