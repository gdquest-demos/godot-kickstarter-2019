extends KinematicBody2D

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

export var move_speed : = 50.0
export var player_two : = false

var actions : = {
	"move_up": "move_up",
	"move_down": "move_down",
	"move_left": "move_left",
	"move_right": "move_right",
}


func _ready() -> void:
	if player_two:
		animated_sprite.play("player_two")
		for action in actions:
			actions[action] += "_2"


func _physics_process(delta: float) -> void:
	var motion : = Vector2()
	motion.x = int(Input.get_action_strength(actions.move_right)) - int(Input.get_action_strength(actions.move_left))
	motion.y = int(Input.get_action_strength(actions.move_down)) - int(Input.get_action_strength(actions.move_up))
	move_and_collide(motion.normalized() * move_speed * delta)
