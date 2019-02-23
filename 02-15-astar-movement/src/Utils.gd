extends Node
"""
General utility library that can be used across multiple projects as an autoload script.
"""


const ERR : = 1e-6

"""
Returns a normalized 4-way Vector2 (up, down, left, right) direction.
"""
static func get_direction(event: InputEvent) -> Vector2:
	return Vector2(
			event.get_action_strength("ui_right") - event.get_action_strength("ui_left"),
			event.get_action_strength("ui_down") - event.get_action_strength("ui_up"))


"""
Returns true if `point` is inside rectangle `rect` otherwise false.
"""
static func is_inside(point: Vector2, rect: Rect2) -> bool:
	return (point.x > rect.position.x
			and point.y > rect.position.y
			and point.x < rect.size.x
			and point.y < rect.size.y)


"""
Given any Vector2, it returns its 1-dimensional index. It only makes sense if components of `v`
are integer numbers.

Note
----
This is useful to be used with the AStar algorithm which associates an index with its vector points.
Check PathFinder.gd to see it in action.
"""
static func to_idx(v: Vector2, columns: int) -> int:
	return int(v.x + columns * v.y)


static func to_vector2(from: Vector3) -> Vector2:
	return Vector2(from.x, from.y)


static func to_vector3(from: Vector2) -> Vector3:
	return Vector3(from.x, from.y, 0)


static func to_px(from: Vector2, cell_size: Vector2) -> Vector2:
	return from * cell_size


static func cycle(idx: int, size: int) -> int:
	return idx % size if idx >= 0 else abs((size + idx) % size)