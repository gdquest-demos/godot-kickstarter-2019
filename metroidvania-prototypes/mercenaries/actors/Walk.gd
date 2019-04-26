extends Node

onready var kinematic_body2D: KinematicBody2D = get_node(kinematic_body2D_path) as KinematicBody2D

export (NodePath) var kinematic_body2D_path: NodePath = ".."
export (float) var speed := 200.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("walk_left"):
		kinematic_body2D.velocity.x = -speed
	elif event.is_action_pressed("walk_right"):
		kinematic_body2D.velocity.x = speed
	
	if event.is_action_released("walk_left") and not Input.is_action_pressed("walk_right"):
		kinematic_body2D.velocity.x = 0.0
	elif event.is_action_released("walk_right") and not Input.is_action_pressed("walk_left"):
		kinematic_body2D.velocity.x = 0.0
	elif event.is_action_released("walk_left") and Input.is_action_pressed("walk_right"):
		kinematic_body2D.velocity.x = speed
	elif event.is_action_released("walk_right") and Input.is_action_pressed("walk_left"):
		kinematic_body2D.velocity.x = -speed
	 
