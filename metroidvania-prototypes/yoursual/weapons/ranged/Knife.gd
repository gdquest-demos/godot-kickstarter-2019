extends Area2D
class_name Knife

export var move_speed := 4000.0

var direction := 1.0
var damage := 5


func _ready() -> void:
	set_as_toplevel(true)
	connect("body_entered", self, "_on_body_entered")


func _process(delta: float) -> void:
	global_position.x += direction * move_speed * delta


func _on_body_entered(body) -> void:
	if body.is_a_parent_of(self):
		return
	if body is Interactive:
		body.interact()
	elif body is Enemy:
		body.damage(damage)
	queue_free()


func initialize(_direction: float, _damage: int) -> void:
	direction = _direction
	damage = _damage
