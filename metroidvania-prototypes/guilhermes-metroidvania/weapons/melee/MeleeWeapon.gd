extends Weapon

onready var sprite_pivot : Position2D = $SpritePivot
onready var hit_box : Area2D = $HitBox
onready var tween : Tween = $Tween

export var attack_range := 196

var direction := 1


func _ready() -> void:
	hit_box.connect("body_entered", self, "_on_HitBox_body_entered")


func _on_HitBox_body_entered(body: PhysicsBody2D) -> void:
	if body.is_a_parent_of(self):
		return
	if body is Enemy:
		body.damage(damage)
	elif body is Interactive:
		body.interact()


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("move_left"):
		direction = -1
		sprite_pivot.scale = Vector2(-1, 1)
	elif event.is_action_pressed("move_right"):
		direction = 1
		sprite_pivot.scale = Vector2(1, 1)


func _tween_weapon() -> void:
	tween.interpolate_property(self,
		"rotation_degrees",
		rotation_degrees,
		rotation_degrees + 125 * direction,
		0.3,
		Tween.TRANS_QUINT,
		Tween.EASE_IN)
	tween.interpolate_property(self,
		"rotation_degrees",
		rotation_degrees,
		0,
		0.3,
		Tween.TRANS_QUINT,
		Tween.EASE_IN_OUT,
		0.3)
	tween.start()


func use_weapon() -> void:
	.use_weapon()
	_tween_weapon()
	hit_box.position = Vector2(attack_range * attack_direction, 0)
	hit_box.active = true
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	hit_box.active = false
