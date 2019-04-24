extends Component

export var double_jump_force := 1000.0

var can_double_jump = false


func _physics_process(delta: float) -> void:
	if can_double_jump and Input.is_action_just_pressed("jump"):
		player.velocity.y = -double_jump_force
		can_double_jump = false
	elif not can_double_jump and not player.is_on_floor():
		can_double_jump = true
	elif player.is_on_floor():
		can_double_jump = false
