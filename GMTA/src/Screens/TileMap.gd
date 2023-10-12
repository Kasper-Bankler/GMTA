extends TileMap

export var speed=170
export var index=1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite=$"../AnimatedSprite"

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x=1000*index
	pass # Replace with function body.

func _process(delta):
	if (position.x>1000):
		position.x=-1100
	if (!sprite.standing):
		position.x+=speed*delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
