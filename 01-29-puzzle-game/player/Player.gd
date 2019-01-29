extends KinematicBody2D

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

export var move_speed : = 50.0


func _physics_process(delta: float) -> void:
	var motion : = Vector2()
	motion.x = int(Input.get_action_strength("move_right")) - int(Input.get_action_strength("move_left"))
	motion.y = int(Input.get_action_strength("move_down")) - int(Input.get_action_strength("move_up"))
	
	update_animation(motion)
	move_and_collide(motion.normalized() * move_speed * delta)


func update_animation(motion: Vector2) -> void:
	var animation : = "idle"
	
	if motion.x > 0:
		animation = "right"
	elif motion.x < 0:
		animation = "left"
	elif motion.y < 0:
		animation = "up"
	elif motion.y > 0:
		animation = "down"
	
	if animated_sprite.animation != animation:
		animated_sprite.play(animation)
