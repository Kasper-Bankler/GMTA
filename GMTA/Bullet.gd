extends Area2D

onready var audio_player=$gunshot
onready var animated_sprite=$AnimatedSprite
var facing=-1
var speed=1500
var hit=false
var finished_playing=false
var hit_wall=false
var hit=false
func _ready():
	if facing==-1:
		animated_sprite.flip_h=true
	audio_player.play()
	animated_sprite.play("default")
	
func _physics_process(delta):
	if hit_wall:
		return
	global_position.x +=facing*speed*delta




func _on_gunshot_finished():
	if finished_playing:
		queue_free()
	finished_playing = true


func _on_AnimatedSprite_animation_finished():
	queue_free() # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	if finished_playing:
		queue_free()
	finished_playing = true	


func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies") and !hit:
		hit=true
		body.take_damage(1)
		$CollisionShape2D.queue_free()
	
	
	hit_wall=true
	hide()


