tool
extends Area2D

onready var anim_player: AnimationPlayer = $AnimationPlayer

export var next_scene: PackedScene
export var last_portal_bool=false

func _on_body_entered(body):
	if body.is_in_group("player"):
		if last_portal_bool:
			PlayerData.playing=false
		teleport()


#Giver en fejlmeddelelse hvis next_scene mangler
func _get_configuration_warning():
	return "The next scene property can't be empty" if not next_scene else ""

func teleport():
	$PortalSound.play(1)
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	PlayerData.set_current_scene(next_scene)
