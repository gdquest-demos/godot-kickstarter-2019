extends Camera2D

func _unhandled_input(event: InputEvent) -> void:
	var target : Control
	if event.is_action_pressed("ui_right"):
		target = get_node("../Constants")
		get_tree().set_input_as_handled()
	if event.is_action_pressed("ui_left"):
		target = get_node("../Variables")
		get_tree().set_input_as_handled()
	if target:
		position = target.rect_position + target.rect_size / 2
