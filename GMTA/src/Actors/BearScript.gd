extends Animals


func _ready():
	speed = 20
	_velocity.x = speed * dir
	player = get_tree().get_nodes_in_group("player")[0]
	assert(player!=null)
	.add_to_group("enemies")
	this_health=7


