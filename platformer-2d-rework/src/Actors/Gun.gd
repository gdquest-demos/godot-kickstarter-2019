extends Position2D
class_name Gun
"""
Represents a weapon that spawns and shoots bullets.
The Cooldown timer controls the cooldown duration between shots.
"""


onready var sound_shoot: AudioStreamPlayer2D = $Shoot
onready var timer: Timer = $Cooldown

const Bullet = preload("res://src/Objects/Bullet.tscn")
const BULLET_VELOCITY: = 1000.0


func shoot(direction: int = 1) -> bool:
	if not timer.is_stopped():
		return false
	var bullet: = Bullet.instance()
	bullet.global_position = global_position
	bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0)
	
	bullet.set_as_toplevel(true)
	add_child(bullet)
	sound_shoot.play()
	return true
