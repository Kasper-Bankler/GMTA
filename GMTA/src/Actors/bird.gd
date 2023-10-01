extends Actor

onready var anim = $AnimatedSprite
onready var collisionShape = $CollisionShape2D
onready var audioPlayerExplode = $AudioStreamExplode
onready var audioPlayerNoise = $AudioStreamNoise

var isChasing = false
var isDead = false
var dir = 1
const SPEED = 80.0
const damage = 10
var goingRight = true
export var this_health=1
var playedSound=false
# Get the gravity from the project settings to be synced with RigidBody nodes.

var player = null

func _ready():
	set_physics_process(false)
	player = get_tree().get_nodes_in_group("player")[0]
	assert(player!=null)
	add_to_group("enemies")
	audioPlayerNoise.play()
	
	
func _physics_process(delta):
	if !playedSound:
		audioPlayerNoise.play()
	if isDead:
		return
	if this_health<1:
		dead()
		return
	chase()
	_velocity.y *= 2
	move_and_slide(_velocity, FLOOR_NORMAL)


func chase():
	if isDead:
		return
	if player.global_position.x-global_position.x < 0:
		anim.flip_h = true
		anim.play("walk",2)
		_velocity = global_position.direction_to(player.global_position)*SPEED*3

	elif player.global_position.x-global_position.x > 0:
		anim.flip_h = false
		anim.play("walk",2)
		_velocity = global_position.direction_to(player.global_position)*SPEED*3

		
	
	if (player.global_position-global_position).length() < 50:
		PlayerData.take_damage(damage)
		dead()

func dead():
	print("bird")
	if (not isDead):
		print("dead")
		remove_from_group("enemies")
		collisionShape.queue_free()
		isDead=true
		scale *= 2
		audioPlayerExplode.stop()
		audioPlayerNoise.stop()
		audioPlayerExplode.play()
		anim.play("explode")

func take_damage(damage):
	this_health-=damage
	
	
	
func _on_AnimatedSprite_animation_finished():
	if (anim.animation=="explode"):
		
		queue_free()

