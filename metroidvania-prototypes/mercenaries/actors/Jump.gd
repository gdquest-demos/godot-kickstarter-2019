extends "res://actors/KinematicPhysics.gd"

export (float) var strength := 300.0
export (int) var max_jumps := 1

var _available_jumps: int = 1

func _physics_process(delta: float) -> void:
	if kinematic_body2D.is_on_floor():
		_available_jumps = max_jumps

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		apply()

func apply() -> void:
	if _available_jumps > 0:
		kinematic_body2D.velocity.y = -strength
		_available_jumps -= 1
	_available_jumps = max(0, _available_jumps)