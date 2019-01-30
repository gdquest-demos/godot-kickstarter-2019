extends KinematicBody2D
class_name Player

onready var invencible_timer : Timer = $InvencibleTimer
onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var shield : Node2D = $Shield

export var move_speed : = 150.0
export var jump_force : = 200.0
export var gravity : = 25.0

var velocity : = Vector2()
var blocking : = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("defend"):
		shield.appear(not animated_sprite.flip_h)
		blocking = true
		move_speed *= 0.5
	elif Input.is_action_just_released("defend"):
		shield.disappear()
		blocking = false
		move_speed *= 2


func _physics_process(delta: float) -> void:
	var direction : = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = move_speed * direction

	if not is_on_floor():
		velocity.y += gravity
	elif Input.get_action_strength("jump") != 0:
		velocity.y = -jump_force
	
	move_and_slide(velocity, Vector2.UP)
	update_animation()


func _on_HitBox_body_entered(body: PhysicsBody2D) -> void:
	if body is Enemy:
		take_damage(body.global_position)


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


func take_damage(hit_origin: Vector2) -> void:
	"""
	Checks if the player can take damage and plays correct animations
	"""
	if not invencible_timer.is_stopped():
		return
	
	if blocking:
		if global_position.x > hit_origin.x and shield.global_position.x < global_position.x:
			return
		if global_position.x < hit_origin.x and shield.global_position.x > global_position.x:
			return
	
	invencible_timer.start()
	animation_player.play("hit")
