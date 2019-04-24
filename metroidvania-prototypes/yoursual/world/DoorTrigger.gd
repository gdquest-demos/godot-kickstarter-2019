extends Interactive

export var door : NodePath

onready var collision_shape : CollisionShape2D = $CollisionShape2D
onready var sprite : Sprite = $Sprite


func interact() -> void:
	assert get_node(door) is Door
	(get_node(door) as Door).open()
	queue_free()
