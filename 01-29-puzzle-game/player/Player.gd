extends KinematicBody2D

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

export var move_speed : = 250.0
export var push_speed : = 125.0


func _physics_process(delta: float) -> void:
	var motion : = Vector2()
	motion.x = int(Input.get_action_strength("move_right")) - int(Input.get_action_strength("move_left"))
	motion.y = int(Input.get_action_strength("move_down")) - int(Input.get_action_strength("move_up"))
	
	update_animation(motion)
	move_and_slide(motion.normalized() * move_speed, Vector2())
	if get_slide_count() > 0:
		check_box_collision(motion)


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


func check_box_collision(motion: Vector2) -> void:
	if abs(motion.x) + abs(motion.y) > 1:
		return
	var box : = get_slide_collision(0).collider as Box
	if box:
		box.push(push_speed * motion)
