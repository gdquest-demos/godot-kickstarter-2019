extends RichTextLabel


func update_text(inventory: Dictionary) -> void:
	text = "Inventory:\n\n"
	for item in inventory:
		var item_name : String = item.rsplit(".", true, 1)[0].rsplit("/", true, 1)[1]
		text += "%s: %s\n" % [item_name, inventory[item]]
