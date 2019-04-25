extends "res://src/Player/Behavior.gd"


export(int) var impulse := 30000
export(int) var max_jumps := 1

var _jumps := 0


func run(state: Physics2DDirectBodyState):
	if Input.is_action_just_pressed("jump") and can_jump():
		state.apply_central_impulse(impulse * Vector2.UP)
		_jumps += 1
	elif state.linear_velocity.y == 0:
		_jumps = 0


func can_jump() -> bool:
	return parent.is_on_floor() or _jumps < max_jumps