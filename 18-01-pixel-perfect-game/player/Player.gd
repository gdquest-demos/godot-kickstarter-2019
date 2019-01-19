extends KinematicBody2D
class_name Player

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

export var move_speed : = 150.0
export var jump_force : = 200.0
export var acceleration : = 5.0
export var gravity : = 25.0

var movement_vector : = Vector2()


func _physics_process(delta : float) -> void:
	var motion : = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	movement_vector.x = lerp(movement_vector.x, motion.x * move_speed, acceleration * delta)
	
	if not is_on_floor():
		movement_vector.y += gravity
	elif Input.get_action_strength("jump") != 0:
		movement_vector.y = -jump_force
	
	_set_animation()
	move_and_slide(movement_vector, Vector2(0, -1))

func _set_animation() -> void:
	if abs(movement_vector.x) < 8:
		animation_player.play("idle")
	else:
		if animation_player.current_animation != "run":
			animation_player.play("run")
		sprite.flip_h = movement_vector.x < 0
