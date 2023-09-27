extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
@onready var collisionShape = $CollisionShape2D
@onready var audioPlayer = $AudioStreamPlayer
@onready var timer = $Timer


var standing = false
var rng = RandomNumberGenerator.new()
var num
var isDead = false
var dir = 1
const SPEED = 10.0
var goingRight = true
# Get the gravity from the project settings to be synced with RigidBody nodes.

var player = null

func _ready():
	timer.start()
	
	
	
func _physics_process(delta):
	if isDead:
		return
	elif not is_on_floor():
		velocity.y += 90 * delta
	move_and_slide()

func _process(delta):
	if Input.is_action_pressed("kill"):
		dead()


func _on_timer_timeout():
	num = rng.randi_range(0,10)
	print(num)
	if num == 1:
		anim.play("idle")
		timer.start()
		velocity.x = 0
		audioPlayer.play()
	elif goingRight:
		dir = 1
		anim.flip_h = false
		velocity.x = SPEED * dir
		anim.play("walk")
		goingRight = false
		timer.start()
	elif goingRight == false:
		dir = -1
		velocity.x = SPEED * dir
		anim.flip_h = true
		anim.play("walk")
		goingRight = true
		timer.start()

func dead():
	print("dead")
	if (not isDead):
		collisionShape.queue_free()
		isDead=true
		scale *= 2
		anim.play("death",3)

func _on_animated_sprite_2d_animation_looped():
	if (anim.animation=="death"):
		queue_free()
