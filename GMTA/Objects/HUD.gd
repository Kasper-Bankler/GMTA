extends CanvasLayer

onready var coin_sprite=$ScoreLabel/AnimatedSprite
onready var timer=$Timer
onready var time_stamp=$timeLabel
var count = 0


func update_score():
	$ScoreLabel.text = str(PlayerData.score)

func _ready():
	coin_sprite.play("default")

func _process(delta):
	time_stamp.text=str(stepify(PlayerData.time_elapsed, 0.01))

func _on_AnimatedSprite_animation_finished():
	count+=1
	if count>1:
		count=0
		coin_sprite.stop()
		timer.start()



func _on_Timer_timeout():
	coin_sprite.play("default")
