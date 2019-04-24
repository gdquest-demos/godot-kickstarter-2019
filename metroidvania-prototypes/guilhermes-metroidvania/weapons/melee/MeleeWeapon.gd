extends Weapon

onready var hit_box : Area2D = $HitBox

export var attack_range := 196


func _ready() -> void:
	hit_box.connect("body_entered", self, "_on_HitBox_body_entered")


func _on_HitBox_body_entered(body: PhysicsBody2D) -> void:
	if body.is_a_parent_of(self):
		return
	if body is Enemy:
		body.damage(damage)
	elif body is Interactive:
		body.interact()


func use_weapon() -> void:
	.use_weapon()
	hit_box.position = Vector2(attack_range * attack_direction, 0)
	hit_box.active = true
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	hit_box.active = false
