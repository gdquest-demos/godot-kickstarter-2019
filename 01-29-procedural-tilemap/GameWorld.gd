extends Node2D
class_name GameWorld
"""
Procedurally generates a tile based world map with a fixed outer perimeter.
Use Right Mouse Click or Enter/Space to trigger regeneration.
"""

signal started
signal finished

enum Cell {DIRT, GRASS, OUTER}

export var inner_size : = Vector2(10, 8)
export var perimeter_size : = Vector2(1, 1)
export(float, 0 , 1) var grass_probability : = 0.1

var size : = inner_size + 2 * perimeter_size # separating the public from pseudo-private members

var _tile_map : TileMap = null
var _rng : = RandomNumberGenerator.new()


func setup() -> void:
	"""Sets up the game window size to double the resolution of the world.
	"""
	_rng.randomize()
	var px : = size * _tile_map.cell_size
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, px)
	OS.set_window_size(2 * px)


func generate() -> void:
	# althoug we're not using these signals for anything here, we're including them as an example
	emit_signal("started")
	generate_perimeter()
	generate_inner()
	emit_signal("finished")


func generate_perimeter() -> void:
	"""Places tiles only on the outer perimeter, randomly selecting from the tiles marked as
	`Cell.OUTER` through the funciton `pick_cell`.
	"""
	for x in [0, size.x - 1]:
		for y in range(0, size.y):
			_tile_map.set_cell(x, y, pick_cell(Cell.OUTER))
	for x in range(1, size.x - 1):
		for y in [0, size.y - 1]:
			_tile_map.set_cell(x, y, pick_cell(Cell.OUTER))


func generate_inner() -> void:
	"""Places the inner tiles from the remaining types: `Cell.GRASS` and `Cell.DIRT` using the
	`rand_cell` function that takes the probability for `Cell.GRASS` tiles to have some more control
	over what types of tiles we'll be placing.
	"""
	for x in range(1, size.x - 1):
		for y in range(1, size.y - 1):
			var cell : = rand_cell(grass_probability)
			_tile_map.set_cell(x, y, cell)


func pick_cell(type: int) -> int:
	"""Randomly picks a tile based on the three types: `Cell.OUTER`, `Cell.GRASS` & `Cell.DIRT`.
	
	Returns the id of the cell in the TileSet resource.
	"""
	var interval : = Vector2()
	if type == Cell.OUTER:
		interval = Vector2(0, 9)
	elif type == Cell.GRASS:
		interval = Vector2(10, 14)
	elif type == Cell.DIRT:
		interval = Vector2(15, 27)
	return _rng.randi_range(interval.x, interval.y)


func rand_cell(probability: float) -> int:
	"""Randomly picks a tile id from `Cell.GRASS` and `Cell.DIRT` types given the grass probability.
	
	Returns the ide of the cell in the TileSet resource.
	"""
	return pick_cell(Cell.GRASS) if _rng.randf() < probability else pick_cell(Cell.DIRT)


func _ready() -> void:
	_tile_map = $TileMap
	setup()
	generate()


func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed()
			or event.is_action_pressed("ui_accept")):
		generate()
