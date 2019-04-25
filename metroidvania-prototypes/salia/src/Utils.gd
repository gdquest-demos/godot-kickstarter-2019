extends Node


static func get_direction(set: String = "all", event: InputEvent = null) -> Vector2:
	var out := Vector2.ZERO
	if event == null:
		out = Vector2(
				Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
				0 if set == "horizontal" else (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")))
	else:
		out = Vector2(
				event.get_action_strength("move_right") - event.get_action_strength("move_left"),
				0 if set == "horizontal" else (event.get_action_strength("move_down") - event.get_action_strength("move_up")))
	return out.normalized()