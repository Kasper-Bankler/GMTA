extends Actor

onready var anim = $AnimatedSprite
onready var Rray = $RightRayCast
onready var RUray = $RightUpRayCast
onready var Lray = $LeftRayCast
onready var LUray = $LeftUpRayCast
onready var Uray = $UpRayCast
onready var collisionShape = $CollisionShape2D
onready var audioPlayerExplode = $AudioStreamExplode
onready var audioPlayerBear = $AudioStreamBear
export var timerTime = 3
export var this_health=7

export var damage=30
var isChasing = false
var isDead = false
var dir = 1
const SPEED = 20.0
var goingRight = true 
# Get the gravity from the project settings to be synced with RigidBody nodes.

var player = null

func _ready():
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


func detection():
	if Rray.is_colliding() and Rray.get_collider() == player:
		isChasing = true
		$Timer.stop()
	elif RUray.is_colliding() and RUray.get_collider() == player:
		isChasing=true
		$Timer.stop()
	elif Lray.is_colliding() and Lray.get_collider() == player:
		isChasing=true
		$Timer.stop()
	elif LUray.is_colliding() and LUray.get_collider() == player:
		isChasing=true
		$Timer.stop()
	elif Uray.is_colliding() and Uray.get_collider() == player:
		isChasing=true
		$Timer.stop()
			


func chase():
	if audioPlayerBear.playing:
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
		audioPlayerBear.play()
		

func take_damage(damage):
	if !isChasing:
		isChasing=true
	this_health-=damage
		

func dead():
	if (not isDead):
		position.y -= 70
		audioPlayerBear.stop()
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
