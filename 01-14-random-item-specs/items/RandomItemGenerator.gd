extends Node


const SWORD_SCENE : = preload("res://items/Sword.tscn")


func generate_item() -> RandomItem:
	"""
	Returns a new, unitiliazed RandomItem
	"""
	var new_item : RandomItem = SWORD_SCENE.instance()
	return new_item
