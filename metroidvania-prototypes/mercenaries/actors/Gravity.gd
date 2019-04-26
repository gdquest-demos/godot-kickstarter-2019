extends "res://actors/KinematicPhysics.gd"

export (float) var acceleration := 50.0
export (Vector2) var direction := Vector2(0, 1)

func _physics_process(delta: float) -> void:
	if kinematic_body2D.is_on_floor():
		kinematic_body2D.velocity.y = 0
		return
	kinematic_body2D.velocity += acceleration * direction
