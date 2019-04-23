extends KinematicBody2D

const FLOOR_NORMAL: = Vector2(0, -1)

export var speed_normal: = 400.0
export var speed_sprint: = 700.0
export var jump_force: = 900.0
export var gravity: = 3600.0

var _velocity: = Vector2()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and is_on_floor():
		_velocity.y -= jump_force


func _physics_process(delta):
	var move_direction: = get_move_direction()
	var speed: = speed_sprint if Input.is_action_pressed("sprint") else speed_normal
	_velocity.x = move_direction * speed
	_velocity.y += gravity * delta
	var resulting_velocity: = move_and_slide(_velocity, FLOOR_NORMAL)
	_velocity.y = resulting_velocity.y


func get_move_direction() -> float:
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
