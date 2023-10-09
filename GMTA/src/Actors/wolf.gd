extends Animals



func _ready():
	speed = 40
	_velocity.x = speed * dir
	player = get_tree().get_nodes_in_group("player")[0]
	assert(player!=null)
	.add_to_group("enemies")
	this_health=5


