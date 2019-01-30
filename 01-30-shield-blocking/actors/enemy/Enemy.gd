extends KinematicBody2D
class_name Enemy

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

export var move_speed : = 75.0
export var attack_distance : = 0

var player


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var direction = 1 if player.global_position.x > global_position.x else -1
	move_and_slide(move_speed * Vector2.RIGHT * direction, Vector2.UP)
	animated_sprite.flip_h = direction
	if attack_distance != 0 and global_position.distance_to(player.global_position) <= attack_distance:
		player.take_damage(global_position)


func _on_DetectionArea_player_found(_player: PhysicsBody2D) -> void:
	player = _player
	set_physics_process(true)
