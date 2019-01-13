extends KinematicBody2D
class_name Player

signal health_changed(value)

onready var sprite : = $Sprite
onready var animation_player : = $AnimationPlayer

export var move_speed : float = 5.0
export var health : int = 50 setget _set_health

func _physics_process(delta : float) -> void:
	var motion : = Vector2()
	
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if motion.x != 0:
		sprite.flip_h = motion.x > 0
	
	move_and_collide(motion.normalized() * move_speed * delta)

func _set_health(new_value : int) -> void:
	health = max(0, new_value)
	emit_signal("health_changed", health)

func take_damage(value : int) -> void:
	self.health -= value
	animation_player.play("damage")
