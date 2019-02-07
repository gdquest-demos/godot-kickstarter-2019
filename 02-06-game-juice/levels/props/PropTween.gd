extends Tween

export var min_time : = 0.4
export var max_time : = 0.9

func _ready() -> void:
	randomize()
	var parent : = get_parent()
	parent.scale = Vector2.ZERO
	
	interpolate_property(parent,
		"scale",
		Vector2.ZERO,
		Vector2.ONE,
		rand_range(min_time, max_time),
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT)
	start()
