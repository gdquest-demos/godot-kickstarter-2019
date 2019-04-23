extends Node

onready var anchor : Position2D = $Anchor
onready var random_item_generator : Node = $RandomItemGenerator


func _ready() -> void:
	randomize()


func replace_item():
	var new_item : RandomItem = random_item_generator.generate_item()
	yield(get_tree(), "idle_frame")
	anchor.replace_child(new_item)
	new_item.show()


func _on_GenerateItemButton_pressed() -> void:
	replace_item()
