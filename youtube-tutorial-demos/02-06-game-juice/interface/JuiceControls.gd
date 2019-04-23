extends CanvasLayer

signal game_restarted

onready var control_list : VBoxContainer = $ControlList
onready var animation_player : AnimationPlayer = $AnimationPlayer

var hidden : = true
var fire_rate : = 2
var camera_shake : = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_menu"):
		if hidden:
			animation_player.play("slide_in")
			control_list.grab_focus()
		else:
			animation_player.play("slide_out")
			control_list.release_focus()
		hidden = not hidden


func _on_FX_pressed() -> void:
	ActiveJuices.visual_fx = not ActiveJuices.visual_fx
	for fx in get_tree().get_nodes_in_group("FX"):
		fx.enabled = not fx.enabled


func _on_CameraShake_pressed() -> void:
	camera_shake = not camera_shake
	for camera in get_tree().get_nodes_in_group("camera"):
		camera.enabled = not camera.enabled


func _on_FrameFreeze_pressed() -> void:
	for freezer in get_tree().get_nodes_in_group("freezer"):
		freezer.enabled = not freezer.enabled


func _on_Particles_pressed() -> void:
	ActiveJuices.particles = not ActiveJuices.particles


func _on_FastSpawn_toggled(button_pressed: bool) -> void:
	for level in get_tree().get_nodes_in_group("levels"):
		level.max_spawn_time *= 0.5 if button_pressed else 2


func _on_BiggerBullets_pressed() -> void:
	ActiveJuices.bigger_bullets = not ActiveJuices.bigger_bullets


func _on_Spread_pressed() -> void:
	ActiveJuices.bullet_spread = not ActiveJuices.bullet_spread


func _on_RapidFire_pressed() -> void:
	ActiveJuices.rapid_fire = not ActiveJuices.rapid_fire


func _on_WeakEnemies_pressed() -> void:
	ActiveJuices.weak_enemies = not ActiveJuices.weak_enemies
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.health *= ActiveJuices.HEALTH_MODIFIER if ActiveJuices.weak_enemies else 1 / ActiveJuices.HEALTH_MODIFIER


func _on_Tweening_pressed() -> void:
	ActiveJuices.tweening = not ActiveJuices.tweening


func _on_Restart_pressed() -> void:
	emit_signal("game_restarted")
	yield(get_tree(), "idle_frame")
	for gun in get_tree().get_nodes_in_group("guns"):
		gun.fire_rate = fire_rate
	for camera in get_tree().get_nodes_in_group("camera"):
		camera.enabled = camera_shake


func _on_FireRateSlider_value_changed(value: float) -> void:
	fire_rate = value
	for gun in get_tree().get_nodes_in_group("guns"):
		gun.fire_rate = int(value)


func _on_Sounds_pressed() -> void:
	ActiveJuices.sound = not ActiveJuices.sound
