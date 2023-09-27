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



func _on_Timer_timeout():
	if isDead:
		return
	if goingRight:
		dir = 1
		anim.flip_h = false
		Rray.cast_to = Vector2(100,0)
		RUray.cast_to = Vector2(70,-50)
		Lray.cast_to = Vector2(-50,0)
		LUray.cast_to = Vector2(-45,-35)
		_velocity.x = SPEED * dir
		anim.play("walk")
		goingRight = false
		$Timer.start(timerTime)
	elif goingRight == false:
		dir = -1
		_velocity.x = SPEED * dir
		anim.flip_h = true
		Rray.cast_to = Vector2(50,0)
		RUray.cast_to = Vector2(45,-35)
		Lray.cast_to = Vector2(-100,0)
		LUray.cast_to = Vector2(-70,-50)
		anim.play("walk")
		goingRight = true
		$Timer.start(timerTime)
