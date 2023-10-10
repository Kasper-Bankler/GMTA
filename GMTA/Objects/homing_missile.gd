extends Area2D

onready var gun_shot=$gunshot
onready var animated_sprite=$Animation
onready var explosion_audio=$ExplosionAudio
onready var explosion_area=$ExplosionArea/CollisionShape2D
onready var explosion_parent=$ExplosionArea
onready var kasper_player_hit_timer=$KasperPlayerHitTimer
signal rocket_shot_signal()

var player
var locked_on=false
var drag_factor=0.04
var current_velocity=Vector2.ZERO
var facing=-1
var speed=200
var max_speed=500
var finished_playing=false
var initial_hit=false
var missile_target:Node
var new_explosion_area
var KasperMaHitPlayer=false
var player_damage_crhstian_er_autist=false


func _ready():
	new_explosion_area=explosion_area.duplicate()
	explosion_area.queue_free()
	initial_hit=false
	gun_shot.play()
	player=get_tree().get_nodes_in_group("player")[0]
	current_velocity=max_speed*Vector2(facing,0).rotated(rotation)*2
	animated_sprite.play("default")


func _physics_process(delta: float) -> void:
	if (initial_hit):
		return

	if (missile_target.isDead):
		explode()
		return
	if (missile_target):
		var dir = global_position.direction_to(missile_target.global_position)
		var desired_velocity = dir * max_speed
		var change = (desired_velocity-current_velocity)* drag_factor
		current_velocity+=change
		if (change.length()<10 and not locked_on):
			locked_on=true
			gun_shot.play(4.0)
		position += current_velocity*delta
		look_at(global_position+current_velocity)
	else:
		queue_free()



func _on_gunshot_finished():
	if (not initial_hit):
		gun_shot.play(4.0)
		


func explode():
	initial_hit=true
	if (explosion_parent.get_child_count()==0):
		explosion_parent.add_child(new_explosion_area)
	animated_sprite.play("explode")
	gun_shot.stop()
	explosion_audio.play()
	animated_sprite.scale*=10
	emit_signal("rocket_shot_signal")

func _on_Homing_Area2D_body_entered(body):

	if (body.is_in_group("enemies") and not initial_hit):
		global_position=body.global_position
		initial_hit=true
		explode()
		
	if body==player and KasperMaHitPlayer and !initial_hit:
		initial_hit=true
		explode()

func _on_Animation_animation_finished():
	if(animated_sprite.animation=="explode"):
		queue_free()


func _on_ExplosionArea_body_entered(body):
	if !initial_hit:
		return
		
	if (body.is_in_group("enemies")):
		body.take_damage(10)
	if body==player and !player_damage_crhstian_er_autist:
		PlayerData.take_damage(50)
		player_damage_crhstian_er_autist=true


func _on_KasperPlayerHitTimer_timeout():
	KasperMaHitPlayer=true
