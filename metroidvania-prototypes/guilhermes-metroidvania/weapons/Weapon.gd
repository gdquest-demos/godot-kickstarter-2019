extends Node2D
class_name Weapon

onready var timer : Timer = $Timer

export var damage := 5
export var fire_rate := 2
export var action_name := "melee_attack"

var attack_direction := 1

func _ready() -> void:
	assert timer
	timer.wait_time = 1.0 / fire_rate
	timer.one_shot = true


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed(action_name) and timer.is_stopped():
		use_weapon()
	elif event.is_action_pressed("move_left"):
		attack_direction = -1
	elif event.is_action_pressed("move_right"):
		attack_direction = 1


func use_weapon() -> void:
	timer.start()
