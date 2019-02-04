extends KinematicBody2D

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

export var move_speed : = 175.0
export var knock_back_force : = Vector2(2500, -250)

var player : Player
var is_colliding_with_player : = false


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var direction = 1 if player.global_position.x > global_position.x else -1
	move_and_slide(move_speed * Vector2.RIGHT * direction, Vector2.UP)
	animated_sprite.flip_h = direction
	if is_colliding_with_player:
		player.take_damage(self, knock_back_force)


func _on_DetectionArea_player_found(_player: PhysicsBody2D) -> void:
	player = _player
	set_physics_process(true)


func _on_DamageBox_body_entered(body: PhysicsBody2D) -> void:
	if not body is Player:
		return
	is_colliding_with_player = true
	knock_back_force.x = abs(knock_back_force.x) * sign(body.global_position.x - global_position.x)
	body.take_damage(self, knock_back_force)


func _on_DamageBox_body_exited(body: PhysicsBody2D) -> void:
	if body is Player:
		is_colliding_with_player = false
