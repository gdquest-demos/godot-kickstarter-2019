extends Node2D
class_name GameWorld
# Procedurally generates a tile based world map with a fixed outer perimeter.
# Use Right Mouse Click or Enter/Space to trigger regeneration.

signal started
signal finished

onready var tile_map : TileMap = $TileMap
onready var rng : = RandomNumberGenerator.new()

enum Cell {DIRT, GRASS, OUTER}

export var inner_size : = Vector2(10, 8)
export var perimeter_size : = Vector2(1, 1)
export(float, 0 , 1) var obstacle_probability : = 0.1

onready var size : = inner_size + 2 * perimeter_size

func _ready() -> void:
	initialize()
	generate()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click") or event.is_action_pressed("ui_accept"):
		generate()

func initialize() -> void:
	rng.randomize()
	var map_size_pixels : = size * tile_map.cell_size
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, map_size_pixels)
	OS.set_window_size(map_size_pixels)

func generate() -> void:
	emit_signal("started")
	generate_perimeter()
	generate_inner()
	emit_signal("finished")
	
func generate_perimeter() -> void:
	for x in [0, size.x - 1]:
		for y in range(0, size.y):
			tile_map.set_cell(x, y, pick_cell(Cell.OUTER))
	for x in range(1, size.x - 1):
		for y in [0, size.y - 1]:
			tile_map.set_cell(x, y, pick_cell(Cell.OUTER))

func generate_inner() -> void:
	for x in range(1, size.x - 1):
		for y in range(1, size.y - 1):
			var cell : = rand_cell(obstacle_probability)
			tile_map.set_cell(x, y, cell)

func pick_cell(type: int) -> int:
	var interval : = Vector2()
	if type == Cell.DIRT:
		interval = Vector2(0, 2)
	elif type == Cell.GRASS:
		interval = Vector2(3, 5)
	elif type == Cell.OUTER:
		interval = Vector2(6, 7)
	return rng.randi_range(interval.x, interval.y)

func rand_cell(probability: float) -> int:
	return pick_cell(Cell.GRASS) if rng.randf() < probability else pick_cell(Cell.DIRT)
