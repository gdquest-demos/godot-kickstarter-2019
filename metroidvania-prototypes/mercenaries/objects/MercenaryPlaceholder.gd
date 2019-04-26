extends Position2D

"""
A dummy mercenary that shall only replicate a reference mercenary's
appearence
"""

export (PackedScene) var mercenary_scene: PackedScene = preload("res://actors/Mercenary.tscn")

func _ready():
	var mercenary: Mercenary = mercenary_scene.instance()
	var appearence: Geometry2D = mercenary.get_geometry()
	
	appearence = appearence.duplicate()
	add_child(appearence)
	mercenary.queue_free()
