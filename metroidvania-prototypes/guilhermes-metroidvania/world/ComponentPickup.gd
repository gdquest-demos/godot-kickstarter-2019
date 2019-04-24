extends Interactive

onready var audio : AudioStreamPlayer2D = $Audio

export var component : PackedScene


func interact() -> void:
	GlobalEvents.emit_signal("component_unlocked", component.instance())
	audio.play()
	yield(audio, "finished")
	queue_free()
