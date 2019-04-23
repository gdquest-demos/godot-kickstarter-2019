extends Behavior
"""
Bump behavior.

All it does is play a "bump" animation.
"""

onready var animation_player: AnimationPlayer = $AnimationPlayer


func setup() -> void:
	animation_player.root_node = root_node.get_path()


func run(msg: Dictionary = {}) -> void:
	if not root_node.is_walking:
		animation_player.play("bump")
		yield(animation_player, "animation_finished")
		animation_player.play("<BASE>")