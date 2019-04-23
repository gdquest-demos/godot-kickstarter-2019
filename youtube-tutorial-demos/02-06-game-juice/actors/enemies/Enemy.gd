extends KinematicBody2D
class_name Enemy

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

export var health : = 100.0
export var move_speed : = 75
export var explosion : PackedScene

var path : = []
var player : Node2D


func _ready() -> void:
	health *= ActiveJuices.HEALTH_MODIFIER if ActiveJuices.weak_enemies else 1


func _physics_process(delta: float) -> void:
	path = get_parent().get_simple_path(global_position, player.global_position)
	var direction = (path[1] - global_position).normalized()
	look_at(path[1])
	move_and_slide(direction * move_speed)


func initialize(_player: Node2D) -> void:
	player = _player


func damage(value: int) -> void:
	health = max(0, health - value)
	if ActiveJuices.visual_fx:
		animation_player.play("damaged")
	if ActiveJuices.sound:
		audio_player.play()
	if health == 0:
		if ActiveJuices.visual_fx:
			var new_explosion : = explosion.instance()
			new_explosion.global_position = global_position
			get_tree().get_root().add_child(new_explosion)
		queue_free()
