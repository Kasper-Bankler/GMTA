extends Control

onready var label: Label = get_node("Label")


func _ready() -> void:
	label.text = label.text % [PlayerData.score, PlayerData.deaths, PlayerData.sheep_deaths, stepify(PlayerData.time_elapsed, 0.001)]
	
