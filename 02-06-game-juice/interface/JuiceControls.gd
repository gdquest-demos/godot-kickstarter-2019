extends CanvasLayer

onready var control_list : VBoxContainer = $ControlList
onready var animation_player : AnimationPlayer = $AnimationPlayer

var hidden : = true
var fast_respawn : = false

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
	for fx in get_tree().get_nodes_in_group("FX"):
		fx.enabled = not fx.enabled


func _on_CameraShake_pressed() -> void:
	for camera in get_tree().get_nodes_in_group("camera"):
		camera.enabled = not camera.enabled


func _on_FrameFreeze_pressed() -> void:
	for freezer in get_tree().get_nodes_in_group("freezer"):
		freezer.enabled = not freezer.enabled


func _on_Particles_pressed():
	for particle in get_tree().get_nodes_in_group("particles"):
		particle.emitting = not particle.emitting


func _on_FastSpawn_pressed():
	for level in get_tree().get_nodes_in_group("levels"):
		level.max_spawn_time *= 2 if fast_respawn else 0.5
	fast_respawn = not fast_respawn
