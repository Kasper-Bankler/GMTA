extends Animals

func _ready():
	speed.x = 15
	_velocity.x = speed.x * dir
	player = get_tree().get_nodes_in_group("player")[0]
	assert(player!=null)
	.add_to_group("enemies")
	this_health=3
