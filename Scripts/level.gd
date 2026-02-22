class_name Level
extends Node2D

@onready var left_wall: StaticBody2D = $LeftWall
@onready var right_wall: StaticBody2D = $RightWall
@onready var top_wall: StaticBody2D = $TopWall
@onready var bottom_wall: StaticBody2D = $BottomWall

@export var boundary: Rect2 = Rect2(0, 0, 1920, 1080):
	set(v):
		boundary = v
		if is_node_ready():
			_set_boundary()
			queue_redraw()

@export var player_scene: PackedScene
@export var ball_scene: PackedScene

var _player: Player

var _left_wall_pos: Vector2:
	get:
		return Vector2(boundary.position.x,
					   boundary.position.y + boundary.size.y / 2.0)

var _right_wall_pos: Vector2:
	get:
		return Vector2(boundary.position.x + boundary.size.x,
					   boundary.position.y + boundary.size.y / 2.0)

var _top_wall_pos: Vector2:
	get:
		return Vector2(boundary.position.x + boundary.size.x / 2.0,
					   boundary.position.y)

var _bot_wall_pos: Vector2:
	get:
		return Vector2(boundary.position.x + boundary.size.x / 2.0,
					   boundary.position.y + boundary.size.y)

func _ready() -> void:
	_set_boundary()
	_create_player()
	_create_ball()
	queue_redraw()


func _create_player() -> void:
	_player = player_scene.instantiate() as Player
	add_child(_player)
	var player_start_position := Vector2(
		boundary.position.x + boundary.size.x / 2.0,
		boundary.position.y + min(boundary.size.y * 0.95, boundary.size.y - 55.0)
	)
	_player.start(
		player_start_position,
		boundary.position.x,
		boundary.position.x + boundary.size.x
	)


func _create_ball() -> void:
	var ball := ball_scene.instantiate() as Ball
	ball.sleeping = true
	add_child(ball)
	ball.add_to_group("Balls")

	var ball_start_position := Vector2(
		boundary.position.x + boundary.size.x / 2.0,
		boundary.position.y + min(boundary.size.y * 0.95, boundary.size.y - 55.0) - 200.0
	)

	ball.start(ball_start_position, Vector2.DOWN, 600.0, 1.0)


func _set_boundary() -> void:
	left_wall.position = _left_wall_pos
	right_wall.position = _right_wall_pos
	top_wall.position = _top_wall_pos
	bottom_wall.position = _bot_wall_pos


func _stop() -> void:
	if is_instance_valid(_player):
		_player.stop()
	get_tree().call_group("Balls", "stop")
