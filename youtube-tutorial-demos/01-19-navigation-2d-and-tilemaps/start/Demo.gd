extends Node

onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D
onready var character : Sprite = $Character


func _unhandled_input(event: InputEvent) -> void:
	pass
