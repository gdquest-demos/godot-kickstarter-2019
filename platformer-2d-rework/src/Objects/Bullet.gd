extends RigidBody2D
class_name Bullet


onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_Timer_timeout():
	destroy()

func destroy() -> void:
	animation_player.play("destroy")


func _on_body_entered(body: PhysicsBody2D):
	if body is Enemy:
		body.destroy()
