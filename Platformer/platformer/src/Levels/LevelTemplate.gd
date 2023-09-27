extends Node2D

func _ready():
	$HUD.update_score()
	

func _on_Player_coinCollected():
	PlayerData.score += 1
	$HUD.update_score()
