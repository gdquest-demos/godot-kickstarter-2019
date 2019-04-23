extends KinematicBody2D
class_name Player

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite

export var move_speed : = 150.0
export var jump_force : = 200.0
export var gravity : = 25.0

var velocity : = Vector2()


func _physics_process(delta : float) -> void:
	var direction : = Vector2()
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = move_speed * direction.x

	if not is_on_floor():
		velocity.y += gravity
	elif Input.get_action_strength("jump") != 0:
		velocity.y = -jump_force
	
	move_and_slide(velocity, Vector2(0, -1))
	update_animation()


func update_animation() -> void:
	if abs(velocity.x) < 8 and animation_player.current_animation == "run":
		animation_player.play("idle")
	else:
		sprite.flip_h = velocity.x < 0
		if animation_player.current_animation != "run":
			animation_player.play("run")
