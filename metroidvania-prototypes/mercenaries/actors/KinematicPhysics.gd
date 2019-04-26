extends Node

onready var kinematic_body2D: KinematicBody2D = get_node(kinematic_body2D_path) as KinematicBody2D

export (NodePath) var kinematic_body2D_path: NodePath = ".."

func _ready():
	kinematic_body2D.connect("tree_exiting", self, "_on_KinematicBody2D_tree_exiting")


func _on_KinematicBody2D_tree_exiting() -> void:
	set_physics_process(false)