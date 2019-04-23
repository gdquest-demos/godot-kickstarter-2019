extends Actor
"""
This is a Party Member, part of the Player Party "pack".

It extends actor so it can use Behaviors. By default it has a Walk behavior apart from the NoOp
behavior which all Actors have. The Party leader (that is. the child node of Party with index
position 0) also has a Bump behavior. This is configured in `setup`.
"""


onready var is_leader: = get_index() == 0
onready var board_skin: Sprite = $Board/Skin
onready var detect: Node2D = $Detect if is_leader else null

const BehaviorBump: = preload("res://src/Party/Behaviors/Bump.tscn")
const SKIN: = preload("res://assets/sprites/characters/godette.png")

var is_walking: = false


"""
Boilerplate for setting up appropriate node relationships with leader. It also claculates proper
sprite placement on map so they allign to the "ground". The leader gets to have a star sprite
visible: LeaderIcon, so it's distinguished on the Board.
"""
func setup(board_size: Vector2) -> void:
	board_skin.offset.y = 0.5 * (SKIN.get_height() - board_skin.texture.get_height())
	if is_leader:
		var camera: Camera2D = $Board/Camera
		camera.limit_right = board_size.x
		camera.limit_bottom = board_size.y
	register(BehaviorBump.instance()) if is_leader else unregister(get_behavior("bump"))


func walk(path: Array) -> void:
	get_behavior("bump").run() if path.empty() else get_behavior("walk").run({path = path})