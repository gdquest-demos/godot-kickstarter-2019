extends Sprite

var speed : = 400.0
var path : = PoolVector2Array() setget set_path


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	pass


func move_along_path(distance : float) -> void:
	pass


func set_path(value : PoolVector2Array) -> void:
	pass
