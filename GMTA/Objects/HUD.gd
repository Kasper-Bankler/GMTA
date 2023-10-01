extends CanvasLayer

onready var coin_sprite=$ScoreLabel/AnimatedSprite

var count=0
func update_score():
	$ScoreLabel.text = str(PlayerData.score)

func _ready():
	coin_sprite.play("default")

func _process(delta):
	$Label.text=str(stepify(PlayerData.time_elapsed, 0.01))


func _on_AnimatedSprite_animation_finished():
	count+=1
	if count==2:
		coin_sprite.stop()
		$ScoreLabel/Timer.start()
		count=0



func _on_Timer_timeout():
	coin_sprite.play("default")
