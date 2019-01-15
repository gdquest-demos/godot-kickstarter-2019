extends Node2D

onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var item_tooltip : Panel = $ItemTooltip
onready var specs : Node = $Specs

export var possible_specs : = []
export var possible_rarities : = []

const SPEC_SCENE = preload("res://items/specs/Spec.tscn")

var rarity : Resource

func _ready() -> void:
	randomize()
	
	var rarity_index = 0
	var rarer_chance : = 1.0
	var roll = randf()
	for index in possible_rarities.size():
		if roll < possible_rarities[index].chance:
			if possible_rarities[index].chance < rarer_chance:
				rarer_chance = possible_rarities[index].chance
				rarity_index = index
	
	rarity = possible_rarities[rarity_index]
	animated_sprite.play(rarity.rarity_name.to_lower())
	
	for spec in possible_specs:
		if spec.mandatory or randf() < spec.chance:
			var new_spec : = SPEC_SCENE.instance()
			new_spec.initialize(spec.spec_name, int(rand_range(spec.min_value, spec.max_value) * rarity.spec_multiplier))
			specs.add_child(new_spec)
	item_tooltip.initialize(name, specs.get_children(), rarity)

func _on_Area2D_mouse_entered() -> void:
	item_tooltip.show()

func _on_Area2D_mouse_exited() -> void:
	item_tooltip.hide()
