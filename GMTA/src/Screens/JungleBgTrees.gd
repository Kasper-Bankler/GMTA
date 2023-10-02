extends Sprite
export var speed=15
export var index=1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite=$"../AnimatedSprite"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if (position.x>1500):
		position.x=-1500
	if (!sprite.standing):
		position.x+=speed*delta
