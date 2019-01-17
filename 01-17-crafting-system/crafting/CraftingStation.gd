extends Node
class_name CraftingStation
"""
Responsible to craft items based on recipes
"""


export var craftable_items = []


func can_craft_item(itens : Array, recipe : Array) -> int:
	"""
	Returns the amount of a certain item that can be crafted given a recipe and an array of itens
	"""
	var amount : = 999999
	var can_craft : = true
	for ingredient in recipe:
		var has_ingredient : = false
		for item in itens:
			if item.item == ingredient.item:
				if item.amount >= ingredient.amount:
					has_ingredient = true
					var craftable_amount : = int(item.amount / ingredient.amount)
					amount = craftable_amount if craftable_amount < amount else amount
		can_craft = has_ingredient
	if can_craft:
		return amount
	else:
		return -1


func get_craftables(itens : Array) -> Array:
	"""
	Returns an array of the possible craftable items with the given itens
	"""
	var craftables : = []
	for craftable_item in craftable_items:
		craftable_item = craftable_item as Item
		var craftable_amount : = can_craft_item(itens, craftable_item.recipe)
		if craftable_amount > 0:
			craftables.append({
							"item": craftable_item,
							"amount": craftable_amount
						})
	return craftables


func craft_item(itens : Array, item : Resource) -> Object:
	"""
	Crafts an item with the given itenss and recipe, and removes the used items from the array
	Returns the newly created item
	"""
	for ingredient in item.recipe:
		for item in itens:
			if item.item == ingredient.item:
				item.amount -= ingredient.amount
	return item.crafted_item.instance()
