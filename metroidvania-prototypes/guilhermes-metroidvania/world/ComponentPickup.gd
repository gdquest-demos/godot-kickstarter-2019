extends Interactive

export var component : PackedScene


func interact() -> void:
	GlobalEvents.emit_signal("component_unlocked", component.instance())
	queue_free()
