extends Area2D

onready var collision_shape : CollisionShape2D = $CollisionShape2D

var active := false setget set_active


func _ready() -> void:
	collision_shape.disabled = not active


func set_active(value: bool) -> void:
	active = value
	collision_shape.disabled = not active
