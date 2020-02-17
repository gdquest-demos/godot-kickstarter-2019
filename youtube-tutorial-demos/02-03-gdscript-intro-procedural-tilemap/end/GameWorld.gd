extends Node2D
class_name GameWorld
# Procedurally generates a tile-based map with a border.
# Right click or press enter to re-generate the map.

signal started
signal finished

enum Cell {OBSTACLE, GROUND, OUTER}

export var inner_size := Vector2(10, 8)
export var perimeter_size := Vector2(1, 1)
export(float, 0 , 1) var ground_probability := 0.1

# Public variables
onready var size := inner_size + 2 * perimeter_size

# Private variables
onready var _tile_map : TileMap = $TileMap
var _rng := RandomNumberGenerator.new()


func setup() -> void:
	# Sets the game window size to twice the resolution of the world.
	var map_size_px := size * _tile_map.cell_size
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, map_size_px)
	OS.set_window_size(2 * map_size_px)


func generate() -> void:
	# Although there's no other nodes to use these signals, we're including them
	# to show when and how to emit them.
	# Watch our signals tutorial for more information.
	emit_signal("started")
	generate_perimeter()
	generate_inner()
	emit_signal("finished")


func generate_perimeter() -> void:
	# Fills the outer edges of the map with the border tiles.
	# Randomly selects from the tiles marked as `Cell.OUTER` using the funciton `_pick_random_texture`.
	# The two nested loops below fill the outer columns and outer row
	# of the map, respectively.
	for x in [0, size.x - 1]:
		for y in range(0, size.y):
			_tile_map.set_cell(x, y, _pick_random_texture(Cell.OUTER))
	for x in range(1, size.x - 1):
		for y in [0, size.y - 1]:
			_tile_map.set_cell(x, y, _pick_random_texture(Cell.OUTER))


func generate_inner() -> void:
	# Fills the inside of the map the inner tiles from the remaining types: `Cell.GROUND` and `Cell.OBSTACLE` using the
	# `get_random_tile` function that takes the probability for `Cell.GROUND` tiles to have some more control
	# over what types of tiles we'll be placing.
	for x in range(1, size.x - 1):
		for y in range(1, size.y - 1):
			var cell := get_random_tile(ground_probability)
			_tile_map.set_cell(x, y, cell)


func get_random_tile(probability: float) -> int:
	# Randomly picks a tile id between `Cell.GROUND` and `Cell.OBSTACLE` types given the ground probability.
	# Returns the id of the cell in the TileSet resource.
	return _pick_random_texture(Cell.GROUND) if _rng.randf() < probability else _pick_random_texture(Cell.OBSTACLE)


func _pick_random_texture(cell_type: int) -> int:
	# Randomly picks a tile based on the three types: `Cell.OUTER`, `Cell.GROUND` & `Cell.OBSTACLE`.
	# Returns the id of the cell in the TileSet resource.
	var interval := Vector2()
	if cell_type == Cell.OUTER:
		interval = Vector2(0, 9)
	elif cell_type == Cell.GROUND:
		interval = Vector2(10, 14)
	elif cell_type == Cell.OBSTACLE:
		interval = Vector2(15, 27)
	return _rng.randi_range(interval.x, interval.y)


func _ready() -> void:
	_rng.randomize()
	setup()
	generate()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		generate()
