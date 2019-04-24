extends Node2D

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var audio : AudioStreamPlayer2D = $Audio
onready var raycast : RayCast2D = $RayCast2D
onready var sprite : Sprite = $Sprite
onready var area : Area2D = $Area2D
onready var tween : Tween = $Tween

export var damage := 50
export var fall_delay := 0.25
export var falling_duration := 0.75

var fallen := false


func _ready() -> void:
	area.connect("body_entered", self, "_on_Area2D_body_entered", [], CONNECT_ONESHOT)


func _physics_process(delta: float) -> void:
	if raycast.is_colliding() and not fallen:
		if raycast.get_collider() is Player:
			yield(fall(), "completed")


func _on_Area2D_body_entered(body) -> void:
	if body is Player:
		get_tree().reload_current_scene()


func fall() -> void:
	fallen = true
	animation_player.play("shake")
	tween.interpolate_property(self,
		"global_position",
		global_position,
		global_position + raycast.cast_to,
		falling_duration,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN,
		fall_delay)
	tween.start()
	yield(animation_player, "animation_finished")
	audio.play()
	yield(tween, "tween_completed")
	queue_free()
