extends Animals


func _ready():
	speed = 20
	_velocity.x = speed * dir
	player = get_tree().get_nodes_in_group("player")[0]
	assert(player!=null)
	.add_to_group("enemies")
	if PlayerData.baby_mode:
		this_health=1
	else:
		this_health=7


