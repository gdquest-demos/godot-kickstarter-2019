extends Area2D

signal player_found(player)


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	

func _on_body_entered(body: PhysicsBody2D) -> void:
	if not body is Player:
		return
	emit_signal("player_found", body)
	disconnect("body_entered", self, "_on_body_entered")
