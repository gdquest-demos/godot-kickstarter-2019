extends Node

"""
Manage the costs of a mercenary
"""

export (int) var cost := 10


func can_contract(available_money: int) -> bool:
	var can_contract := false
	
	can_contract = available_money - cost >= 0
	return can_contract
