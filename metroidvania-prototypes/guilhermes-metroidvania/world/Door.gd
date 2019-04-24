extends StaticBody2D
class_name Door

onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var tween : Tween = $Tween
onready var sprite : Sprite = $Sprite


func open() -> void:
	#TODO: Add animations/sound
	audio.play()
	tween.interpolate_property(self,
		"global_position",
		global_position,
		global_position + Vector2(0, sprite.texture.get_size().y * 2),
		0.5,
		Tween.TRANS_QUINT,
		Tween.EASE_IN)
	tween.start()
