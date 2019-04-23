extends Interactive


func interact() -> void:
	for child in get_children():
		if child is Door:
			(child as Door).open()
	queue_free()
