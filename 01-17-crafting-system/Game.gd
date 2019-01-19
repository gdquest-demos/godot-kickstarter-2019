extends Node

onready var crafting_station : CraftingStation = $CraftingStation
onready var pivot : Position2D = $Pivot

var inventory : = { }


func _ready() -> void:
	var file = File.new()
	
	inventory = {
		"res://crafting/items/IronOre.json": 17,
		"res://crafting/items/Wood.json": 10,
		"res://crafting/items/IronIngot.json": 15,
		"res://crafting/items/SimpleSword.json": 1
	}
	
	file.open("res://crafting/items/Scimitar.json", file.READ)
	var item = parse_json(file.get_as_text())
	file.close()
	pivot.add_child(crafting_station.craft(item, inventory, 1)[0])
	print(inventory)