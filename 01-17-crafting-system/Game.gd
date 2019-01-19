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
	var file = File.new()
	file.open("res://crafting/items/Scimitar.json", file.READ)
	var item = parse_json(file.get_as_text())
	file.close()
	pivot.add_child(crafting_station.craft(item, inventory, 1)[0])
	text_box.update_text(inventory)
