extends Area2D

signal destroyed

export var move_speed : = 350.0
export var damage : = 20

var direction : = Vector2()


func initialize(_direction: Vector2) -> void:
	direction = _direction


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	set_as_toplevel(true)


func _process(delta: float) -> void:
	position += direction * move_speed * delta


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.is_a_parent_of(self):
		return
	if body is Enemy:
		body.damage(damage)
	emit_signal("destroyed")
	queue_free()
