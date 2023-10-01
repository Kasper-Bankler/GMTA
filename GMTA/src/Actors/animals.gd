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
export var SPEED = 20

var FrontRay = Vector2(100,0)
var FrontUpRay = Vector2(70,-50)
var BackRay = Vector2(-50,0)
var BackUpRay = Vector2(-45,-35)

var isChasing = false
var isDead = false
var dir = 1
var goingRight = true 
var player = null

func _ready():
	_velocity.x = SPEED * dir

func detection():
	if Rray.is_colliding() and Rray.get_collider() == player:
		isChasing = true

	elif RUray.is_colliding() and RUray.get_collider() == player:
		isChasing=true
	
	elif Lray.is_colliding() and Lray.get_collider() == player:
		isChasing=true
	
	elif LUray.is_colliding() and LUray.get_collider() == player:
		isChasing=true

	elif Uray.is_colliding() and Uray.get_collider() == player:
		isChasing=true
	




func chase():
	if audioPlayerNoise.playing:
		if isDead:
			return

		
		if player.global_position.x-global_position.x < 0:
			anim.flip_h = true
			anim.play("walk",2)
			_velocity.x = global_position.direction_to(player.global_position).x*SPEED*3
			
		elif player.global_position.x-global_position.x > 0:
			anim.flip_h = false
			anim.play("walk",2)
			_velocity.x = global_position.direction_to(player.global_position).x*SPEED*3	
		if (player.global_position-global_position).length() < 50:
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
	if !platformRay.is_colliding() and is_on_floor() or is_on_wall():
		if goingRight:
			dir = 1
			anim.flip_h = false
			Rray.cast_to = Vector2(100,0)
			RUray.cast_to = Vector2(70,-50)
			Lray.cast_to = Vector2(-50,0)
			LUray.cast_to = Vector2(-45,-35)
			platformRay.position.x = 20
			_velocity.x = SPEED * dir
			anim.play("walk")
			goingRight = false
		elif !goingRight:
			dir = -1
			_velocity.x = SPEED * dir
			anim.flip_h = true
			Rray.cast_to = Vector2(50,0)
			RUray.cast_to = Vector2(45,-35)
			Lray.cast_to = Vector2(-100,0)
			LUray.cast_to = Vector2(-70,-50)
			platformRay.position.x = -20
			anim.play("walk")
			goingRight = true


func _on_Timer_timeout():
	if isDead:
		return
	if goingRight:
		dir = 1
		anim.flip_h = false
		Rray.cast_to = FrontRay
		RUray.cast_to = FrontUpRay
		Lray.cast_to = BackRay
		LUray.cast_to = BackUpRay
		_velocity.x = SPEED * dir
		anim.play("walk")
		goingRight = false
	elif goingRight == false:
		dir = -1
		_velocity.x = SPEED * dir
		anim.flip_h = true
		Rray.cast_to = BackRay
		RUray.cast_to = Vector2(-FrontUpRay.x,FrontUpRay.y)
		Lray.cast_to = FrontRay
		LUray.cast_to = Vector2(-BackUpRay.x,BackUpRay.y)
		anim.play("walk")
		goingRight = true
