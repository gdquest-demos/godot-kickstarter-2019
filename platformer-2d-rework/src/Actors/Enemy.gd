extends Actor

class_name Enemy

const STATE_WALKING = 0
const STATE_KILLED = 1

var anim = ""

# state machine
var state = STATE_WALKING

onready var DetectFloorLeft = $DetectFloorLeft
onready var DetectFloorRight = $DetectFloorRight

onready var sprite = $Sprite

func _ready():
	_velocity.x = -speed.x

func _physics_process(delta):
	
	_velocity.x *= -1 if is_on_wall() or not DetectFloorLeft.is_colliding() or not DetectFloorRight.is_colliding() else 1

	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	
	sprite.scale.x = 1 if _velocity.x > 0 else -1
	
	# TODO: Add separate StateMachine?
	
	var new_anim = "idle"

	if state == STATE_WALKING:
		new_anim = "walk"
	else:
		_velocity = Vector2.ZERO
		new_anim = "explode"

	if anim != new_anim:
		anim = new_anim
		($Anim as AnimationPlayer).play(anim)
	
func hit_by_bullet():
	state = STATE_KILLED
