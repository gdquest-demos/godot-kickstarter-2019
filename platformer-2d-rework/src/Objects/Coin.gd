extends Area2D
class_name Coin


onready var animation_player: AnimationPlayer = $AnimationPlayer


"""
If a body comes in contact with the Coin, we play the animation
that will remove it from the game.

The Coins only look for collisions on the Player layer as shown in the
collision mask.

This prevents other characters such as enemies picking them up.

We set monitoring to false in the picked animation so the Coin isn't picked up again.
"""
func _on_body_entered(body: PhysicsBody2D):
	picked()


func picked() -> void:
	animation_player.play("picked")
