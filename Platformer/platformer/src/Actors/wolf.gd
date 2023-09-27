extends Actor

onready var anim = $AnimatedSprite
onready var Rray = $RightRayCast
onready var RUray = $RightUpRayCast
onready var Lray = $LeftRayCast
onready var LUray = $LeftUpRayCast
onready var Uray = $UpRayCast
onready var collisionShape = $CollisionShape2D
onready var audioPlayerExplode = $AudioStreamExplode
onready var audioPlayerWolf = $AudioStreamWolf
export var timerTime = 3
export var this_health=5

var isChasing = false
var isDead = false
var dir = 1
var damage=20
const SPEED = 40.0
var goingRight = true 
export var scaleVis = 5.0
var frontVis = Vector2(100,0)
var frontUpVis = Vector2(70,-50)
var upVis = Vector2(20,0)
var backVis = Vector2(-40,0)
var backUpVis = Vector2(-35,-25)
# Get the gravity from the project settings to be synced with RigidBody nodes.

var player = null

func _ready():
	Uray.cast_to=upVis*scaleVis
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
	
	if !isChasing:
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
	audioPlayerWolf.play()
			
			


func chase():
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
		
	

func dead():
	if (not isDead):
		print("wolf dead")
		position.y -= 70
		audioPlayerExplode.stop()
		audioPlayerWolf.stop()
		.remove_from_group("enemies")
		collisionShape.queue_free()
		isDead=true
		scale *= 5
		audioPlayerExplode.play()
		anim.play("explode")


func _on_AnimatedSprite_animation_finished():
	if (anim.animation=="explode"):
		
		queue_free()


func take_damage(damage):
	if !isChasing:
		isChasing=true
	this_health-=damage


func _on_Timer_timeout():
	if isDead:
		return
	if goingRight:
		dir = 1
		anim.flip_h = false
		Rray.cast_to = frontVis * scaleVis
		RUray.cast_to = frontUpVis * scaleVis
		Lray.cast_to = backVis * scaleVis
		LUray.cast_to = backUpVis * scaleVis
		_velocity.x = SPEED * dir
		anim.play("walk")
		goingRight = false
		$Timer.start(timerTime)
	elif goingRight == false:
		dir = -1
		_velocity.x = SPEED * dir
		anim.flip_h = true
		Rray.cast_to = -backVis * scaleVis
		RUray.cast_to = Vector2(-backUpVis.x, backUpVis.y) * scaleVis
		Lray.cast_to = -frontVis * scaleVis
		LUray.cast_to = Vector2(-frontUpVis.x, frontUpVis.y) * scaleVis
		anim.play("walk")
		goingRight = true
		$Timer.start(timerTime)


func _on_AudioStreamWolf_finished():
	if isChasing:
		audioPlayerWolf.play()
