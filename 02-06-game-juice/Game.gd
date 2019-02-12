extends Node

export var level : PackedScene


func _on_JuiceControls_game_restarted() -> void:
	$Level.queue_free()
	yield(get_tree(), "idle_frame")
	add_child(level.instance())
