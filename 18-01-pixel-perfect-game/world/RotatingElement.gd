extends Node2D

export var rotation_speed : = 15.0


func _process(delta : float) -> void:
	rotation += rotation_speed * delta
