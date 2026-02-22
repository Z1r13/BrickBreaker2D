class_name HUD
extends CanvasLayer

signal start_game
signal exit_application

@onready var score_label := $Control/ScoreLabel as Label
@onready var message_label := $Control/MessageLabel as Label
@onready var start_button := $Control/StartButton as Button
@onready var exit_button := $Control/ExitButton as Button
@onready var message_timer := $Control/MessageTimer as Timer


func _ready() -> void:
	message_timer.timeout.connect(on_message_timer_timeout)
	start_button.pressed.connect(on_start_button_clicked)
	exit_button.pressed.connect(on_exit_bytton_clicked)


func set_message(message: String) -> void:
	message_label.text = message
	message_label.show()
	message_timer.start()


func show_win():
	set_message("Game Over\nYou Win!")
	await get_tree().create_timer(2).timeout
	show_start_game()


func show_game_over():
	set_message("Game Over\nYou Lose!")
	await get_tree().create_timer(2).timeout
	show_start_game()


func show_start_game():
	set_title()
	start_button.text = "Start Game"
	start_button.show()
	exit_button.show()


func update_score(score: int) -> void:
	score_label.text = str(score)


func on_start_button_clicked() -> void:
	start_button.hide()
	exit_button.hide()
	message_label.hide()
	emit_signal("start_game")


func on_exit_bytton_clicked() -> void:
	emit_signal("exit_application")


func on_message_timer_timeout() -> void:
	message_label.hide()


func set_title():
	message_label.text = "BrickBreaker2D"
	message_label.show()
