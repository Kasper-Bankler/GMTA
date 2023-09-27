extends "res://src/Actors/animals.gd"



func _ready():
	#Starter timer men bliver fjenet sene
	$Timer.start(timerTime)
	player = get_tree().get_nodes_in_group("player")[0]
	assert(player!=null)
	.add_to_group("enemies")

func _physics_process(delta):
	if this_health<1:
		dead()
		isDead=true
	if isDead:
		return
	
	detection()
	
	if isChasing and is_on_floor():
		chase()
	if not is_on_floor():
		_velocity.y += 90 * delta
	
	move_and_slide(_velocity, FLOOR_NORMAL)
