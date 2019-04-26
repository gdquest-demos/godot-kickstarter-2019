extends Area2D

signal discovered(mercenary)

const RECTANGLE := "Rectangle"
const CIRCLE := "Circle"
const CAPSULE := "Capsule"

enum Mercenaries{RECTANGLE, CIRCLE, CAPSULE}

export (Mercenaries) var discovered_mercenary: int = 0

func _on_area_entered(area: CollisionObject2D) -> void:
	var mercenary_name: = RECTANGLE
	match discovered_mercenary:
		0:
			mercenary_name = RECTANGLE
		1:
			mercenary_name = CIRCLE
		2:
			mercenary_name = CAPSULE
	emit_signal("discovered", mercenary_name)
	
	queue_free()
