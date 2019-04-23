extends Node

signal items_updated(items)

var active : = false setget set_active
var items : = {
	'potion': 0,
}

func coroutine_example() -> void:
	while active:
		yield(get_tree().create_timer(1.0), "timeout")
		if not active:
			break
		items['potion'] += 1
		emit_signal('items_updated', items)


func set_active(value:bool) -> void:
	active = value
	if active:
		coroutine_example()


func _on_PlayButton_pressed() -> void:
	self.active = true


func _on_StopButton_pressed() -> void:
	self.active = false
