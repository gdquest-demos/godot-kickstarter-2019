extends Box
class_name PhysicsBox


func push(velocity: Vector2) -> void:
	move_and_slide(velocity, Vector2())
