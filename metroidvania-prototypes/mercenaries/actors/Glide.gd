extends "res://actors/KinematicPhysics.gd"

export (float) var fall_threshold := 50.0

var falling_speed := 0.0

func _physics_process(delta: float) -> void:
	var is_falling: bool = kinematic_body2D.velocity.y > fall_threshold
	if not is_falling:
		return
	if Input.is_action_just_pressed("glide"):
			falling_speed = kinematic_body2D.velocity.y
	if Input.is_action_pressed("glide"):
		kinematic_body2D.velocity.y = falling_speed
