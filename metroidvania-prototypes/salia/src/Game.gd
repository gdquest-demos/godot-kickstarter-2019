extends Node2D


onready var hooks: Node2D = $Hooks
onready var timer: Timer = $Timer


func _ready() -> void:
	timer.connect("timeout", self, "_on_Timer_timeout")


func _on_Timer_timeout() -> void:
	for i in range(hooks.get_child_count() - 1):
		hooks.get_child(i).queue_free()