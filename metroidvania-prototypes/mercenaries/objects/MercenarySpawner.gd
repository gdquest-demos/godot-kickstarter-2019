extends Node2D

"""
Creates an instance of a mercenary inside a reference node's hierachy
at the current position of the spawner.
"""

export (PackedScene) var mercenary_scene: PackedScene = preload("res://actors/Mercenary.tscn")
export (NodePath) var instance_parent: NodePath = ".."

func spawn() -> Mercenary:
	var new_mercenary: Mercenary = mercenary_scene.instance() as Mercenary
	new_mercenary.global_position = global_position
	
	get_node(instance_parent).add_child(new_mercenary)
	return new_mercenary as Mercenary
