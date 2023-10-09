extends Button


export(String, FILE) var next_scene_path: = ""

func _on_PlayButton_button_up():
	PlayerData.set_current_scene(load(next_scene_path))
	

func _get_configuration_warning() -> String:
	return "next_scene_path not set" if next_scene_path == "" else ""
