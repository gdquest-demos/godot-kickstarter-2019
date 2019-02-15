extends Behavior
"""
Walk behavior that linearly moves `root_node` at the speed of the walk animation.

It also detects for encounters at the end of the walk. Only the leader node should have the
Detect scene attached as a Node. This is done in the `setup(detect, remote_transofrm)` function
from Member script.
"""


onready var tween: Tween = $Tween
onready var animation_player: AnimationPlayer = $AnimationPlayer

var _rng: = RandomNumberGenerator.new()
var _speed: float = 0.0


func setup() -> void:
	animation_player.root_node = root_node.get_path()
	_speed = animation_player.get_animation("walk").length


func run(msg: Dictionary = {}) -> void:
	if not "path" in msg:
		return

	Events.emit_signal(
			"party_member_walk_started",
			{is_leader = root_node.is_leader, destination = msg.path[len(msg.path) - 1]})
	root_node.is_walking = not root_node.is_walking
	animation_player.play("walk")
	animation_player.seek(_rng.randf_range(0, 0.5 * animation_player.current_animation_length))
	
	for i in range(msg.path.size() - 1):
		tween.interpolate_property(
				root_node, "position",
				msg.path[i], msg.path[i + 1], _speed,
				Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
	
	root_node.is_walking = not root_node.is_walking
	animation_player.play("<BASE>")
	Events.emit_signal(
			"party_member_walk_finished",
			{is_leader = root_node.is_leader, encounter = which_encounter()})


"""
Checks the four cardinal directions for Encounters.

Returns the Encounter if it could find it.
"""
func which_encounter() -> Area2D:
	var out: = null
	if root_node.is_leader:
		for ray in root_node.detect.get_children():
			var obj: Area2D = ray.get_collider()
			if obj != null and obj.is_in_group("encounters"):
				out = obj
				break
	return out


func _ready() -> void:
	_rng.randomize()