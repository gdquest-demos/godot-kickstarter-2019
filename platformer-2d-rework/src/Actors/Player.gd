extends Actor

class_name Player

onready var ray: RayCast2D = $PlatformDetector
onready var sprite: Sprite = $Sprite
onready var sound_shoot: AudioStreamPlayer2D = $SoundShoot
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var gun_position: Position2D = $Sprite/GunPosition

const BULLET_VELOCITY := 1000.0
const SHOOT_TIME_SHOW_WEAPON := 0.2

var _current_animation := ""
var _shoot_time := 99.0 # time since last shot

var Bullet = preload("res://src/Objects/Bullet.tscn")


func _physics_process(delta):
	_shoot_time += delta

	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var is_snapping: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	var is_on_platform: = ray.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, is_snapping, FLOOR_NORMAL, not is_on_platform, 4,  0.9, false
	)

	### Shooting
	if Input.is_action_just_pressed("shoot"):
		var bullet = Bullet.instance()
		bullet.position = gun_position.global_position # use node for shoot position
		bullet.linear_velocity = Vector2(sprite.scale.x * BULLET_VELOCITY, 0)
		bullet.add_collision_exception_with(self) # don't want player to collide with bullet
		get_parent().add_child(bullet) # don't want bullet to move with me, so add it as child of parent
		sound_shoot.play()
		_shoot_time = 0

	### Animation
	var new_animation = "idle"
	
	if abs(direction.x) > 0:
		sprite.scale.x = direction.x
	
	if is_on_floor():
		if abs(_velocity.x) > 0:
			new_animation = "run"
	else:
		
		if _velocity.y > 0:
			new_animation = "falling"
		else:
			new_animation = "jumping"

	if _shoot_time < SHOOT_TIME_SHOW_WEAPON:
		new_animation += "_weapon"

	if new_animation != _current_animation:
		_current_animation = new_animation
		animation_player.play(new_animation)


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	
	return velocity
