extends CanvasLayer

onready var coin_sprite=$ScoreLabel/AnimatedSprite

func update_score():
	$ScoreLabel.text = str(PlayerData.score)

func _ready():
	coin_sprite.play("default")



func _on_AnimatedSprite_animation_finished():
	$ScoreLabel/Timer.start()



func _on_Timer_timeout():
	coin_sprite.play("default")
