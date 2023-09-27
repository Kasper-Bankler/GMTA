extends Node

func _process(delta):
	get_node("../ProgressBar").value = PlayerData.health
