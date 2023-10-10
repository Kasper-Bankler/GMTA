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


var timeNum
var player = null

func _ready():
	rng.randomize()
	timeNum = rng.randi_range(5,15)
	
	$Timer.start(timeNum)
	anim.play("walk")
	add_to_group("enemies")

func _physics_process(delta):
	if isDead:
		return
		
	anim.flip_h = !goingRight
	if this_health<1:
		dead()
		isDead=true
	
	if not is_on_floor() and !isDead:
		_velocity.y += 90 * delta
		
		anim.play("idle")
	elif !platformRay.is_colliding() or is_on_wall():
		flip()
	if !standing and is_on_floor():
		walk()
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
	if isDead:
		return
	anim.play("walk")
	_velocity.x = SPEED * dir
	


func _on_Timer_timeout():
	if isDead:
		return
	print(timeNum)
	rng.randomize()
	timeNum = rng.randi_range(5,15)
	
	anim.play("idle")
	standing=true
	_velocity.x = 0
	playAudio()
	$Timer.start(timeNum)



func playAudio():
	if scale.x < 1:
		audioPlayerLamb.play()
	else:
		audioPlayerSheep.play()

func flip():
	if isDead:
		return
	goingRight = !goingRight
	if goingRight:
		dir = 1
	else:
		dir = -1
	platformRay.position.x = 15 * dir


func neverWalkAlone():
	if isDead:
		return
	standing=false
	walk()

func _on_AudioStreamSheep_finished():
	neverWalkAlone()

func _on_AudioStreamLamb_finished():
	neverWalkAlone()

