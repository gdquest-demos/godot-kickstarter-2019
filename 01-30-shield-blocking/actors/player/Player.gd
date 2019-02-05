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
var blocking : = false setget set_blocking
var current_speed : = move_speed


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("defend"):
		self.blocking = true
	elif event.is_action_released("defend"):
		self.blocking = false


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


func take_damage(attacker: Node2D, knock_back_force: Vector2 = Vector2()) -> void:
	"""
	Checks if the player can take damage and plays correct animations
	"""
	if blocking and is_shield_facing(attacker.global_position):
		return
	knock_back(knock_back_force)
	animation_player.play("hit")


func knock_back(force: Vector2) -> void:
	move_and_slide(force, Vector2.UP)
	velocity.y = force.y


func is_shield_facing(hit_position: Vector2) -> bool:
	var shield_direction : = sign(shield.global_position.x - global_position.x)
	var hit_direction : = sign(global_position.x - hit_position.x)
	return shield_direction != hit_direction


func set_blocking(value: bool) -> void:
	blocking = value
	shield.visible = value
	current_speed = blocking_speed if value else move_speed
