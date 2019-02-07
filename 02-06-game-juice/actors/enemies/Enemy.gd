extends KinematicBody2D
class_name Enemy

export var health : = 40
export var move_speed : = 75

var path : = []
var player : Node2D


func _physics_process(delta: float) -> void:
	path = get_parent().get_simple_path(global_position, player.global_position)
	var direction = (path[1] - global_position).normalized()
	look_at(path[1])
	move_and_slide(direction * move_speed)


func initialize(_player: Node2D) -> void:
	player = _player


func damage(value: int) -> void:
	health = max(0, health - value)
	if health == 0:
		queue_free()
