extends "res://src/Player/Behavior.gd"


const SPEED := {
	"floor": 400,
	"air": 200
}


func run(state: Physics2DDirectBodyState):
	var direction := U.get_direction("horizontal")
	if direction != Vector2.ZERO:
		state.linear_velocity.x = SPEED["floor" if parent.is_on_floor() else "air"] * direction.x