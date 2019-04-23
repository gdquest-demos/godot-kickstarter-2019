extends Node2D
"""
DEMO	TileMap based AStar movement
		This example puts together non-trivial interactions between systems and deeply nested nodes
		following GDquest's GDScript coding guidelines and best practices in order to maintain
		an organized code base through decoupling.

The root main scene node, Game, ties together top level components & systems.

Game waits for user input and calculates a valid position (via mouse tap) or move direction
(via keybaoard). It then tries to move the Party to the calculated destination. It doesn't do
anything itself, it just preapares the path (Vector2 Array) which is used in the underlying
components.

Board: path finding, the TileMaps, encounters, and mouse feedback.
Party: can be viewed as the player. The party contains members (who extend Actor) with attached
       behaviors.

Check child nodes attached scripts for further details on each component.

Notes
-----
Apart from the Behavior nodes attached to the Party members (Godette, Robi1, Robi2), all other
scenes can be run individually (F6) without any errors. This is due to following the GDquest coding
guidelines which focuses on practices for decoupling code. The Behavior nodes are special because,
like the built-in AnimationPlayer node, they depend on their parent. Check NoOpBehavior.gd, Bump.gd
& Walk.gd for details and examples of this pattern.
"""


const DRAW_OFFSET: = Vector2(40, 60)
const DRAW_COLOR: = Color("#0C5E86")
const DRAW_WIDTH: = 5.0

onready var board: Node2D = $Board
onready var party: YSort = $Party

var encounter_near_party: Area2D = null
var encounter_under_mouse: Area2D = null
var draw_path: = [] setget set_draw_path


func _ready() -> void:
	Events.connect("encounter_probed", self, "_on_signal")
	Events.connect("party_member_walk_finished", self, "_on_signal")
	party.setup(board.size, board.path_finder.map.cell_size)


func _draw() -> void:
	if not draw_path.empty():
		draw_polyline(draw_path, DRAW_COLOR, DRAW_WIDTH, true)


func _unhandled_input(event: InputEvent) -> void:
	var leader: Actor = party.get_member(0)
	var move_direction: = Utils.get_direction(event)
	if event.is_action_pressed("tap"):
		party_command({tap_position = board.get_global_mouse_position()})
	elif (Utils.any_action_just_pressed(["ui_left", "ui_up", "ui_right", "ui_down"])
			and move_direction != Utils.V2_00 and not leader.is_walking):
		party_command({move_direction = move_direction})


func _on_signal(msg: Dictionary = {}) -> void:
	match msg:
		{"is_leader": true, "encounter": var encounter}:
			encounter_near_party = encounter
		{"encounter_probed": var encounter}:
			encounter_under_mouse = encounter

"""
Gives the walk order to the appropriate party members.

It either moves all members or moves only the leader if the position is already occupied by another
character.
"""
func party_command(msg: Dictionary = {}) -> void:
	var leader: Actor = party.get_member(0)
	if (leader == null
			and not "tap_position" in msg
			or encounter_under_mouse != null
			and encounter_near_party == encounter_under_mouse):
		return
	
	var path: = prepare_path(leader, msg)
	var destination: = get_party_destination(leader, path)
	var swapped: = try_swapping_party_members(leader, destination)
	if not swapped and party.get_member_by_position(destination) == null:
		members_walk(leader, path)
		set_draw_path(path)


"""
Based on the input message Dictionary (msg) that holds information either about the mouse tap
position or the direction to move into, in case the keyboard was used, it calculates a path if
possible. The path starts with `leader.position` and ends at `tap_position` if mouse is used or
`leader.position + move_direction` if keyboard is used.

Returns a Vector2 Array of path points if succesful, otherwise it resturns an empty Array.
"""
func prepare_path(leader: Actor, msg: Dictionary = {}) -> Array:
	var path: = []
	match msg:
		{"tap_position": var tap_position}:
			tap_position = adjust_tap_position(leader.position, tap_position)
			path = board.get_point_path(leader.position, tap_position)
			if not path.empty():
				path[0] = leader.position
		{"move_direction": var move_direction}:
			if move_direction in board.path_finder.possible_directions:
				var from: Vector2 = leader.position
				var to: = from + Utils.to_px(move_direction, board.path_finder.map.cell_size)
				if not board.path_finder.map.world_to_map(to) in board.path_finder.map.obstacles:
					path.push_back(from)
					path.push_back(to)
	return path


"""
Adjusts `tap_position` if tap takes place on an encounter.

Because encounters are treated as obstacles and thus the path finder can't find a path to an obstacle,
`tap_position` is calculated to a valid cell position near the tapped encounter, closest to the leader position.
This way, clicking on an encounter is valid and the party moves to a reasonable position so that it can interact
with the respective encounter.

Returns the Vector2 adjusted `tap_position` if tap takes place over an encounter.
"""
func adjust_tap_position(leader_position: Vector2, tap_position: Vector2) -> Vector2:
	var n: = (leader_position - tap_position).normalized()
	var min_angle: = INF
	var selected_dir: = Utils.V2_00
	if encounter_under_mouse != null:
		for dir in Utils.CARDINAL_DIRECTIONS:
			var angle: = abs(n.angle_to(dir))
			if min_angle > angle:
				min_angle = angle
				selected_dir = dir
		tap_position = encounter_under_mouse.position + board.path_finder.map.cell_size * selected_dir
	return tap_position


"""
Moves the Party if possible. It first checks too ensure `destination` doesn't overlap with
Party Members. If `destination` does overlap with a Party Member then the leader just swappes
with the other Member.

Returns the extracted `destination` from `path`.
"""
func get_party_destination(leader: Actor, path: Array) -> Vector2:
	var destination: Vector2 = path[path.size() - 1] if not path.empty() else Utils.V2_00
	return destination


"""
Checks for `destination` overlap with another Party Member. If it does, it swappes the `leader`
with the other Party Member.

It returns `true` if swap succeds, otherwise `false`.
"""
func try_swapping_party_members(leader: Actor, destination: Vector2) -> bool:
	var swapped = false
	if not leader.is_walking:
		var other: Actor = party.get_member_by_position(destination)
		if other != null and other != leader and party.get_member_count() != 1:
			leader.walk([leader.position, other.position])
			other.walk([other.position, leader.position])
			swapped = true
	return swapped


"""
Given the `path` it orders the Party Members to walk.
"""
func members_walk(leader: Actor, path: Array) -> void:
	for member in party.get_members():
		if member != leader:
			path = [member.position] + path
			path.pop_back()
		member.walk(path)


func set_draw_path(values: Array) -> void:
	var leader: Actor = party.get_member(0)
	draw_path = []
	for point in values:
		draw_path.push_back(point + DRAW_OFFSET)
	if not draw_path.empty():
		update()