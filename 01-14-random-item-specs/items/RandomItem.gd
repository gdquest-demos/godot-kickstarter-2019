extends Node2D
class_name RandomItem


onready var animated_sprite : AnimatedSprite = $AnimatedSprite
onready var tooltip : Panel = $Tooltip

export var possible_specs : = []
export var possible_rarities : = []

const SPEC_SCENE = preload("res://items/specs/Spec.tscn")

var rarity : Resource
var specs : = []


func _ready() -> void:
	generate()
	tooltip.initialize(name, specs, rarity)


func generate() -> void:
	"""
	Randomly generates a rarity level and specifications, then assigns 
	them to this item
	"""
	rarity = generate_rarity()
	specs = generate_specs()
	animated_sprite.play(rarity.rarity_name.to_lower())	


func generate_rarity() -> Resource:
	"""
	Randomly generates and returns a Rarity Resource
	"""
	var rarity_index : = 0
	var rarer_chance : = 1.0
	var roll : = randf()
	for index in possible_rarities.size():
		if roll > possible_rarities[index].chance:
			continue
		if possible_rarities[index].chance > rarer_chance:
			continue
		rarer_chance = possible_rarities[index].chance
		rarity_index = index
	return possible_rarities[rarity_index]


func generate_specs() -> Array:
	"""
	Returns an array of generated item properties/specifications
	"""
	var new_specs : = []
	for spec in possible_specs:
		if not spec.mandatory or randf() > spec.chance:
			continue
		var new_spec : = SPEC_SCENE.instance()
		new_spec.initialize(spec.spec_name, int(rand_range(spec.min_value, spec.max_value) * rarity.spec_multiplier))
		new_specs.append(new_spec)
	return new_specs


func _on_Area2D_mouse_entered() -> void:
	tooltip.show()


func _on_Area2D_mouse_exited() -> void:
	tooltip.hide()
