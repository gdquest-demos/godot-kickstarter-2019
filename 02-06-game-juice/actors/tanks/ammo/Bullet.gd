extends Area2D

signal destroyed(enemy_hit)

onready var particles : Particles2D = $Particles2D

export var explosion : PackedScene
export var move_speed : = 175.0
export var damage : = 20

var direction : = Vector2()


func initialize(_direction: Vector2) -> void:
	direction = _direction
	if ActiveJuices.bullet_spread:
		randomize()
		direction += Vector2(randf() / 10, randf() / 10)


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	set_as_toplevel(true)
	particles.emitting = ActiveJuices.particles
	scale *= 2 if ActiveJuices.bigger_bullets else 1
	move_speed *= 3 if ActiveJuices.rapid_fire else 1


func _process(delta: float) -> void:
	position += direction * move_speed * delta


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.is_a_parent_of(self):
		return
	var enemy_hit : = false
	if body is Enemy:
		body.damage(damage)
		enemy_hit = true
	emit_signal("destroyed", enemy_hit)
	queue_free()
