extends Area2D

class_name Coin

onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_coin_body_enter(body):
	if body is Player:
		animation_player.play("taken")
		set_deferred("monitoring", false)
