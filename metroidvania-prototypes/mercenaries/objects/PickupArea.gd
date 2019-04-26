extends Area2D

onready var shape = $CollisionShape2D

var detection_active: bool = false setget set_detection_active

func _ready():
	set_detection_active(detection_active)

func set_detection_active(active: bool) -> void:
	shape.disabled = not active

func _on_area_entered(area: Area2D):
	area.queue_free()
