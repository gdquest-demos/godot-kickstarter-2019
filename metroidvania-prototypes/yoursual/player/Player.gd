extends KinematicBody2D
class_name Player

onready var components : Node = $Components

export var move_speed := 750
export var jump_force := 1200
export var gravity := 2000
export var acceleration := 2.5
export var deceleration := 7.5

var velocity := Vector2()
var direction_x := 1


func _ready() -> void:
	GlobalEvents.connect("component_unlocked", self, "_on_GlobalEvents_component_unlocked")
	for component in $Components.get_children():
		component.initialize(self)


func _physics_process(delta: float) -> void:
	direction_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var desired_x_velocity = direction_x * move_speed
	var weight = deceleration * delta if desired_x_velocity == 0 else acceleration * delta
	velocity.x = lerp(velocity.x, desired_x_velocity, weight)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_GlobalEvents_component_unlocked(component: Component) -> void:
	components.add_child(component)
	component.initialize(self)


func damage(value: int) -> void:
	#TODO: Implement damage + animations
	pass