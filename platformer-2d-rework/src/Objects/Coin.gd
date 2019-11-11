extends Area2D

class_name Coin

onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_coin_body_enter(body):
	animation_player.play("taken")
	set_deferred("monitoring", false)
