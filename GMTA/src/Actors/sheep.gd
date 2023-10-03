extends Actor

onready var anim = $AnimatedSprite
onready var collisionShape = $CollisionShape2D
onready var audioPlayerDeath = $AudioStreamDeath
onready var audioPlayerSheep = $AudioStreamSheep
onready var audioPlayerLamb = $AudioStreamLamb
onready var platformRay = $PlatformRayCast

export var this_health=1

var isChasing = false
var isDead = false
var dir = 1
const SPEED = 20.0
var standing=false
var goingRight = true 
var rng = RandomNumberGenerator.new()
# Get the gravity from the project settings to be synced with RigidBody nodes.

var timeNum
var player = null

func _ready():
	timeNum = rng.randi_range(0,10)
	$Timer.start(timeNum)
	anim.play("walk")
	player = get_tree().get_nodes_in_group("player")[0]
	assert(player!=null)
	add_to_group("enemies")

func _physics_process(delta):
	walk()
	if this_health<1:
		dead()
		isDead=true
	if isDead:
		return
	if not is_on_floor():
		_velocity.y += 90 * delta
	
	move_and_slide(_velocity, FLOOR_NORMAL)


func dead():
	if (not isDead):
		print("death")
		PlayerData.sheep_deaths += 1
		audioPlayerSheep.stop()
		audioPlayerLamb.stop()
		audioPlayerDeath.play()
		remove_from_group("enemies")
		collisionShape.queue_free()
		isDead=true
		scale *= 2
		anim.play("death")

func take_damage(damage):
	this_health-=damage
		
func _on_AnimatedSprite_animation_finished():
	if (anim.animation=="death"):
		print("free")
		queue_free()

func walk():
	if !platformRay.is_colliding() or is_on_wall():
		if goingRight:
			dir = 1
			anim.flip_h = false
			_velocity.x = SPEED * dir
			anim.play("walk")
			goingRight = false
			platformRay.position.x = 15
			print("working!!!")
		elif !goingRight:
			dir = -1
			_velocity.x = SPEED * dir
			anim.flip_h = true
			anim.play("walk")
			goingRight = true
			platformRay.position.x = -15
			print("working!!!")


func _on_Timer_timeout():
	if isDead:
		return
 #idk man
	if scale.x < 1:
		anim.play("idle")
		_velocity.x = 0
		audioPlayerLamb.play()
		
		return
	elif scale.x > 1:
		anim.play("idle")
		_velocity.x = 0
		audioPlayerSheep.play()
		print(timeNum)
		$Timer.start(timeNum)
		return
	else:
		walk()
