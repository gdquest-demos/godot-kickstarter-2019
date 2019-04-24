extends StaticBody2D

onready var collision_shape : CollisionShape2D = $CollisionShape2D
onready var reset_timer : Timer = $ResetTimer
onready var timer : Timer = $Timer

export var delay := 0.1
export var reset_time := 10.0
export var fall_distance := 1920

var fallen := false
var initial_position := Vector2()


func _ready() -> void:
	timer.wait_time = delay
	reset_timer.wait_time = reset_time
	initial_position = global_position


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body is Player and body.global_position.y < global_position.y:
		if delay != 0:
			timer.start()
			yield(timer, "timeout")
		fallen = true
		global_position.y += fall_distance
		reset_timer.start()


func _on_ResetTimer_timeout() -> void:
	global_position = initial_position
