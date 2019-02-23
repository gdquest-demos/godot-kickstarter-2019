extends Node
class_name Behavior
"""
Behavior base class offers two functions: `run` & `is_noop`. This is pretty much the Command pattern
addapted to Godot.

A Behavior is a single functionality exposed through the `run(msg: Dictionary)` function.
For example, in OpenRPG, to make the player walk and react to obstacles, we use two individual
Behaviors: Bump & Walk.

Walk doesn't know how to stop on obstacles, it just knows how to move the player from point A to
point B. This means that checking for obstacles has to be done prior to calling the walk behavior
and if indeed there's an obstacle, the bump behavior is used instead.

The Actor is the one in charge of rerouting information to Behaviors.

Notes
-----
This Node behaves like the AnimationPlayer Node in that it operate on `root_node`, which in
Behavior's case is fixed to be $".." (ie. the parent Node).
"""


onready var root_node: Node = $".."


func setup() -> void:
	pass


func run(msg: Dictionary = {}) -> void:
	pass


func is_noop() -> bool:
	return name == "noop"


func _ready() -> void:
	name = name.to_lower()