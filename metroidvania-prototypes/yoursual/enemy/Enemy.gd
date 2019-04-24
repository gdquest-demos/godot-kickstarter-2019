extends KinematicBody2D
class_name Enemy

onready var audio : AudioStreamPlayer2D = $Audio
onready var hit_box : Area2D = $EnemyHitBox
onready var timer : Timer = $Timer

export var health := 50
export var move_speed := 750
export var gravity := 2000
export var acceleration := 2.5
export var patrolling_distance := 150.0
export var attack_rate := 1.0

var velocity := Vector2()
var initial_position := Vector2()
var target_position := Vector2()
var direction_x := 1


func _ready() -> void:
	randomize()
	hit_box.connect("body_entered", self, "_on_EnemyHitBox_body_entered")
	hit_box.connect("body_exited", self, "_on_EnemyHitBox_body_exited")
	timer.wait_time = 1.0 / attack_rate
	initial_position = global_position
	target_position = global_position + Vector2(patrolling_distance * sign(rand_range(-1, 1)), 0)


func _process(delta: float) -> void:
	if target_position.x > global_position.x and direction_x < 0:
		target_position = global_position + Vector2(patrolling_distance * 1, 0)
		direction_x = 1
	elif target_position.x < global_position.x and direction_x > 0:
		target_position = global_position + Vector2(patrolling_distance * -1, 0)
		direction_x = -1


func _physics_process(delta: float) -> void:
	var desired_x_velocity = direction_x * move_speed
	velocity.x = lerp(velocity.x, desired_x_velocity, acceleration * delta)

	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_EnemyHitBox_body_entered(body: PhysicsBody2D) -> void:
	#TODO: Damage player
	pass


func _on_EnemyHitBox_body_exited(body: PhysicsBody2D) -> void:
	pass


func damage(amount: int) -> void:
	GlobalEffects.freeze_frame()
	GlobalEvents.emit_signal("shake_requested")
	health = max(health - amount, 0)
	audio.play()
	if health == 0:
		yield(audio, "finished")
		queue_free()
