extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_backButton_pressed():
	$hover.play(0.1)
	if (!("Start" in PlayerData.current_scene.instance().name)):
		get_tree().change_scene("res://src/Screens/DeathScreen.tscn")
	else:
		get_tree().change_scene("res://src/Screens/StartMenu.tscn")
	pass
#	get_tree().change_scene_to("res://src/Levels/LevelTemplate.tscn")
