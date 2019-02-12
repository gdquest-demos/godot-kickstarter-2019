extends Node2D

onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	$AnimatedSprite.play("explosion")
	if ActiveJuices.sound:
		audio_player.play()


func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()
