extends KinematicBody2D


onready var rope: Position2D = $Rope

var hooks := []
var hook_idx := -1 setget set_hook_idx

var _speed := {
	"walk": 300,
	"jump": 500
}
var _gravity: Vector2 = ProjectSettings.get("physics/2d/default_gravity") * ProjectSettings.get("physics/2d/default_gravity_vector")
var _velocity := Vector2.ZERO


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("cycle"):
		set_hook_idx(hook_idx + 1)


func _physics_process(delta: float) -> void:
	var direction := U.get_direction("horizontal")
	_velocity.x = _speed["walk"] * direction.x
	_velocity.y -= _speed["jump"] if Input.is_action_just_pressed("jump") and is_on_floor() else 0
	_velocity.y += _gravity.y * delta
	move_and_slide(_velocity, Vector2.UP)
	_velocity.y = 0 if is_on_floor() else _velocity.y
	
	rope.rotation = direction.angle() if direction.x != 0 else rope.rotation
	rope.rotation = (hooks[hook_idx].position - position).angle() if hook_idx != -1 else rope.rotation


func set_hook_idx(val: int) -> void:
	hook_idx = -1 if hooks.empty() else (val % hooks.size())
	for i in range(hooks.size()):
		hooks[i].selection.visible = i == hook_idx