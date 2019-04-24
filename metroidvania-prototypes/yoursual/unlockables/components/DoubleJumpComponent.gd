extends Component

export var double_jump_force := 1000.0

var can_double_jump = false

var jumps = 0


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jumps += 1
		if jumps == 2:
			player.velocity.y = -double_jump_force
	elif player.is_on_floor():
		jumps = 0
