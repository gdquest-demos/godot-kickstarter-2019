extends Node2D

onready var spawning_positions : Node2D = $SpawningPositions
onready var navigation : Navigation2D = $Navigation2D
onready var player : KinematicBody2D = $Tank
onready var timer : Timer = $Timer

export var enemy : PackedScene
export var max_spawn_time : = 8.0


func _ready() -> void:
	randomize()
	timer.wait_time = rand_range(max_spawn_time / 2, max_spawn_time)
	timer.start()


func spawn_enemy() -> void:
	var spawn_position : = spawning_positions.get_child(randi() % spawning_positions.get_child_count())
	var new_enemy : = enemy.instance()
	new_enemy.initialize(player)
	navigation.add_child(new_enemy)
	new_enemy.global_position = spawn_position.global_position
	timer.wait_time = rand_range(max_spawn_time / 2, max_spawn_time)
	timer.start()


func _on_Timer_timeout() -> void:
	spawn_enemy()
