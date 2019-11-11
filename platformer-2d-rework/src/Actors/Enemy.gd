extends Actor

class_name Enemy

onready var sprite: Sprite = $Sprite
onready var animation_player: AnimationPlayer = $AnimationPlayer

onready var DetectFloorLeft: RayCast2D = $DetectFloorLeft
onready var DetectFloorRight: RayCast2D = $DetectFloorRight

enum State {WALKING, DEAD}

var state = State.WALKING

var _current_animation := ""


func _ready():
	_velocity.x = -speed.x


func _physics_process(delta):
	
	_velocity.x *= -1 if is_on_wall() or not DetectFloorLeft.is_colliding() or not DetectFloorRight.is_colliding() else 1

	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	
	sprite.scale.x = 1 if _velocity.x > 0 else -1
	
	var new_animation = "idle"

	if state == State.WALKING:
		new_animation = "walk"
	else:
		_velocity = Vector2.ZERO
		new_animation = "explode"

	if _current_animation != new_animation:
		_current_animation = new_animation
		animation_player.play(_current_animation)


func hit_by_bullet():
	state = State.DEAD
