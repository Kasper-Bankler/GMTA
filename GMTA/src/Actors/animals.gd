extends Actor 
class_name Animals

onready var anim = $AnimatedSprite
onready var Rray = $RightRayCast
onready var RUray = $RightUpRayCast
onready var Lray = $LeftRayCast
onready var LUray = $LeftUpRayCast
onready var Uray = $UpRayCast
onready var platformRay = $platformRayCast
onready var collisionShape = $CollisionShape2D
onready var audioPlayerExplode = $AudioStreamExplode
onready var audioPlayerNoise = $AudioStreamNoise

export var this_health=7
export var damage=30
export var vision = 1


var FrontRay = Vector2(100,0)
var FrontUpRay = Vector2(70,-50)
var BackRay = Vector2(-50,0)
var BackUpRay = Vector2(-45,-35)

var isChasing = false
var isDead = false
var dir = 1
var goingRight = true 
var player = null


func _physics_process(delta):
	if this_health<1:
		dead()
		isDead=true
	if isDead:
		return
	
	detection()
	
	if isChasing and is_on_floor():
		chase()
	if !platformRay.is_colliding() or is_on_wall():
		flip()
	if !isChasing and is_on_floor():
		walk()
	if not is_on_floor():
		_velocity.y += 90 * delta
	
	
	move_and_slide(_velocity, FLOOR_NORMAL)


func detection():
	isChasing = (
		Rray.get_collider() == player or
		RUray.get_collider() == player or
		Lray.get_collider() == player or
		LUray.get_collider() == player or
		Uray.get_collider() == player
	)


func chase():
	if audioPlayerNoise.playing:
		if isDead:
			return

		anim.play("walk",2)
		if player.global_position.x-global_position.x < 0:
			anim.flip_h = true
		
		elif player.global_position.x-global_position.x > 0:
			anim.flip_h = false	
		
		_velocity.x = global_position.direction_to(player.global_position).x*speed.x*3
		if (player.global_position-global_position).length() < 50*scale.x:
			PlayerData.take_damage(damage)
			dead()
	else:
		audioPlayerNoise.play()
		

func take_damage(damage):
	if !isChasing:
		isChasing=true
	this_health-=damage
		

func dead():
	if (not isDead):
		position.y -= 70
		audioPlayerNoise.stop()
		.remove_from_group("enemies")
		collisionShape.queue_free()
		isDead=true
		scale *= 5
		
		audioPlayerExplode.stop()

		audioPlayerExplode.play()
		anim.play("explode")


func _on_AnimatedSprite_animation_finished():
	if (anim.animation=="explode"):
		queue_free()

func walk():
	anim.play("walk")
	_velocity.x = speed.x * dir

func flip():
	goingRight = !goingRight
	if goingRight:
		dir = 1
		Rray.cast_to = FrontRay * vision
		RUray.cast_to = FrontUpRay * vision
		Lray.cast_to = BackRay * vision
		LUray.cast_to = BackUpRay * vision
	elif !goingRight:
		dir = -1
		#kumalala kumalala kumala savesta
		Rray.cast_to = BackRay * vision * dir
		RUray.cast_to = Vector2(-BackUpRay.x, BackUpRay.y) * vision
		Lray.cast_to = FrontRay * vision * dir
		LUray.cast_to = Vector2(-FrontUpRay.x, BackUpRay.y) * vision
	platformRay.position.x = 20 * dir
	anim.flip_h = !goingRight

