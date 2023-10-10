extends Control
#ali er sej big cap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var next_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerData.reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Give_up_pressed():
	$hover.play(0.01)
	get_tree().quit()


func _on_Start_pressed():
	
	$hover.play(0.1)
	PlayerData.playing=true
	PlayerData.set_current_scene(next_scene)
	

func _on_Tutorial_pressed():
	$hover.play(0.1)
	get_tree().change_scene_to(preload("res://src/Screens/TutorialScene.tscn"))


func _on_CheckButton_toggled(button_pressed):
	PlayerData.baby_mode=button_pressed
