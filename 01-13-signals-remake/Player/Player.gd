extends KinematicBody2D
class_name Player

signal health_changed(new_value)

onready var sprite : Sprite = $Body
onready var animation_player : AnimationPlayer = $AnimationPlayer

export var health : = 50 setget _set_health
export var move_speed : = 500.0

func _physics_process(delta : float) -> void:
	var motion : = Vector2()
	
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if motion.x != 0:
		sprite.flip_h = motion.x > 0
	move_and_collide(motion.normalized() * move_speed * delta)


func take_damage(value : int) -> void:
	self.health -= value
	animation_player.play("damage")


func _set_health(new_value : int) -> void:
	health = max(0, new_value)
	emit_signal("health_changed", health)
