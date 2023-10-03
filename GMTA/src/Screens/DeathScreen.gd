extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var next_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerData.playing=false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Give_up_pressed():
	
	$hover.play(0.01)
	get_tree().quit()


func _on_Tutorial_pressed():
	$hover.play(0.1)
	get_tree().change_scene_to(preload("res://src/Screens/TutorialScene.tscn"))

func _on_try_again_pressed():
	PlayerData.playing=true
	$hover.play(0.1)
	get_tree().change_scene_to(PlayerData.current_scene)

