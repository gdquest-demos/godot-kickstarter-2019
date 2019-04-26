extends Node2D

func _ready() -> void:
	for discovery_area in get_children():
		discovery_area.connect("discovered", get_parent(), "_on_DiscoveryArea_discored")
