class_name Brick
extends StaticBody2D

signal die

@onready var rectangle_shape: RectangleShape2D = $CollisionShape2D.shape
@onready var sensor_rectangle_shape: RectangleShape2D = $Area2D/CollisionShape2D.shape
@onready var rect_draw: RectDraw2D = $RectDraw2D

@export
var size: Vector2:
	set(v):
		size = v
		if is_node_ready():
			_apply_visuals()

@export
var color: Color = Color.AZURE:
	set(v):
		color = v
		if is_node_ready():
			_apply_visuals()

@export
var health: int = 1


func _ready() -> void:
	_apply_visuals()
	die.connect(on_brick_die)


func _apply_visuals() -> void:
	if rectangle_shape != null:
		rectangle_shape.size = size

	if rect_draw != null:
		rect_draw.size = size
		rect_draw.color = color

	if sensor_rectangle_shape != null:
		sensor_rectangle_shape.size = size


func on_collision_shape_body_entered(body: Node2D) -> void:
	if body is Ball:
		health -= body.damage
		if health <= 0:
			emit_signal("die")


func on_brick_die():
	queue_free()
