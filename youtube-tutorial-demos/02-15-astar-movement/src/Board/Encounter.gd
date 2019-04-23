extends Area2D
"""
An object with which the Party (Player) can interact on the Board.

It doesn't do anything other than play an animation when Party leader is adjacent to it
and send signals to other systems. Its purpose is to be detected by the Party leader.

Check Party, Member & Walk behavior scripts for more information on being Detected.

Notes
-----
For future proof, this Node is added to "encounters" group. This is used when trying to detect
encounters in Members' Walk behavior to potentially distinguish from other Area2D object types.
"""


onready var animation_player: AnimationPlayer = $AnimationPlayer

var _has_encountered_party: = false


func _ready() -> void:
	connect("input_event", self, "_on_Area_input_event")
	connect("mouse_entered", Events, "emit_signal", ["encounter_probed", {encounter_probed = self}])
	connect("mouse_exited", Events, "emit_signal", ["encounter_probed", {encounter_probed = null}])
	Events.connect("party_member_walk_started", self, "_on_signal", ["started"])
	Events.connect("party_member_walk_finished", self, "_on_signal", ["finished"])


func _on_Area_input_event(viewport: Node, event: InputEvent, idx: int) -> void:
	if event.is_action_pressed("tap") and _has_encountered_party:
		animation_player.seek(0, true) # seems that stop() isn't enough
		animation_player.stop()


func _on_signal(msg: Dictionary = {}, which: String = "") -> void:
	match which:
		"started":
			_has_encountered_party = false
			animation_player.play("<BASE>")
		"finished":
			match msg:
				{"is_leader": true, "encounter": var encounter}:
					_has_encountered_party = encounter == self
					(animation_player.play("dialog_bubble")
					if _has_encountered_party
					else animation_player.play("<BASE>"))