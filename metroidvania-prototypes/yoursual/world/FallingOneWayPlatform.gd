extends StaticBody2D

onready var collision_shape : CollisionShape2D = $CollisionShape2D
onready var audio : AudioStreamPlayer2D = $Audio
onready var reset_timer : Timer = $ResetTimer
onready var tween : Tween = $Tween
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
	if body is Player and body.global_position.y < global_position.y and not fallen:
		if delay != 0:
			timer.start()
			yield(timer, "timeout")
		fallen = true
		tween.interpolate_property(self,
			"global_position",
			global_position,
			global_position + Vector2.DOWN * fall_distance,
			0.5,
			Tween.TRANS_EXPO,
			Tween.EASE_IN)
		tween.start()
		audio.play()
		yield(tween, "tween_completed")
		collision_shape.disabled = true
		hide()
		reset_timer.start()


func _on_ResetTimer_timeout() -> void:
	global_position = initial_position
	collision_shape.disabled = false
	show()
