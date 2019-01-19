extends Node
class_name CraftingStation
"""
Creates crafted items based on recipes and using the materials contained in inventories
Inventories are dictionaries: the keys represent items, and the amount available for each of them
"""


func can_craft(item_to_craft : Dictionary, inventory : Dictionary, amount : int = 1) -> bool:
	"""
	Returns true if a certain item can be crafted based on the inventory's content
	"""
	var can_craft : = true
	if amount < 1 or item_to_craft.recipe.empty() or not (inventory.has_all(item_to_craft.recipe.keys())):
		can_craft = false
	else:
		var item_adjusted : = adjust_item_recipe(item_to_craft, amount)
		for item in item_to_craft.recipe:
			if item_adjusted.recipe[item] > inventory[item]:
				can_craft = false
				break
	return can_craft


func adjust_item_recipe(item : Dictionary, amount : int) -> Dictionary:
	"""
	Returns a new item with an adjusted recipe based on the amount of items to craft
	"""
	var adjusted_item : = item.duplicate()
	if amount > 1:
		for ingredient in adjusted_item.recipe:
			adjusted_item.recipe[ingredient] *= amount
	return adjusted_item


func craft(item : Dictionary, inventory: Dictionary, amount : int = 1) -> Array:
	"""
	Crafts the amount of items and consumes the required material from the inventory
	Returns the newly created items
	"""
	if amount < 0 or not can_craft(item, inventory, amount):
		return []
	var crafted_items : = []
	for i in amount :
		crafted_items.append(load(item.scene).instance())
	use(adjust_item_recipe(item, amount), inventory)
	return crafted_items


func use(item : Dictionary, inventory: Dictionary) -> void:
	"""
	Removes the items required to craft items from in the inventory
	"""
	if not inventory.has_all(item.recipe.keys()):
		return
	for ingredient in item.recipe:
		inventory[ingredient] -= item.recipe[ingredient]
		if inventory[ingredient] == 0:
			inventory.erase(ingredient)
