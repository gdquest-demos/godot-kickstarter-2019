extends Node

onready var spawn_pos : Position2D = $SpawnPos

const SWORD_SCENE : = preload("res://items/Sword.tscn")

var last_item

func _ready() -> void:
	_create_new_item(SWORD_SCENE)

func _create_new_item(scene : PackedScene) -> void:
	if last_item:
		last_item.queue_free()
	yield(get_tree(), "idle_frame")
	last_item = scene.instance()
	spawn_pos.add_child(last_item)

func _on_GenerateItem_pressed():
	_create_new_item(SWORD_SCENE)
