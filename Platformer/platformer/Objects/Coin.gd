extends Area2D
var collected=false
#Opretter en referance til animation player noden
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var animated_sprite = $AnimatedSprite

func _on_body_entered(body):
	if body.is_in_group("player") and !collected:
		collected=true
		$AudioStreamPlayer.play(0.4)
		anim_player.play("fade_out")
