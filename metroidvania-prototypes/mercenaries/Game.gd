extends Node

func _on_Interface_mercenary_selected(mercenary_name):
	$MercenaryGuild.hire_mercenary($Bank, mercenary_name)


func _on_Bank_money_changed(new_amount: int) -> void:
	$InterfaceLayer/Interface.set_money_label_amount(new_amount)


func _on_Coins_coin_picked(coin_value):
	$Bank.money += coin_value


func _on_DiscoveryArea_discored(mercenary_name: String) -> void:
	$InterfaceLayer/Interface.enable_mercenary_button(mercenary_name)