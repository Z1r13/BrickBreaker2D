class_name Player
extends StaticBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var capsule_draw: CapsuleDraw2D = $CapsuleDraw2D

@export
var length: float = 60.0:
	set(v):
		length = max(1.0, v)
		if is_node_ready():
			_apply_visuals()

@export
var thickness: float = 18.0:
	set(v):
		thickness = max(1.0, v)
		if is_node_ready():
			_apply_visuals()

@export
var color: Color = Color.SKY_BLUE:
	set(v):
		color = v
		if is_node_ready():
			_apply_visuals()

@export
var max_speed: float = 600.0:
	set(v):
		max_speed = max(v, 1.0)

@export_range(0.001, 1.0, 0.001)
var movement_smoothness: float = 0.08

var can_move: bool = false

var _speed = 0.0
var _input: float
var _velocity: Vector2 = Vector2.ZERO
var _left_x_border: float
var _right_x_border: float


func _ready() -> void:
	_apply_visuals()


func _physics_process(delta: float) -> void:
	_apply_velocity(delta)


func _process(delta: float) -> void:
	get_input()


func get_input() -> void:
	_input = 0
	if !can_move: return
	if Input.is_action_pressed("ui_right"):
		_input = 1
	if Input.is_action_pressed("ui_left"):
		_input = -1


func _apply_velocity(delta: float) -> void:
	_speed = lerpf(_speed, _input * max_speed, movement_smoothness)
	_velocity = Vector2.RIGHT * _speed

	position += _velocity * delta
	position.x = clampf(
		position.x,
	 	_left_x_border + (length * 0.5 + thickness),
		_right_x_border - (length * 0.5 + thickness))


func _apply_visuals() -> void:
	var shape := collision_shape.shape as CapsuleShape2D
	if shape != null:
		shape.height = length + thickness * 2
		shape.radius = thickness

	if capsule_draw != null:
		capsule_draw.length = length
		capsule_draw.thickness = thickness
		capsule_draw.color = color


func start(new_position: Vector2, left_x_border: float, right_x_border: float, delay_sec: float = 1) -> void:
	global_position = new_position
	collision_shape.disabled = false
	_left_x_border = left_x_border
	_right_x_border = right_x_border
	await get_tree().create_timer(delay_sec).timeout
	can_move = true


func stop() -> void:
	can_move = false
	collision_shape.disabled = true

#func change_length(length_diff: int) -> void:
	#var tween = create_tween()
	#tween.tween_property(self, "length", self.length + length_diff, 0.3)
