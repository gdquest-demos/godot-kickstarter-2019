extends Node
class_name Bank

"""
Manage the player's money
"""
signal money_changed(new_amount)

var money := 0 setget set_money

func _ready() -> void:
	set_money(money)


func set_money(value: int) -> void:
	money = value
	emit_signal("money_changed", money)
