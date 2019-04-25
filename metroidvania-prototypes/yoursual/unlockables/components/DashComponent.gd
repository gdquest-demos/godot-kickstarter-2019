extends Component

onready var delay_timer : Timer = $DelayTimer
onready var audio : AudioStreamPlayer = $Audio
onready var timeout_timer : Timer = $TimeoutTimer

export var delay := 1.25
export var distance := 350
export var timeout := 0.1


var dashing := false setget set_dashing
var speed := 0.0
var starting_position := Vector2()
var direction := 1


func _ready() -> void:
	speed = distance / timeout
	delay_timer.wait_time = delay
	timeout_timer.wait_time = timeout
	timeout_timer.connect("timeout", self, "_on_TimeoutTimer_timeout")
	set_physics_process(false)


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("dash") and delay_timer.is_stopped():
		dash()
	elif not dashing:
		if event.is_action_pressed("move_left"):
			direction = -1
		elif event.is_action_pressed("move_right"):
			direction = 1


func _physics_process(delta: float) -> void:
	if player.global_position.distance_to(starting_position) < distance:
		player.move_and_slide(Vector2(direction * speed, 0), Vector2.UP)
	else:
		self.dashing = false


func _on_TimeoutTimer_timeout() -> void:
	self.dashing = false


func dash() -> void:
	delay_timer.start()
	timeout_timer.start()
	starting_position = player.global_position
	self.dashing = true
	GlobalEvents.emit_signal("shake_requested", 0.3)
	audio.play()


func set_dashing(value: bool) -> void:
	dashing = value
	set_physics_process(dashing)
