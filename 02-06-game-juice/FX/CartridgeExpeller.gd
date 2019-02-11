extends Node2D

onready var tween : Tween = $Tween

export var cartridge : PackedScene
export var min_distance : = 25.0
export var max_distance : = 50.0

var enabled : = false


func _ready() -> void:
	enabled = ActiveJuices.visual_fx
	randomize()


func expell() -> void:
	if not enabled:
		return
	var cartridge_position = global_position + Vector2(randf(), randf()).normalized() * rand_range(min_distance, max_distance)
	var new_cartridge : = cartridge.instance()
	new_cartridge.global_position = global_position
	new_cartridge.rotation_degrees = randi() % 360
	new_cartridge.set_as_toplevel(true)
	add_child(new_cartridge)
	tween.interpolate_property(new_cartridge, 
		"global_position", 
		new_cartridge.global_position, 
		cartridge_position, 
		0.3, 
		Tween.TRANS_CUBIC, 
		Tween.EASE_OUT)
	tween.start()


func _on_Barrel_shot() -> void:
	expell()
