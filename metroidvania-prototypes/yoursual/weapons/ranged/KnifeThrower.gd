extends Weapon

export var knife : PackedScene

func use_weapon() -> void:
	.use_weapon()
	var new_knife := knife.instance() as Knife
	add_child(new_knife)
	new_knife.global_position = global_position
	new_knife.initialize(attack_direction, damage)
