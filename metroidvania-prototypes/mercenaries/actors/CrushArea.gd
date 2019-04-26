extends Area2D

signal crush_started
signal crush_finished

onready var kinematic_body2D: KinematicBody2D = get_node(kinematic_body2D_path) as KinematicBody2D
onready var shape: CollisionPolygon2D = $CollisionPolygon2D as CollisionPolygon2D
onready var timer: Timer = $Timer as Timer

export (NodePath) var kinematic_body2D_path: NodePath = ".."
export (float) var smash_velocity := 300.0

func _unhandled_input(event):
	if timer.time_left > 0.0:
		return
	if event.is_action_pressed("crush"):
		crush()

func crush() -> void:
	if not kinematic_body2D.is_on_floor():
		return
	
	emit_signal("crush_started")
	visible = true
	shape.disabled = false
	timer.start()
	yield(timer, "timeout")
	
	shape.disabled = true
	visible = false
	emit_signal("crush_finished")


func _on_body_entered(body: CollisionObject2D):
	body.queue_free()
