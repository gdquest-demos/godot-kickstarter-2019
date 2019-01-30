extends Node2D

onready var collision_shape : CollisionShape2D = $StaticBody2D/CollisionShape2D

var initial_position : Vector2


func _ready() -> void:
	initial_position = position
	disappear()


func appear(flipped_position: bool = false) -> void:
	"""
	Shows the shield at the correct position and enables collision
	"""
	collision_shape.disabled = false
	if flipped_position:
		position = Vector2(-initial_position.x, initial_position.y)
	show()


func disappear() -> void:
	"""
	Hides the shield, disables collision, and resets its position
	"""
	collision_shape.disabled = true
	hide()
	position = initial_position
