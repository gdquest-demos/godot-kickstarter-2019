extends KinematicBody2D
class_name Enemy

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

export var move_speed : = 175.0
export var knock_back_force : = Vector2(2500, -250)

var player


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var direction = 1 if player.global_position.x > global_position.x else -1
	move_and_slide(move_speed * Vector2.RIGHT * direction, Vector2.UP)
	animated_sprite.flip_h = direction


func _on_DetectionArea_player_found(_player: PhysicsBody2D) -> void:
	player = _player
	set_physics_process(true)


func _on_DamageBox_body_entered(body: PhysicsBody2D) -> void:
	if not body is Player:
		return
	if body.take_damage(self):
		knock_back(body)


func knock_back(target: KinematicBody2D) -> void:
	var force = knock_back_force
	force.x *= sign(target.global_position.x - global_position.x)
	target.move_and_slide(force, Vector2.UP)
	target.velocity.y = knock_back_force.y
