extends Position2D

func replace_child(new : RandomItem) -> void:
	for c in get_children():
		c.queue_free()
	add_child(new)
