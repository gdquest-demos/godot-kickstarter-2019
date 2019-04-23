extends KinematicBody2D

export var move_speed : = 150.0
export var turn_speed : = 75.0

func _physics_process(delta: float) -> void:
	var motion : = Vector2()
	motion.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	motion.x = Input.get_action_strength("rotate_right") - Input.get_action_strength("rotate_left")
	
	rotation_degrees += motion.x * turn_speed * delta
	
	move_and_slide(Vector2.UP.rotated(rotation) * motion.y * move_speed)
	