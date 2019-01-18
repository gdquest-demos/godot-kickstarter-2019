extends Node2D

export var rotate_speed : = 15.0


func _process(delta : float) -> void:
	rotation += rotate_speed * delta
