extends Node2D
"""
Uses the underlying PathFinder (AStar) to find routes.

This is a visual representation of the world, using TileMaps. It also offers visual feedback to
the player for accessible vs obstacle tiles, interactive encounters, and Party destination flag
when Party is given order to walk.
"""


onready var feedback: TileMap = $Feedback
onready var encounters: Node2D = $Encounters
onready var path_finder: Node2D = $PathFinder
onready var size: Vector2 = path_finder.rect.size * path_finder.map.cell_size

enum Feedback { INVALID = -1, ACTOR, OBJECT, FLAG, FORBID, ALLOW }

var _feedback_flag_position: = Utils.V2_00
var _has_feedback_flag: = false


func _ready() -> void:
	Events.connect("party_member_walk_started", self, "_on_signal", ["started"])
	Events.connect("party_member_walk_finished", self, "_on_signal", ["finished"])
	path_finder.setup(encounters.get_children())


func _unhandled_input(event: InputEvent) -> void:
	var at: Vector2 = path_finder.map.world_to_map(get_global_mouse_position())
	if event is InputEventMouse and not _feedback_flag_position == at:
		var type: int = Feedback.FORBID if at in path_finder.map.obstacles else Feedback.ALLOW
		_feedback_react(at, type)


func _on_signal(msg: Dictionary = {}, which: String = "") -> void:
	var type: int = Feedback.INVALID
	var at: = Utils.V2_00

	match msg:
		{"is_leader": true, "destination": var destination}:
			at = path_finder.map.world_to_map(destination)
			continue
		{"is_leader": true, ..}:
			_has_feedback_flag = which == "started"
			_feedback_flag_position = at
			_feedback_react(at, type)


"""
Given the `type`, refresh the Feedback texture at position `xy`.
"""
func _feedback_react(xy: Vector2, type: int) -> void:
	feedback.clear()
	if type != Feedback.INVALID:
		feedback.set_cellv(xy, type)
	if _has_feedback_flag:
		feedback.set_cellv(_feedback_flag_position, Feedback.FLAG)


"""
Tries to find a valid route starting at `from` (inclusive) and finishing at `to` (inclusive).

Returns an Vector2 Array of points in global pixel coordinates.
"""
func get_point_path(from: Vector2, to: Vector2) -> Array:
	from = path_finder.map.world_to_map(from)
	to = path_finder.map.world_to_map(to)
	var path: = []
	if from != to:
		var ps: PoolVector2Array = path_finder.get_point_path(from, to)
		for p in ps:
			path.push_back(path_finder.map.map_to_world(p))
	return path