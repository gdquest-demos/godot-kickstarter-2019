#extends KinematicBody2D
extends RigidBody2D


onready var rope: Position2D = $Rope
onready var ray_cast: RayCast2D = $RayCast2D
onready var behavior_move: Node = $BehaviorMove
onready var behavior_jump: Node = $BehaviorJump
onready var behavior_hook: Node = $BehaviorHook

var hook_targets := []
var hook_target_idx := -1 setget set_hook_target_idx

var _gravity: Vector2 = ProjectSettings.get("physics/2d/default_gravity") * ProjectSettings.get("physics/2d/default_gravity_vector")
var _velocity := Vector2.ZERO


func _unhandled_key_input(event: InputEventKey) -> void:
	behavior_hook.run(event)
	if event.is_action_pressed("cycle"):
		set_hook_target_idx(hook_target_idx + 1)


func _physics_process(delta: float) -> void:
	var direction := U.get_direction("horizontal")
	rope.rotation = direction.angle() if direction.x != 0 else rope.rotation
	rope.rotation = (hook_targets[hook_target_idx].global_position - rope.hook.global_position).angle() if hook_target_idx != -1 else rope.rotation


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	behavior_move.run(state)
	behavior_jump.run(state)


func set_hook_target_idx(val: int) -> void:
	hook_target_idx = -1 if hook_targets.empty() else (val % hook_targets.size())
	for i in range(hook_targets.size()):
		hook_targets[i].selection.visible = i == hook_target_idx


func is_on_floor() -> bool:
	return ray_cast.is_colliding()