class_name Ball
extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var circle_draw: CircleDraw2D = $CircleDraw2D

@export var raduis: float = 10.0:
	set(v):
		raduis = max(v, 1.0)
		if is_node_ready():
			_apply_visuals()

@export var color: Color = Color.DEEP_SKY_BLUE:
	set(v):
		color = v
		if is_node_ready():
			_apply_visuals()

@export_range(10.0, 5000.0, 1.0)
var speed: float = 600.0:
	set(v):
		speed = clampf(v, 10.0, 5000.0)

@export_range(0.0, 1.0, 0.01)
var randomness: float = 0.05

var damage: int = 1
var can_move: bool = false


func _ready() -> void:
	_apply_visuals()
	start(Vector2.ONE * 500, Vector2.ONE)


func start(start_position: Vector2, direction: Vector2, start_speed: float = 600.0, delay_sec: float = 1.0) -> void:
	set_deferred("global_position", start_position)
	await get_tree().create_timer(delay_sec).timeout
	can_move = true
	speed = start_speed
	velocity = direction


func _physics_process(delta: float) -> void:
	if !can_move:
		return

	var collision := move_and_collide(velocity * delta)

	if collision:
		var normal := collision.get_normal()
		velocity = velocity.bounce(normal)

	velocity = velocity.normalized() * speed


func _apply_visuals() -> void:
	var shape := collision_shape.shape as CircleShape2D
	if shape != null:
		shape.radius = raduis
	if circle_draw != null:
		circle_draw.radius = raduis
		circle_draw.color = color


func die() -> void:
	queue_free()
	print("Ball died")


func stop():
	can_move = false
