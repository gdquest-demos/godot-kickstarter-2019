extends Position2D
"""
throws a raycast that can interact with Hookable bodies and calculate a pull vector towards those bodies
The raycast is updated manually for greater precision with where the player is aiming
This node acts as a pivot to rotate the hook around the player
"""

onready var ray: RayCast2D = $SpawningPoint/RayCast2D
onready var arrow: = $Arrow
onready var hint: = $TargetHint

onready var length = ray.cast_to.length()

const HOOKABLE_PHYSICS_LAYER: = 2

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hook"):
		throw(get_aim_direction())


func _physics_process(delta: float) -> void:
	rotation = get_aim_direction().angle()
	ray.force_raycast_update()
	if ray.is_colliding():
		var collider: PhysicsBody2D = ray.get_collider()
		var can_hook: = collider.get_collision_layer_bit(HOOKABLE_PHYSICS_LAYER)
		hint.visible = can_hook
		if can_hook:
			hint.global_position = ray.get_collision_point()
#			arrow.target_length = global_position.distance_to(ray.get_collision_point())
#		else:
#			arrow.target_length = 0.0


func throw(direction:Vector2) -> void:
	return


func get_aim_direction() -> Vector2:
	return get_global_mouse_position() - global_position
#	return Vector2(
#		Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left"),
#		Input.get_action_strength("aim_down") - Input.get_action_strength("aim_up"))
