extends Position2D


signal moved_to(position)

onready var tween : Tween = $Tween
var move_speed : = 600.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('click') and not tween.is_active():
		move_to(get_global_mouse_position())


func move_to(target_position:Vector2) -> void:
	var duration : = position.distance_to(target_position) / move_speed
	tween.interpolate_property(
		self, 'position',
		position, target_position, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal('moved_to', position)
