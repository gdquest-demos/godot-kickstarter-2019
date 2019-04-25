extends "res://src/Player/Behavior.gd"


onready var game: Node2D = $"/root/Game"
onready var tween: Tween = $Tween

const HookScene: PackedScene = preload("res://scenes/Hook.tscn")

const SPEED := 3000
const IMPULSE := 40000


func run(event: InputEventKey) -> void:
	if parent.hook_targets.empty():
		return
	
	if event.is_action_pressed("fire"):
		var hook: Geometry2D = HookScene.instance()
		hook.global_position = parent.rope.hook.global_position
		game.hooks.add_child(hook)
	
		var hook_target: Area2D = parent.hook_targets[parent.hook_target_idx]
		var distance: float = (hook_target.global_position - parent.rope.hook.global_position).length()
		var time := distance/SPEED
		
		tween.interpolate_property(
				hook, "global_position", hook.global_position, hook_target.global_position, time,
				Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
	
	elif event.is_action_pressed("trigger") and not tween.is_active() and game.hooks.get_child_count() > 0:
		var direction: Vector2 = (game.hooks.get_child(game.hooks.get_child_count() - 1).global_position - parent.global_position).normalized()
		parent.apply_central_impulse(IMPULSE * direction)