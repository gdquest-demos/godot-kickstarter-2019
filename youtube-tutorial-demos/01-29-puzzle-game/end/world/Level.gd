extends TileMap

func _ready() -> void:
	for child in get_children():
		if child is GridBox:
			child.initialize(self)
