class_name Ball
extends RigidBody2D

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
	_physics_setup()
	_apply_visuals()
	start(Vector2.ONE * 600, Vector2.ONE) # DELETE THIS


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if !can_move:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		return

	for i in range(state.get_contact_count()):
		var collider := state.get_contact_collider_object(i)
		if collider is Player:
			state.linear_velocity += Vector2(collider._velocity.x * 0.5, 0.0)

	if state.linear_velocity.length() > 0.01:
		var dir := state.linear_velocity.normalized()
		if state.get_contact_count() > 0:
			dir += Vector2(
				randf_range(-randomness, randomness),
				randf_range(-randomness, randomness)
			)
		state.linear_velocity = dir.normalized() * speed


func start(new_position: Vector2, direction: Vector2, start_speed: float = 600.0, delay_sec: float = 1.0) -> void:
	can_move = false

	set_deferred("global_position", new_position)

	await get_tree().create_timer(delay_sec).timeout

	can_move = true
	sleeping = false

	linear_velocity = direction.normalized() * start_speed


func stop() -> void:
	can_move = false
	sleeping = true


func _physics_setup() -> void:
	gravity_scale = 0.0
	lock_rotation = true
	linear_damp = 0.0
	angular_damp = 0.0

	var mat := PhysicsMaterial.new()
	mat.bounce = 1.0
	mat.friction = 0.0
	physics_material_override = mat


func _apply_visuals() -> void:
	var shape := collision_shape.shape as CircleShape2D
	if shape != null:
		shape.radius = raduis
	if circle_draw != null:
		circle_draw.radius = raduis
		circle_draw.color = color
