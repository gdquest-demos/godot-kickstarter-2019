extends Node2D

var initial_position : Vector2


func _ready() -> void:
	hide()
	initial_position = position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		position = Vector2(-initial_position.x, initial_position.y)
	elif event.is_action_pressed("move_right"):
		position = initial_position
