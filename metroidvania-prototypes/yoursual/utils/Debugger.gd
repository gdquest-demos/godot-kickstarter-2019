extends Node


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("debug_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	elif event.is_action_pressed("debug_exit"):
		get_tree().quit()
	elif event.is_action_pressed("debug_restart"):
		get_tree().reload_current_scene()
