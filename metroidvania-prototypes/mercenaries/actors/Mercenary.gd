extends KinematicBody2D
class_name Mercenary

const FLOOR_NORMAL := Vector2(0, -1)
var velocity := Vector2(0, 0)

var active := false setget set_active

func _ready() -> void:
	set_active(false)

func _physics_process(delta: float) -> void:
	move_and_slide(velocity, FLOOR_NORMAL, true)

func get_geometry() -> Geometry2D:
	return get_node("Geometry2D") as Geometry2D

func set_active(is_active: bool) -> void:
	for child in get_children():
		child.set_process(is_active)
		child.set_physics_process(is_active)
		child.set_process_unhandled_input(is_active)
		
	set_physics_process(is_active)
	$Camera2D.current = is_active
	$PickupArea.set_detection_active(is_active)
	active = is_active
