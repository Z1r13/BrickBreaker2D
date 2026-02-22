extends Node

signal score_changed

@onready var _camera := $Camera2D as Camera2D
@onready var hud := $HUD as HUD
@onready var _screen_size := get_viewport().get_visible_rect().size

@export
var ball_scene: PackedScene
@export
var level_scene: PackedScene
@export
var brick_scene: PackedScene

var _score: int = 1000:
	set(v):
		_score = v
		emit_signal("score_changed")

var level: Level


func _ready() -> void:
	_camera.offset = _screen_size / 2

	score_changed.connect(on_score_changed)

	hud.show_start_game()
	hud.start_game.connect(new_game)
	hud.exit_application.connect(on_exit_application)


func new_game():
	level = level_scene.instantiate() as Level
	add_child(level)
	level.all_balls_died.connect(game_over)
	level.all_bricks_destroyed.connect(win)

	_score = 1000
	hud.update_score(_score)
	print("New Game")


func game_over():
	await get_tree().create_timer(1).timeout
	hud.show_game_over()
	level.queue_free()


func on_score_changed():
	hud.update_score(_score)


func on_exit_application():
	get_tree().quit(0)


func win():
	hud.show_win()
