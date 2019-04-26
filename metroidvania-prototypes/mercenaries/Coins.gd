extends Node

signal coin_picked(coin_value)

func _ready():
	for coin in get_children():
		coin.connect("tree_exiting", self, "_on_Coin_tree_exiting", [coin.value])
		
func _on_Coin_tree_exiting(coin_value: int) -> void:
	emit_signal("coin_picked", coin_value)
