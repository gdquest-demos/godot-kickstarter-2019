extends Node

onready var crafting_station : CraftingStation = $CraftingStation
onready var pivot : Position2D = $Pivot
onready var text_box : RichTextLabel = $TextBox

var inventory = {
		"res://crafting/items/IronOre.json": 17,
		"res://crafting/items/Wood.json": 10,
		"res://crafting/items/IronIngot.json": 15,
		"res://crafting/items/SimpleSword.json": 1
	}


func _ready() -> void:
	text_box.update_text(inventory)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		craft_item()


func craft_item():
	var items_and_inventory : = crafting_station.craft(get_dict_from_json("res://crafting/items/SimpleSword.json"), inventory, 1)
	inventory = items_and_inventory.inventory
	pivot.add_child(items_and_inventory.items[0])
	text_box.update_text(inventory)


func get_dict_from_json(path : String) -> Dictionary:
	var file = File.new()
	file.open(path, file.READ)
	var item = parse_json(file.get_as_text())
	file.close()
	return item