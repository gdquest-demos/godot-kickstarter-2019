extends KinematicBody2D
class_name Player

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var shield : Node2D = $Shield

export var move_speed : = 300.0
export var blocking_speed : = 150.0
export var jump_force : = 500.0
export var gravity : = 30.0

var velocity : = Vector2()
var blocking : = false
var current_speed : = move_speed


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("defend"):
		blocking = true
		shield.visible = true
		current_speed = blocking_speed
	elif event.is_action_released("defend"):
		blocking = false
		shield.visible = false
		current_speed = move_speed


func _physics_process(delta: float) -> void:
	var direction : = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = current_speed * direction

	if not is_on_floor():
		velocity.y += gravity
	elif Input.get_action_strength("jump") != 0:
		velocity.y = -jump_force
	
	move_and_slide(velocity, Vector2.UP)
	update_animation()


func update_animation() -> void:
	"""
	Plays the correct animation based on the player's state
	"""
	var animation : = "idle"
	if not is_on_floor():
		animation = "jump"
	elif abs(velocity.x) < 8:
		animation = "idle"
	elif abs(velocity.x) > 8:
		animation = "walk"
	
	if animated_sprite.animation != animation:
		animated_sprite.play(animation)
	if abs(velocity.x) > 8:
		animated_sprite.flip_h = velocity.x < 0


func take_damage(attacker: Node2D) -> bool:
	"""
	Checks if the player can take damage and plays correct animations
	"""
	if blocking and is_shield_facing(attacker.global_position):
		return false
	
	animation_player.play("hit")
	return true


func is_shield_facing(hit_position: Vector2) -> bool:
	var shield_direction : = sign(shield.global_position.x - global_position.x)
	var hit_direction : = sign(global_position.x - hit_position.x)
	return shield_direction != hit_direction
