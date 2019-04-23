extends KinematicBody

export var player_two : bool = false
export var move_speed : float = 20.0
export var gravity : float = 100.0
export var jump_force : float = 25.0

var current_gavity : = 0.0
var actions : = {
	"move_left": "move_left",
	"move_right": "move_right",
	"jump": "jump"
}


func _ready() -> void:
	if player_two:
		for action in actions:
			actions[action] += "_2"


func _physics_process(delta: float) -> void:
	var motion : = Vector3()
	motion.x = int(Input.get_action_strength(actions.move_right)) - int(Input.get_action_strength(actions.move_left))
	
	if not is_on_floor():
		current_gavity -= gravity * delta
	elif Input.is_action_just_pressed(actions.jump):
		current_gavity = jump_force
	
	var velocity = motion.normalized() * move_speed
	velocity.y = current_gavity
	
	move_and_slide(velocity, Vector3.UP)
