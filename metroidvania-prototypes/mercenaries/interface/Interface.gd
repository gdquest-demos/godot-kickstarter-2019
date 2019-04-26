extends Button

signal mercenary_selected(mercenary_name)

func _ready() -> void:
	for button in $GridContainer.get_children():
		button.connect("button_up", self, "_on_mercenary_selected", [button.text])


func _on_mercenary_selected(mercenary_name: String) -> void:
	emit_signal("mercenary_selected", mercenary_name)
	release_focus()
	pressed = false
	emit_signal("toggled", pressed)


func set_money_label_amount(amount: int) -> void:
	$MoneyLabel.text = "Money: $%s"%[amount]


func enable_mercenary_button(mercenary_name: String) -> void:
	var button: Button = $GridContainer/Rectangle
	match mercenary_name:
		"Rectangle":
			button = $GridContainer/Rectangle
		"Capsule":
			button = $GridContainer/Capsule
		"Circle":
			button = $GridContainer/Circle
	
	button.visible = true

