extends Behavior
"""
Walk behavior that linearly moves `root_node` at the speed of the walk animation.

It also detects for encounters at the end of the walk. Only the leader node should have the
Detect scene attached as a Node. This is done in the `setup(detect, remote_transofrm)` function
from Member script.
"""


onready var tween: Tween = $Tween
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var timer: Timer = $Timer

const SPEED: = 400

var _rng: = RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	timer.connect("timeout", self, "_on_Timer_timeout")


func _on_Timer_timeout() -> void:
	root_node.is_walking = false
	animation_player.play("<BASE>")
	Events.emit_signal(
			"party_member_walk_finished",
			{is_leader = root_node.is_leader, encounter = which_encounter()})


func setup() -> void:
	animation_player.root_node = root_node.get_path()


func run(msg: Dictionary = {}) -> void:
	if not "path" in msg:
		return
	
	timer.stop()
	tween.remove_all()
	
	Events.emit_signal(
			"party_member_walk_started",
			{is_leader = root_node.is_leader, destination = msg.path[len(msg.path) - 1]})
	root_node.is_walking = true
	animation_player.play("walk")
	animation_player.seek(_rng.randf_range(0, 0.5 * animation_player.current_animation_length))
	
	# prepare all interpolations for given path, with appropriate delays (`wait_time`) in order
	# to easily start/stop one tween process so that moving while walking is also possible
	var wait_time: = 0.0
	for i in range(msg.path.size() - 1):
		var time: float = (msg.path[i + 1] - msg.path[i]).length()/SPEED
		tween.interpolate_property(
				root_node, "position",
				msg.path[i], msg.path[i + 1], time,
				Tween.TRANS_LINEAR, Tween.EASE_IN, wait_time)
		wait_time += time
	timer.wait_time = wait_time
	
	timer.start()
	tween.start()


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