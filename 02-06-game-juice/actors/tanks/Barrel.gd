extends Position2D

signal shot
signal camera_shake_requested
signal frame_freeze_requested

onready var timer : Timer = $Timer
onready var spawn_position : Position2D = $SpawnPosition

export var fire_rate : = 5
export var bullet : PackedScene


func _ready() -> void:
	timer.wait_time = 1.0 / fire_rate


func _process(delta: float) -> void:
	look_at(get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and timer.is_stopped():
		shoot()


func _on_Bullet_destroyed() -> void:
	emit_signal("camera_shake_requested")
	emit_signal("frame_freeze_requested")


func shoot() -> void:
	timer.start()
	emit_signal("shot")
	var new_bullet = bullet.instance()
	new_bullet.initialize((get_global_mouse_position() - global_position).normalized())
	add_child(new_bullet)
	new_bullet.global_position = spawn_position.global_position
	new_bullet.look_at(get_global_mouse_position())
	new_bullet.connect("destroyed", self, "_on_Bullet_destroyed")
