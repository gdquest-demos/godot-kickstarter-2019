extends Node

"""
Manage the control over a given mercenary
"""

onready var current_mercenary: Mercenary = $Rectangle

func _ready():
	current_mercenary.active = true

func hire_mercenary(bank_account: Bank, mercenary_name: String) -> bool:
	var can_hire: bool = $Contract.can_contract(bank_account.money)
	
	if not can_hire:
		return false
	
	var mercenary: Mercenary
	match mercenary_name:
		"Rectangle":
			mercenary = $Rectangle
		"Capsule":
			mercenary = $Capsule
		"Circle":
			mercenary = $Circle
			
	if not current_mercenary == mercenary:
		current_mercenary.active = false
		current_mercenary = mercenary
		mercenary.active = true
		
		bank_account.money -= $Contract.cost
	return can_hire
