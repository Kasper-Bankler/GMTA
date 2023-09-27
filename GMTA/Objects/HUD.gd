extends CanvasLayer

func update_score():
	$ScoreLabel.text = str(PlayerData.score)
