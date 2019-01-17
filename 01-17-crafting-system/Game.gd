extends Node

onready var crafting_station : CraftingStation = $CraftingStation

var itens : = []


func _ready() -> void:
	itens = [{
		"item": load("res://crafting/items/IronOre.tres"),
		"amount": 17
	}, {
		"item": load("res://crafting/items/Wood.tres"),
		"amount": 10
	}]
	print(crafting_station.can_craft_item(itens, load("res://crafting/items/IronIngot.tres").recipe))
	