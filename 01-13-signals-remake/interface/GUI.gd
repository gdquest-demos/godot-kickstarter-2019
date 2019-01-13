extends Control

onready var texture_progress : = $TextureProgress

func _on_Player_health_changed(value):
	texture_progress.value = value
