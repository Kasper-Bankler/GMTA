extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var change=false
var timer
var standing=false
# Called when the node enters the scene tree for the first time.
func _ready():
	timer=$Timer
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if change:
		play("idle")
		standing=true
		timer.start(2)
	else:
		timer.start(5)
		play("walk")
		standing=false
	change=!change
