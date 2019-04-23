extends Node2D

onready var head: = $Head
onready var tail: = $Tail

var target_length: = 40.0 setget set_target_length

func set_target_length(value: float) -> void:
	target_length = value
	tail.points[-1].x = target_length
	head.position.x = tail.points[-1].x
