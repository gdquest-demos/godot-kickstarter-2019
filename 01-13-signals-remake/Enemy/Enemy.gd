extends KinematicBody2D

onready var area : Area2D = $ActorDetector
onready var sprite : Sprite = $Body
onready var timer : Timer = $Timer

export var damage : = 5
export var move_speed : = 250.0
export var attack_distance : = 100.0
export var min_move_distance : = 80.0

var player : Player

func _ready() -> void:
	area.connect("body_entered", self, "_on_Area2D_body_entered")
	set_physics_process(false)


func _physics_process(delta : float) -> void:
	var direction : = (player.global_position - global_position).normalized()
	var distance_to_player : = global_position.distance_to(player.global_position)
	sprite.flip_h = direction.x < 0
	
	if distance_to_player >= min_move_distance:
		move_and_collide(direction * move_speed * delta)
	
	if timer.is_stopped() and distance_to_player <= attack_distance:
		player.take_damage(damage)
		timer.start()


func _on_Area2D_body_entered(body : PhysicsBody2D) -> void:
	if not body is Player:
		return
	player = body
	set_physics_process(true)
	area.disconnect("body_entered", self, "_on_Area2D_body_entered")
