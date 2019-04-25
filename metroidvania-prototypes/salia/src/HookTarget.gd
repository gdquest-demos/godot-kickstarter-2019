extends Area2D


onready var selection: Line2D = $Selection


func _ready() -> void:
	connect("body_entered", self, "_on_body", ["enter"])
	connect("body_exited", self, "_on_body", ["exit"])


func _on_body(body: PhysicsBody2D, which: String) -> void:
	if body.name == "Player":
		body.hook_targets.push_back(self) if which == "enter" else body.hook_targets.erase(self)
		body.hook_target_idx = 0 if body.hook_targets.size() == 1 else body.hook_target_idx
		selection.visible = false if which == "exit" else selection.visible