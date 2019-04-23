extends Node

export var delay_mseconds : = 15

var enabled : = false

func _ready() -> void:
	for frame_freezer in get_tree().get_nodes_in_group("frame_freezer"):
			frame_freezer.connect("frame_freeze_requested", self, "_on_frame_freeze_requested")
	

func _on_frame_freeze_requested() -> void:
	if not enabled:
		return
	OS.delay_msec(delay_mseconds)
